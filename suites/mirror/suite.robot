*** Settings ***
Resource  ../../src/src.robot
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot
Suite Teardown  Postcondition


*** Variables ***
${wait}  30
${tender_body}  css=.panel-body
${search field}  //*[@data-qa='search-phrase']//input
${search button}  //*[@data-qa='search-phrase']//button
${select status button}  //*[@data-qa='search-tenderStatuses']
${select type bidding button}  //*[@data-qa='search-biddingTypes']
${negative result}   css=h5


*** Test Cases ***
Відкрити потрібну сторінку
  #${start_page}  Run Keyword If  "${copie}" == "test"  Set Variable  http://test.smarttender.biz/TenderMirror/?mirrorId=1
  #...  ELSE IF  "${copie}" == "prod"  Set Variable  http://smarttender.biz/TenderMirror/?mirrorId=1
  ${start_page}  Set Variable  http://test.smarttender.biz/TenderMirror/?mirrorId=1
  Open Browser  ${start_page}  ${browser}  alies
  Дочекатись закінчення загрузки сторінки(skeleton)
  Sleep  1


Порахувати кількість тендерів
  ${count}  Get Element Count  ${tender_body}
  Run Keyword if  '${count}' == '0'  Fail  Page doesn't contain tenders


Перевірити наявність елементів
  Page Should Contain Element  ${search field}
  Page Should Contain Element  ${search button}
  Page Should Contain Element  ${select status button}
  Page Should Contain Element  ${select type bidding button}


Виконати негативний пошук
  Input text  ${search field}  Тендернезнайдено.Тадам!
  Дочекатись закінчення загрузки сторінки
  Click Element  ${search button}
  Дочекатись закінчення загрузки сторінки
  Sleep  .5
  ${is}  Get Text  ${negative result}
  Should Be Equal  ${is}  За Вашим запитом нічого не знайдено


Переглянути архів зі статусом Завершено
  Використати фільтр  ${select status button}  Завершено


Відфільтрувати по статусу Прийом пропозицій
  Використати фільтр  ${select status button}  Прийом пропозицій


Відфільтрувати по типу Допорогові закупівлі
  Використати фільтр  ${select type bidding button}  Допорогові закупівлі


Відфільтрувати по типу Відкриті торги з публікацією англійською мовою
  Використати фільтр  ${select type bidding button}  Відкриті торги з публікацією англійською мовою


Відфільтрувати по типу Конкурентний діалог 1-ий етап
  Використати фільтр  ${select type bidding button}  Конкурентний діалог 1-ий етап


Відфільтрувати по типу Звіт про укладений договір
  Використати фільтр  ${select type bidding button}  Звіт про укладений договір


*** Keywords ***
Postcondition
  Close All Browsers


Використати фільтр
  [Arguments]  ${field}  ${value}
  Reload Page
  CLick Element  ${field}
  Wait Until Page Contains Element  //li[@class='ivu-select-group']//li[contains(text(), '${value}')]
  Sleep  2
  Click Element  //li[@class='ivu-select-group']//li[contains(text(), '${value}')]
  Дочекатись закінчення загрузки сторінки(skeleton)
  Page Should Contain Element  //*[@class="panel-body"]//div[@style and contains(text(), "${value}")]|//*[@class="panel-footer"]//*[contains(text(), "${value}")]