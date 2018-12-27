*** Settings ***
Resource   ../../src/src.robot

Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot


#  robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None -n view -e get_tender suites/get_auction_href/test_below_get_auction_href.robot
*** Test Cases ***
Підготувати користувачів
    Додати першого користувача  Bened           tender_owner
    Додати користувача          user1           provider1
    Додати користувача          user2           provider2
    Додати користувача          user3           provider3
    Додати користувача          test_viewer     viewer


Створити тендер
	[Tags]  create_tender
	Завантажити сесію для  tender_owner
	test_below.Створити тендер
    test_below.Отримати дані тендера та зберегти їх у файл


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact_data.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Перевірка відображення даних створеного тендера на сторінці
    [Tags]  view
    Валідація введених даних з ЦБД та на сайті  provider1


Подати заявку на участь в тендері двома учасниками
	Прийняти участь у тендері учасником  provider1
	Прийняти участь у тендері учасником  provider2


Отримати поcилання на участь в аукціоні для учасників
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Дочекатись закінчення прийому пропозицій
	Дочекатися статусу тендера  Аукціон
    Wait Until Keyword Succeeds  10m  3  Перевірити отримання ссилки на участь в аукціоні  provider1


Неможливість отримати поcилання на участь в аукціоні
	[Template]  Перевірити можливість отримати посилання на аукціон користувачем
	viewer
	tender_owner
	provider3



*** Keywords ***
Валідація введених даних з ЦБД та на сайті
    [Arguments]  ${role}
    Завантажити сесію для  ${role}
    Go to  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл

    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['description']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['tenderID']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['description']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['deliveryAddress']['locality']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['deliveryAddress']['streetAddress']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['deliveryAddress']['postalCode']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['classification']['id']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['classification']['description']
    #procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['unit']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['quantity']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['tenderPeriod']['startDate']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['tenderPeriod']['endDate']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['enquiryPeriod']['endDate']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['value']['amount']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['minimalStep']['amount']

    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['title']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['description']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['tenderID']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['description']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['deliveryAddress']['locality']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['deliveryAddress']['streetAddress']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['deliveryAddress']['postalCode']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['classification']['id']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['classification']['description']
    #procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['unit']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['quantity']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['tenderPeriod']['startDate']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['tenderPeriod']['endDate']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['enquiryPeriod']['endDate']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['value']['amount']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['minimalStep']['amount']


Отримати дані з cdb та зберегти їх у файл
    [Tags]  create_tender
    ${id}  procurement_tender_detail.Отритами дані зі сторінки  ['id']
    ${cdb}  Отримати дані тендеру з cdb по id  ${id}
    Set Global Variable  ${cdb}
    Зберегти словник у файл  ${cdb}  cdb


Прийняти участь у тендері учасником
    [Arguments]  ${role}
    Завантажити сесію для  ${role}
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Прийом пропозицій
    Run Keyword If  '${role}' == 'provider1'  Sleep  3m
    Подати пропозицію учасником


Подати пропозицію учасником
	Перевірити кнопку подачі пропозиції
	Заповнити поле з ціною  1  1
    Додати файл  1
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
    Go Back


Перевірити отримання ссилки на участь в аукціоні
    [Arguments]  ${role}
    Завантажити сесію для  ${role}
    Go To  ${data['tender_href']}
    Натиснути кнопку "До аукціону"
	${auction_participate_href}  Отримати URL для участі в аукціоні
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
	#Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items'][0]['unit']}
	Element Should Contain  //h4  Вхід на даний момент закритий.
    Go Back


Перевірити можливість отримати посилання на аукціон користувачем
	[Arguments]  ${role}
	Завантажити сесію для  ${role}
	Go to  ${data['tender_href']}
	${auction_participate_href}  Run Keyword And Expect Error  *  Run Keywords
	...  Натиснути кнопку "До аукціону"
	...  AND  Отримати URL для участі в аукціоні