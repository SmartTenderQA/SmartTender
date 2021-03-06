*** Settings ***
Resource  ../../src/src.robot
Suite Setup                     Preconditions
Suite Teardown                  Close All Browsers
Test Teardown                   Run Keywords
                                  ...  Log  ${checked_single}  WARN  AND
                                  ...  Log  ${checked_multiple}  WARN  AND
                                  ...  Log Location  AND
                                  ...  Run Keyword If Test Failed  Capture Element Screenshot  //body

# Команда запуска
# robot --noncritical non-critical --consolecolors on -L TRACE:INFO -v user:test_viewer -v capability:chrome -v hub:None -d test_output suites/other/check_multilots_on_search_page.robot


*** Variables ***
${checked_single}              ${false}
${checked_multiple}            ${false}
${multilot}                    //span[@class='Multilots']/ancestor::tr


*** Test Cases ***
Перевірка мультилотів на сторінці пошука
  :FOR  ${page}  IN RANGE  1  7
  \  Перейти на сторінку  ${page}
  \  ${mulilots_on_page}  Підрахувати кількість мультилотів на сторінці
  \  Розгорнути мультилотові тендери та перевірити їхні лоти  ${mulilots_on_page}


*** Keywords ***
Розгорнути мультилотові тендери та перевірити їхні лоти
  [Arguments]  ${mulilots_on_page}
  :FOR  ${item}  IN RANGE  1  ${mulilots_on_page} + 1
  \  Розгорнути мультилотовий тендер  ${item}
  \  Перевірити лоти в мультилотовому тендері  ${item}


Завершити виконання тесту якщо умови виконані
  Pass Execution If  ${checked_single} == ${true} and ${checked_multiple} == ${true}  Всі типи тендерів перевірено


Отримати локатор потрібного тендера
  [Arguments]  ${item}
  ${multi_lot_selector}  Set Variable  (${multilot})[${number}]
  [Return]  ${multi_lot_selector}


Розгорнути мультилотовий тендер
  [Arguments]  ${number}
  ${multi_lot_selector}  Set Variable  (${multilot})[${number}]
  ${tender_info}  Get Text  xpath=${multi_lot_selector}/td[@class="col1"]/span
  Scroll Page To Element XPATH   xpath=${multi_lot_selector}
  Click Element  xpath=${multi_lot_selector}/td/span
  ${detailed_tender_info}  Get Text  xpath=${multi_lot_selector}/following-sibling::tr[@class="content"]//td[@colspan="2"]
  ${status}  Run Keyword And Return Status  Should Be Equal  ${tender_info}  ${detailed_tender_info}
  Run Keyword If  ${status} == ${false}  Розгорнути мультилотовий тендер  ${number}


Перевірити лоти в мультилотовому тендері
  [Arguments]  ${multiple tender number}
  ${lots_quantity}  Порахувати кількість лотів в тендері  ${multiple tender number}
  Перевірити кожний лот окремо  ${lots_quantity}  ${multiple tender number}


Перевірити кожний лот окремо
  [Arguments]  ${lots_quantity}  ${number of multiple tender}
  :FOR  ${lot number}  IN RANGE  1  ${lots_quantity} + 1
  \  Перейти на сторінку лота та перевірити назву  ${lot number}  ${number of multiple tender}
  Run Keyword If  ${lots_quantity} == ${1}  Run Keywords
  ...  Set Global Variable  ${checked_single}  ${true}  AND  Log  ${checked_single}  WARN  ELSE
  ...  Run Keywords  Set Global Variable  ${checked_multiple}  ${true}  AND  Log  ${checked_multiple}  WARN
  Завершити виконання тесту якщо умови виконані


Порахувати кількість лотів в тендері
  [Arguments]  ${multiple tender number}
  ${multi_lot_selector}  Set Variable  (${multilot})[${multiple tender number}]
  ${selector}  Set Variable  xpath=${multi_lot_selector}/following-sibling::*[1]//table[@class="lot-description"]//tr
  Wait until Element Is Visible  ${selector}
  ${elements_quantity}  Get Element Count  ${selector}
  ${lots_quantity}  Evaluate  ${elements_quantity} - 1
  [Return]  ${lots_quantity}


Перейти на сторінку лота та перевірити назву
  [Arguments]  ${lot number}  ${number of multiple tender}
  ${multi_lot_selector}  Set Variable  (${multilot})[${number of multiple tender}]
  ${lot title locator}  Set Variable
  ...    xpath=${multi_lot_selector}/following-sibling::*[1]//table[@class="lot-description"]//tr[${lot number}+1]/td[1]
  Scroll Page To Element XPATH  ${lot title locator}
  ${lot_title}  Get Text        ${lot title locator}
  ${selector}  Set Variable  xpath=${multi_lot_selector}/following-sibling::*[1]//table[@class="lot-description"]//tr[${lot number} + 1]/td[last()]/a[1]
  Scroll Page To Element XPATH   ${selector}
  Click Element  ${selector}
  Select Window  NEW
  Дочекатись закінчення загрузки сторінки
  Перевірити назву на сторінці лота  ${lot_title}
  Close Window
  Select Window  MAIN


Перевірити назву на сторінці лота
  [Arguments]  ${lot_title}
  ${text}  procurement_tender_detail.Отритами дані зі сторінки  ['title']
  Should Be Equal  ${text}  ${lot_title}



################################
#         Keywords             #
################################
Перейти на сторінку
  [Arguments]  ${page}
  Set Test Variable  ${page}
  Run Keyword If  ${page} == 6  Set Tags  non-critical
  Should Be True  ${page} != 6
  Run Keyword If  '${page}' != '1'  Run Keywords
  ...  Scroll Page To Element XPATH  //a[@class="pager-button" and text()=${page}]  AND
  ...  Click Element  //a[@class="pager-button" and text()=${page}]
  Run Keyword And Ignore Error  Видалити кнопку "Замовити звонок"


Підрахувати кількість мультилотів на сторінці
  #Дочекатись появи появи мультилоту або перейти до наступної сторінки
  ${mulilots_on_page}  Get Element Count  ${multilot}
  [Return]  ${mulilots_on_page}


*** Keywords ***
Preconditions
    Run Keyword If  '${where}' == 'test'  Set Global Variable  ${user}  test_viewer
	Run Keyword If  'prod' in '${where}'  Set Global Variable  ${user}  prod_viewer
    Open Browser In Grid  ${user}
    Натиснути на іконку з баннеру  Комерційні тендери SmartTender
    old_search.Активувати вкладку Державних закупівель