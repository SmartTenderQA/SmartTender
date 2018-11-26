*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Start in grid  ${user}
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot

# Команда запуска
# robot --consolecolors on -L TRACE:INFO -v user:viewer_test -v capability:chrome -v hub:None -d test_output suites/other/check_multilots_on_search_page.robot
*** Variables ***
${checked_single}              ${false}
${checked_multiple}            ${false}
${page_number}                 2


*** Test Cases ***
Відкрити сторінку з пошуком
	Натиснути На торговельний майданчик
	Перейти на сторінку публічні закупівлі


Перевірка мультилотів на сторінці пошука
  :FOR  ${i}  IN RANGE  1  5
  \  Видалити кнопку "Замовити звонок"
  \  ${mulilots_on_page}  Підрахувати кількість мультилотів на сторінці
  \  Перевірити мультилоти  ${mulilots_on_page}
  \  Вийти з цикола при необхідності
  \  Перейти на наступну сторінку


*** Keywords ***
Підрахувати кількість мультилотів на сторінці
  ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  //span[@class='Multilots']  15
  Wait Until Page Contains   Конкурентні процедури
  Run Keyword If  ${status} == ${false}  Перейти на наступну сторінку
  Continue For Loop If  ${status} == ${false}
  ${mulilots_on_page}  Get Element Count  //span[@class='Multilots']
  [Return]  ${mulilots_on_page}



Перевірити мультилоти
  [Arguments]  ${mulilots_on_page}
  :FOR  ${items}  IN RANGE  ${mulilots_on_page}
  \  Розкрити мультилот  ${items} + 1
  \  Перевірити лоти
  \  Вийти з цикола при необхідності


Вийти з цикола при необхідності
  Exit For Loop If  ${checked_single} == ${true} and ${checked_multiple} == ${true}


Розкрити мультилот
  [Arguments]  ${number}
  Set Global Variable  ${multi_lot_selector}  (//span[@class='Multilots']/ancestor::tr)[${number}]
  ${tender_info}  Get Text  xpath=${multi_lot_selector}/td[@class="col1"]/span
  Scroll Page To Element XPATH   xpath=${multi_lot_selector}
  Click Element  xpath=${multi_lot_selector}/td/span
  ${detailed_tender_info}  Get Text  xpath=${multi_lot_selector}/following-sibling::tr[@class="content"]//td[@colspan="2"]
  ${status}  Run Keyword And Return Status  Should Be Equal  ${tender_info}  ${detailed_tender_info}
  Run Keyword If  ${status} == ${false}  Розкрити мультилот  ${number}


Перевірити лоти
  ${selector}  Set Variable  xpath=${multi_lot_selector}/following-sibling::*[1]//table[@class="lot-description"]//tr
  Wait until Element Is Visible  xpath=${multi_lot_selector}/following-sibling::*[1]//table[@class="lot-description"]//tr
  ${elements_quantity}  Get Element Count  ${selector}
  ${lots_quantity}  Evaluate  ${elements_quantity} - 1
  Run Keyword If  ${lots_quantity} > ${1} and ${checked_multiple} == ${false}  Відкрити кожний лот  ${lots_quantity}
  ...  ELSE IF  ${lots_quantity} == ${1} and ${checked_single} == ${false}  Run Keywords  Перейти на сторінку лота  1
  ...  AND  Set Global Variable  ${checked_single}  ${true}


Відкрити кожний лот
  [Arguments]  ${lots_quantity}
  :FOR  ${items}  IN RANGE  ${lots_quantity}
  \  Перейти на сторінку лота  ${items} + 1
  Set Global Variable  ${checked_multiple}  ${true}


Перейти на сторінку лота
  [Arguments]  ${number}
  ${number}  Evaluate  ${number}
  ${lot_title}  Get Text  xpath=${multi_lot_selector}/following-sibling::*[1]//table[@class="lot-description"]//tr[${number}+1]/td[1]
  ${selector}  Set Variable  xpath=${multi_lot_selector}/following-sibling::*[1]//table[@class="lot-description"]//tr[${number} + 1]/td[last()]/a[1]
  Scroll Page To Element XPATH   ${selector}
  Click Element  ${selector}
  Select Window  NEW
  Дочекатись закінчення загрузки сторінки(skeleton)
  ${title_selector}  Set Variable  (//div[@data-qa="title"])[1]
  Wait Until Page Contains Element  ${title_selector}
  ${text}  Get Text  ${title_selector}
  Should Be Equal  ${text}  ${lot_title}
  Close Window
  Select Window  MAIN


Дочекатись закінчення загрузки сторінки(skeleton)
  Дочекатись закінчення загрузки сторінки по елементу  ${skeleton loading}


Перейти на наступну сторінку
    Click Element  //a[@class="pager-button" and text()=${page_number}]
    ${page_number}  Evaluate  ${page_number} + 1
    Set Global Variable  ${page_number}
