*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Setup  ${user}
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot

# Команда запуска проверки коммерческих
# robot --consolecolors on -L TRACE:INFO -v user:viewer_test -v browser:chrome -d test_output -i commercial -v hub:None suites/other/check_docs_in_auctions.robot

# Команда запуска проверки прозорро
# robot --consolecolors on -L TRACE:INFO -v user:test_viewer -v browser:chrome -d test_output -i procurement -v hub:None suites/other/check_docs_in_auctions.robot
*** Variables ***
${type}
${site}                        prod
${page_number}                 2
&{checks}                      checked_doc=${false}  checked_docx=${false}  checked_image=${false}  checked_pdf=${false}  checked_signature=${false}
@{image_format}                png  jpg  jpeg  gif  gif  tif  tiff  bmp


*** Test Cases ***
Зайти на стоінку закупівель
  [Tags]  commercial
  Set Global Variable  ${type}  com
  Set To Dictionary  ${checks}  checked_signature=${true}
  Зайти на торговий майданчик


Перевірка тендерів на сторінці пошука
  [Tags]  commercial
  :FOR  ${pages}  IN RANGE  1  5
  \  ${tenders_on_page}  Підрахувати кількість тендерів на сторінці
  \  Видалити кнопку "Замовити звонок"
  \  Видалити кнопку "Поставити запитання"
  \  Перевірити тендери  ${tenders_on_page}
  \  Run Keyword  Завершити виконання тесту${site}
  \  Перейти на наступну сторінку


Зайти на стоінку закупівель
  [Tags]  procurement
  Set Global Variable  ${type}  proz
  Зайти на торговий майданчик
  old_search.Активувати вкладку Державних закупівель


Перевірка тендерів на сторінці пошука
  [Tags]  procurement
  :FOR  ${pages}  IN RANGE  1  5
  \  ${tenders_on_page}  Підрахувати кількість тендерів на сторінці
  \  Видалити кнопку "Замовити звонок"
  \  Видалити кнопку "Поставити запитання"
  \  Перевірити тендери  ${tenders_on_page}
  \  Run Keyword  Завершити виконання тесту${site}
  \  Перейти на наступну сторінку


Зайти на сторінку банківських аукціонів
  [Tags]  bank_aucs
  Set Global Variable  ${type}  proz
  Зайти на торговий майданчик
  Зайти на сторінку банківських аукціонів


Перевірка тендерів на сторінці пошука
  [Tags]  bank_aucs
  :FOR  ${pages}  IN RANGE  1  5
  \  ${tenders_on_page}  Підрахувати кількість тендерів на сторінці
  \  Видалити кнопку "Замовити звонок"
  \  Видалити кнопку "Поставити запитання"
  \  Відкрити сторінку аукціона та перевірити документи  ${tenders_on_page}
  \  Завершити перевірку аукціонів
  \  Перейти на наступну сторінку


*** Keywords ***
Setup
  [Arguments]  ${user}  ${alies}=alies
  clear_test_output
  ${status}  Run Keyword And Return Status  Should Contain  ${user}  prod
  Run Keyword If  ${status} == ${true}  Set To Dictionary  ${checks}  checked_image=${true}
  ...  ELSE  Set Global Variable  ${site}  test
  ${login}  ${password}  Отримати дані користувача  ${user}
  ${start_page}  Отримати стартову сторінку  ${site}
  Змінити стартову сторінку для IP
  #Open Browser  ${start_page}  ${browser}  ${alies}  ${grid}
  Run Keyword If  '${capability}' == 'chrome'    Open Browser  ${start_page}  chrome   ${alies}  ${hub}  platformName:WIN10
  ...  ELSE IF    '${capability}' == 'chromeXP'  Open Browser  ${start_page}  chrome   ${alies}  ${hub}  platformName:XP
  ...  ELSE IF    '${capability}' == 'firefox'   Open Browser  ${start_page}  firefox  ${alies}  ${hub}
  ...  ELSE IF    '${capability}' == 'edge'      Open Browser  ${start_page}  edge     ${alies}  ${hub}
  Run Keyword If  "${role}" != "viewer"  Авторизуватися  ${login}  ${password}


Перейти на наступну сторінку
  ${selector}  Set Variable  //a[@class="pager-button" and text()=${page_number}]
  ${status}  Run Keyword And Return Status  Element Should Be Visible  ${selector}
# Вийти з цикла якщо не існує наступної сторінки
  Run Keyword If  ${status} == ${false}  Exit For Loop
  Click Element  ${selector}
  ${page_number}  Evaluate  ${page_number} + 1
  Set Global Variable  ${page_number}


Завершити виконання тестуtest
  ${status}  Run keyword and return status  Dictionary Should Contain Value  ${checks}  ${true}
  Exit For Loop If  ${checks.checked_doc} == ${true} or ${checks.checked_docx} == ${true} or ${checks.checked_pdf} == ${true} or ${checks.checked_image} == ${true}


Завершити виконання тестуprod
  ${status}  Run keyword and return status  Dictionary Should Not Contain Value  ${checks}  ${false}
  Exit For Loop If  ${status} == ${true}


Завершити перевірку аукціонів
  ${status}  Run keyword and return status  Dictionary Should Contain Value  ${checks}  ${true}
  Exit For Loop If  ${status} == ${true}


Зайти на торговий майданчик
  Натиснути На торговельний майданчик
  Wait Until Element Is Visible  //div[@id="MainMenuTenders"]//li[2]/a


Зайти на сторінку банківських аукціонів
  Wait Until Element Is Visible  //div[@id="MainMenuTenders"]//li[3]/a
  Click Element  //div[@id="MainMenuTenders"]//li[3]/a
  Wait Until Element Is Visible  //*[contains(@class, "btn-search")]//*
  Click Element  //*[contains(@class, "btn-search")]//*


Зайти на сторінку комерційних закупівель
  Wait Until Element Is Visible  //div[@id="MainMenuTenders"]//li[1]/a
  Click Element  //div[@id="MainMenuTenders"]//li[1]/a
  Wait Until Page Contains   Закупівлі


Підрахувати кількість тендерів на сторінці
  ${selector}  Set Variable  //tr[@class="head"]
  Wait Until Element Is Visible  ${selector}
  ${tenders_on_page}  Get Element Count  ${selector}
  [Return]  ${tenders_on_page}


Перевірити тендери
  [Arguments]  ${tenders_on_page}
  :FOR  ${items}  IN RANGE  1  ${tenders_on_page}+1
  \  Розкрити тендер  ${items}
  \  ${doc_quantity}  Перевірити наявність документів в тендері  ${items}
  \  Continue For Loop If  ${doc_quantity} < 1
  \  Перевірити документ  ${doc_quantity}
  \  Run Keyword  Завершити виконання тесту${site}


Розкрити тендер
  [Arguments]  ${number}
  Set Global Variable  ${tender_selector}  (//tr[@class="head"])[${number}]
  ${selector}  Set Variable  xpath=${tender_selector}/following-sibling::tr[@class="content"]//td[@colspan="2"]
  ${tender_info}  Get Text  xpath=${tender_selector}/td[@class="col1"]/span
  Click Element  xpath=${tender_selector}/td/span
  Execute JavaScript    window.scrollBy(30,0)
  Sleep  .5
  Click Element  xpath=(//h3[@class="tender-header-row"])[${number}]
  Wait Until Element Is Visible  ${selector}


Перевірити наявність документів в тендері
  [Arguments]  ${number}
  Дочекатись загрузки документів в тендері
  ${status}  Run Keyword And Return Status  Page Should Contain Element  xpath=${tender_selector}/following-sibling::tr//*[@class="item"]/a[@href]
  Run Keyword If  ${status} == ${true}  Wait Until Element Is Visible  xpath=${tender_selector}/following-sibling::tr//*[@class="item"]/a[@href]
  ${doc_quantity}  Get Element Count  xpath=${tender_selector}/following-sibling::tr//*[@class="item"]/a[@href]
  Set Global Variable  ${tender_number}  ${number}
  [Return]  ${doc_quantity}

Перевірити документ
  [Arguments]  ${doc_quantity}
  :FOR  ${items}  IN RANGE  1  ${doc_quantity}+1
  \  ${move_next}  Визначити необхідність перевірки документу  ${items}
  \  Continue For Loop If  ${move_next} == ${true}
  \  Run Keyword  Відкрити сторінку тендера${type}  ${items}


Визначити необхідність перевірки документу
  [Arguments]  ${doc_number}
  ${doc_title}  Get Text  xpath=(${tender_selector}/following::div[@class="item"])[${doc_number}]//span
  Set Global Variable  ${doc_title}
  ${doc_type}  Fetch From Right  ${doc_title}  .
  ${doc_type}  Convert To Lowercase  ${doc_type}
  Set Global Variable  ${doc_type}
  ${status}  Run Keyword And Return Status  List Should Contain Value  ${image_format}  ${doc_type}
  ${move_next}  Run Keyword If  "${doc_type}" == "doc" and ${checks.checked_doc} == ${false}
  ...  Set To Dictionary  ${checks}  checked_doc=${true}
  ...  ELSE IF  "${doc_type}" == "docx" and ${checks.checked_docx} == ${false}
  ...  Set To Dictionary  ${checks}  checked_docx=${true}
  ...  ELSE IF  ${status} and ${checks.checked_image} == ${false}
  ...  Set To Dictionary  ${checks}  checked_image=${true}
  ...  ELSE IF  "${doc_type}" == "pdf" and ${checks.checked_pdf} == ${false}
  ...  Set To Dictionary  ${checks}  checked_pdf=${true}
  ...  ELSE IF  "${doc_type}" == "p7s" and ${checks.checked_signature} == ${false}
  ...  Set To Dictionary  ${checks}  checked_signature=${true}
  ...  ELSE  Set Variable  ${true}
  [Return]  ${move_next}


Відкрити сторінку тендераcom
  [Arguments]  ${doc_number}
  ${selector}  Set Variable  xpath=(//div[contains(@class, "filename")])
  ${button_selector}  Set Variable  xpath=(//a[contains(@class, "analysis-button")])[${tender_number}]
  Scroll Page To Element XPATH  ${button_selector}
  Sleep  .5
  Click Element  ${button_selector}
  Select Window  NEW
  Wait Until Page Contains  Інформація про тендер
  ${docs_on_page}  Get Element Count  ${selector}
  :FOR  ${doc}  IN RANGE  1  ${docs_on_page}+1
  \  Scroll Page To Element XPATH  ${selector}[${doc}]
  \  ${text}  Get Text  ${selector}[${doc}]
  \  ${status}  Run Keyword And Return Status  Should Contain  ${text}  ${doc_title}
  \  Set Suite Variable   ${doc}
  \  Exit For Loop If  ${status} == ${true}
  Mouse Over  ${selector}[${doc}]//span
  Wait Until Element Is Visible  xpath=(//*[@data-qa="file-download"])[${doc}]
  Sleep  .5
  Run Keyword If  "${doc_type}" != "p7s"  Виконати перевірку файлів комерційних торгів  ${doc}
  Close Window
  Select Window  MAIN

Відкрити сторінку аукціона та перевірити документи
  [Arguments]  ${aucs_on_page}
  :FOR  ${items}  IN RANGE  1  ${aucs_on_page}+1
  \  ${doc_type}  Відкрити сторінку аукціона  ${items}
  \  Завершити перевірку аукціонів


Відкрити сторінку аукціона
  [Arguments]  ${auc_number}
  ${selector}  Set Variable  (//div[contains(@class, "filename")])
  ${status}  Run Keyword And Return Status  Click Element  xpath=(//tr[@class="head"])[${auc_number}]//a
  Run Keyword If  ${status} == ${False}  Run Keywords  Scroll Page To Element XPATH  xpath=(//tr[@class="head"])[${auc_number}]//td[@class="col2"]
  ...  AND  Sleep  5
  ...  AND  Click Element  xpath=(//tr[@class="head"])[${auc_number}]//a
  Select Window  NEW
  Дочекатись закінчення загрузки сторінки(skeleton)
  ${docs_on_page}  Get Element Count  ${selector}
  :FOR  ${doc}  IN RANGE  1  ${docs_on_page}+1
  \  Scroll Page To Element XPATH  ${selector}[${doc}]
  \  ${doc_title}  Get Text  ${selector}[${doc}]//span
  \  ${doc_type}  Fetch From Right  ${doc_title}  .
  \  ${doc_type}  Convert To Lowercase  ${doc_type}
  \  Set Global Variable  ${doc_type}
  \  ${move_next}  Визначити необхідність перевірки файлу  ${doc_type}
  \  Continue For Loop If  ${move_next} == ${true}
  \  Mouse Over  ${selector}[${doc}]//span
  \  Wait Until Element Is Visible  xpath=(//*[@data-qa="file-download"])[${doc}]
  \  Sleep  .5
  \  Run Keyword If  "${doc_type}" != "p7s"  Виконати перевірку файлів торгів prozorro  ${doc}
  \  Завершити перевірку аукціонів
  Close Window
  Select Window  MAIN


Визначити необхідність перевірки файлу
  [Arguments]  ${doc_type}
  ${status}  Run Keyword And Return Status  List Should Contain Value  ${image_format}  ${doc_type}
  ${move_next}  Run Keyword If  "${doc_type}" == "doc" and ${checks.checked_doc} == ${false}
  ...  Set To Dictionary  ${checks}  checked_doc=${true}
  ...  ELSE IF  "${doc_type}" == "docx" and ${checks.checked_docx} == ${false}
  ...  Set To Dictionary  ${checks}  checked_docx=${true}
  ...  ELSE IF  ${status} and ${checks.checked_image} == ${false}
  ...  Set To Dictionary  ${checks}  checked_image=${true}
  ...  ELSE IF  "${doc_type}" == "pdf" and ${checks.checked_pdf} == ${false}
  ...  Set To Dictionary  ${checks}  checked_pdf=${true}
  ...  ELSE IF  "${doc_type}" == "p7s" and ${checks.checked_signature} == ${false}
  ...  Set To Dictionary  ${checks}  checked_signature=${true}
  ...  ELSE  Set Variable  ${true}
  [Return]  ${move_next}


Відкрити сторінку тендераproz
  [Arguments]  ${doc_number}
  ${selector}  Set Variable  (//div[contains(@class, "filename")])
  ${button_selector}  Set Variable  xpath=(//a[contains(@class, "analysis-button")])[${tender_number}]
  Scroll Page To Element XPATH  ${button_selector}
  Sleep  .5
  Click Element  ${button_selector}
  Select Window  NEW
  Дочекатись закінчення загрузки сторінки(skeleton)
  ${docs_on_page}  Get Element Count  ${selector}
  :FOR  ${doc}  IN RANGE  1  ${docs_on_page}+1
  \  Scroll Page To Element XPATH  ${selector}[${doc}]
  \  ${text}  Get Text  ${selector}[${doc}]
  \  ${status}  Run Keyword And Return Status  Should Contain  ${text}  ${doc_title}
  \  Set Suite Variable   ${doc}
  \  Exit For Loop If  ${status} == ${true}
  Mouse Over  ${selector}[${doc}]//span
  Wait Until Element Is Visible  xpath=(//*[@data-qa="file-download"])[${doc}]
  Sleep  .5
  Run Keyword If  "${doc_type}" != "p7s"  Виконати перевірку файлів торгів prozorro  ${doc}
  Close Window
  Select Window  MAIN


Виконати перевірку файлів комерційних торгів
  [Arguments]  ${doc_number}
  ${selector}  Set Variable  (//*[@data-qa="file-preview"])[${doc_number}]
  :FOR  ${i}  IN RANGE  10
  \  Open Button  ${selector}
  \  ${status}  Run Keyword And Return Status  Wait Until Page Does Not Contain Element  ${selector}
  \  Exit For Loop If  ${status} == ${true}
  ${lowercase_status}  Run Keyword And Return Status  Location Should Contain  ${doc_type}
  ${upper_doc_type}  Run Keyword If  ${lowercase_status} != ${true}  Convert To Uppercase  ${doc_type}
  Run Keyword If  ${lowercase_status} != ${true}  Location Should Contain  ${upper_doc_type}
  Check document for error


Виконати перевірку файлів торгів prozorro
  [Arguments]  ${doc_number}
  ${selector}  Set Variable  (//*[@data-qa="file-name"])[${doc_number}]/following::*[@data-qa="file-preview"]
  :FOR  ${i}  IN RANGE  10
  \  Open Button  ${selector}
  \  ${status}  Run Keyword And Return Status  Wait Until Page Does Not Contain Element  ${selector}
  \  Exit For Loop If  ${status} == ${true}
  Check document for error


Check document for error
  Run Keyword And Expect Error  *  Location Should Contain  error
  Run Keyword And Expect Error  *  Page Should Contain  an error
  Go Back


Дочекатись закінчення загрузки сторінки(skeleton)
  Дочекатись закінчення загрузки сторінки по елементу  ${skeleton loading}