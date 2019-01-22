*** Settings ***
Resource  ../../src/src.robot

Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot

#  robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None -e get_tender suites/get_auction_href/test_open_eu_get_auction_href.robot
*** Test Cases ***
Підготувати користувачів
	Set Global Variable  ${tender_owner}  Bened
	Set Global Variable  ${provider1}  user1
	Set Global Variable  ${provider2}  user2
	Set Global Variable  ${provider3}  user3
	Set Global Variable  ${viewer}  test_viewer
    Додати першого користувача  ${tender_owner}
    Додати користувача          ${provider1}
    Додати користувача          ${provider2}
    Додати користувача          ${provider3}
    Додати користувача          ${viewer}


Створити тендер
    [Setup]  Set Window Size  1440  900
	[Tags]  create_tender
	Завантажити сесію для  ${tender_owner}
	test_open_eu.Створити тендер
    test_open_eu.Отримати дані тендера та зберегти їх у файл


Отримати дані з cdb
    [Tags]  create_tender
    Завантажити сесію для  ${provider1}
    Go to  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact_data.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Валідфція введених даних з даними в ЦБД
    [Tags]  view
    [Template]  procurement_tender_detail.Порівняти введені дані з даними в ЦБД
    \['title']
    \['description']
    \['tenderID']
    \['items'][0]['description']
    \['items'][0]['deliveryAddress']['locality']
    \['items'][0]['deliveryAddress']['streetAddress']
    \['items'][0]['deliveryAddress']['postalCode']
    \['items'][0]['classification']['id']
    \['items'][0]['classification']['description']
    \['items'][0]['unit']['name']
    \['items'][0]['quantity']
    \['tenderPeriod']['endDate']
    \['value']['amount']
    \['minimalStep']['amount']


Валідфція даних на сторінці з даними в ЦБД
    [Tags]  view
    [Template]  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД
    \['title']
    \['description']
    \['tenderID']
    \['items'][0]['description']
    \['items'][0]['deliveryAddress']['locality']
    \['items'][0]['deliveryAddress']['streetAddress']
    \['items'][0]['deliveryAddress']['postalCode']
    \['items'][0]['classification']['id']
    \['items'][0]['classification']['description']
    \['items'][0]['unit']['name']
    \['items'][0]['quantity']
    \['tenderPeriod']['endDate']
    \['value']['amount']
    \['minimalStep']['amount']


Подати заявку на участь в тендері двома учасниками
	Прийняти участь у тендері учасником  ${provider1}
	Прийняти участь у тендері учасником  ${provider2}



Підготувати користувача та дочекатись початку періоду перкваліфікації
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Завантажити сесію для  ${provider1}
    Go to  ${data['tender_href']}
    procurement_page_keywords.Дочекатись початку періоду перкваліфікації


Відкрити браузер під роллю організатора та знайти тендер
    Завантажити сесію для  ${tender_owner}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}


Підтвердити прекваліфікацію для доступу до аукціону організатором
    qualification.Провести прекваліфікацію учасників


Отримати поcилання на участь в аукціоні для учасників
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  ${provider1}
    Go to  ${data['tender_href']}
    procurement_page_keywords.Дочекатись закінчення прийому пропозицій
	procurement_tender_detail.Дочекатися статусу тендера  Аукціон
    Wait Until Keyword Succeeds  20m  10  Перевірити отримання посилань на аукціон учасником  ${provider1}


Отримати поcилання на перегляд аукціону
	:FOR  ${i}  IN  ${tender_owner}  ${viewer}  #provider3
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
	\  ${auction_href}  get_auction_href.Отримати посилання на прегляд аукціону не учасником
	\  Run Keyword And Expect Error  *  get_auction_href.Отримати посилання на участь та прегляд аукціону для учасника



*** Keywords ***
Отримати дані з cdb та зберегти їх у файл
    [Tags]  create_tender
    ${id}  procurement_tender_detail.Отритами дані зі сторінки  ['id']
    ${cdb}  Отримати дані тендеру з cdb по id  ${id}
    Set Global Variable  ${cdb}
    actions.Зберегти словник у файл  ${cdb}  cdb


Прийняти участь у тендері учасником
    [Arguments]  ${username}
    Завантажити сесію для  ${username}
    Go to  ${data['tender_href']}
    procurement_tender_detail.Дочекатися статусу тендера  Прийом пропозицій
    Run Keyword If  '${username}' == '${provider1}'  Sleep  3m
    Подати пропозицію учасником


Подати пропозицію учасником
	Перевірити кнопку подачі пропозиції
	Заповнити поле з ціною  1  1
    actions.Додати doc файл
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
    Go Back


Перевірити отримання посилань на аукціон учасником
    [Arguments]  ${username}
    Завантажити сесію для  ${username}
    Go To  ${data['tender_href']}
	${auction_participate_href}  ${auction_href}
	...  get_auction_href.Отримати посилання на участь та прегляд аукціону для учасника
	Wait Until Keyword Succeeds  60  3  Перейти та перевірити сторінку участі в аукціоні  ${auction_participate_href}


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Location Should Contain  bidder_id=
	Підтвердити повідомлення про умови проведення аукціону
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  30
	Sleep  2
	Element Should Contain  //*[@class="page-header"]//h2  ${data['tenderID']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items'][0]['description']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items'][0]['quantity']}
	${unit name status}  Run Keyword And Return Status
	...  Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items'][0]['unit']['name']}
	${status}  Run Keyword And Return Status
	...  Element Should Contain  //h4  Ви зареєстровані як учасник. Очікуйте старту аукціону.
	Run Keyword If  ${status} != ${True}  Element Should Contain  //h4  Вхід на даний момент закритий.
    Go Back