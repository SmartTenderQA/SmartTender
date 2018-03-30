*** Settings ***
Resource  ../../src/src.robot
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot
Suite Teardown  Postcondition


*** Variables ***
${wait}  30
${mirror page}  http://test.smarttender.biz/TenderMirror/?mirrorId=1
${tender_body}  css=.panel-body
${search field}  css=input#Phrase
${search button}  css=input#btnSubmit
${select status button}  css=select#TenderStatuses
${select type bidding button}  css=select#BiddingTypeCodes
${active tenders tab}  xpath=//*[@onclick="changeTradeStatusesType(1); "]
${archive tab}  xpath=//*[@onclick="changeTradeStatusesType(2); "]
${negative result}  css=#tendersSearchResult .text-center


*** Test Cases ***
Відкрити потрібну сторінку
  Open Browser  ${mirror page}  ${browser}  alies

Порахувати кількість тендерів
  ${count}  Get Element Count  ${tender_body}
  Run Keyword if  '${count}' == '0'  Fail  Page doesn't contain tenders

Перевірити наявність елементів
  Page Should Contain Element  ${search field}
  Page Should Contain Element  ${search button}
  Page Should Contain Element  ${select status button}
  Page Should Contain Element  ${select type bidding button}
  Page Should Contain Element  ${active tenders tab}
  Page Should Contain Element  ${archive tab}

Виконати негативний пошук
  Click Element  ${active tenders tab}
  Input text  ${search field}  Тендернезнайдено.Тадам!
  Wait Until Element Is Not Visible  ${loading}  ${wait}
  Click Element  ${search button}
  Run Keyword And Ignore Error  Wait Until Page Contains Element  ${loading}
  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${loading}  ${wait}
  Sleep  .5
  ${is}  Get Text  ${negative result}
  ${should}  Set Variable  За Вашим запитом нічого не знайдено
  Should Be Equal  ${is}  ${should}

Переглянути архів
  Reload Page
  Click Element  ${archive tab}
  Run Keyword And Ignore Error  Wait Until Page Contains Element  ${loading}
  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${loading}  ${wait}
  Sleep  .5
  ${count}  Get Element Count  ${tender_body}
  Run Keyword if  '${count}' == '0'  Fail  Page doesn't contain tenders

*** Keywords ***
Postcondition
  Close All Browsers