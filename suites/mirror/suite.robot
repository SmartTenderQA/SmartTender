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
${search-organizers}  //*[@data-qa="search-organizers"]
${negative result}   css=h5

${test_start_page}  http://test.smarttender.biz/TenderMirror/?mirrorId=1
${utg_start_page}  http://utg.ua/utg/purchases/prozorro.html
${ukroboronprom_start_page}  https://smarttender.biz/TenderMirror/?mirrorId=5804
${uspa_start_page}  http://www.uspa.gov.ua/ru/gosudarstvennye-zakupki/elektronnaya-ploshchadka-smarttender-biz



*** Test Cases ***
Відкрити тестову сторінку
  [Tags]  test  utg  ukroboronprom  uspa
  ${start_page}  Run Keyword If  '${site}' == 'test'  Set Variable  ${test_start_page}
  ...  ELSE IF  '${site}' == 'utg'  Set Variable  http://utg.ua/utg/purchases/prozorro.html
  ...  ELSE IF  '${site}' == 'ukroboronprom'  Set Variable  https://smarttender.biz/TenderMirror/?mirrorId=5804
  ...  ELSE IF  '${site}' == 'uspa'  Set Variable  http://www.uspa.gov.ua/ru/gosudarstvennye-zakupki/elektronnaya-ploshchadka-smarttender-biz
  Open Browser  ${start_page}  ${browser}  alies
  Виділити портрібний iFrame
  Дочекатись закінчення загрузки сторінки(skeleton)
  Sleep  1


Порахувати кількість тендерів
  [Tags]  test  utg  ukroboronprom  uspa
  ${count}  Get Element Count  ${tender_body}
  Run Keyword if  '${count}' == '0'  Fail  Page doesn't contain tenders


Перевірити наявність елементів
  [Tags]  test  utg  ukroboronprom  uspa
  Page Should Contain Element  ${search field}
  Page Should Contain Element  ${search button}


Виконати негативний пошук
  [Tags]  test  utg  ukroboronprom  uspa
  Input text  ${search field}  Тендернезнайдено.Тадам!
  Дочекатись закінчення загрузки сторінки
  Click Element  ${search button}
  Дочекатись закінчення загрузки сторінки
  Sleep  .5
  ${is}  Get Text  ${negative result}
  Should Be Equal  ${is}  За Вашим запитом нічого не знайдено


Переглянути архів зі статусом Завершено
  [Tags]  test  uspa
  Використати фільтр  ${select status button}  Завершено


Відфільтрувати по статусу Прийом пропозицій
  [Tags]  test  utg  uspa
  Використати фільтр  ${select status button}  Прийом пропозицій


Відфільтрувати по типу Допорогові закупівлі
  [Tags]  test  utg  uspa
  Використати фільтр  ${select type bidding button}  Допорогові закупівлі


Відфільтрувати по типу Відкриті торги з публікацією англійською мовою
  [Tags]  test  utg  uspa
  Використати фільтр  ${select type bidding button}  Відкриті торги з публікацією англійською мовою


Відфільтрувати по типу Конкурентний діалог 1-ий етап
  [Tags]  test
  Використати фільтр  ${select type bidding button}  Конкурентний діалог 1-ий етап


Відфільтрувати по типу Звіт про укладений договір
  [Tags]  test  uspa
  Використати фільтр  ${select type bidding button}  Звіт про укладений договір


Відфільтрувати по типу Відкриті торги. Аукціон
  [Tags]  ukroboronprom
  Використати фільтр  ${select type bidding button}  Відкриті торги. Аукціон


Відфільтрувати по типу Запит пропозицій
  [Tags]  ukroboronprom
  Використати фільтр  ${select type bidding button}  Запит пропозицій


*** Keywords ***
Postcondition
  Close All Browsers


Використати фільтр
  [Arguments]  ${field}  ${value}
  Reload Page
  Виділити портрібний iFrame
  CLick Element  ${field}
  Wait Until Page Contains Element  //li[contains(text(), '${value}')]
  Sleep  2
  Click Element  //li[contains(text(), '${value}')]
  Дочекатись закінчення загрузки сторінки(skeleton)
  Page Should Contain Element  //*[@class="panel-body"]//div[@style and contains(text(), "${value}")]|//*[@class="panel-footer"]//*[contains(text(), "${value}")]


Виділити портрібний iFrame
  Run Keyword If  '${site}' == 'utg'
  ...  Select Frame  css=iframe[src='https://smarttender.biz/TenderMirror?mirrorId=1']
  ...  ELSE IF  '${site}' == 'uspa'  Select Frame  css=iframe[src='https://smarttender.biz/tendermirror/?mirrorId=3']