*** Settings ***
Resource  ../../src/src.robot
Library  ../../src/pages/sale/SPF/otherAssets/otherAssets_variables.py
Suite Setup  Precondition
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot


#zapusk
#robot --consolecolors on -L TRACE:INFO -d test_output --noncritical compare -e get_tender -v hub:None -v user:Bened suites/get_auction_href/cdb2_OtherAssets_get_auction_href.robot
*** Variables ***


*** Test Cases ***
Створити аукціон
	[Tags]  create_tender
	Завантажити сесію для  tender_owner
	cdb2_OtherAssets.Створити аукціон


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Отримати дані про аукціон з ЦБД
	[Tags]  compare  -prod
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Знайти тендер користувачем  tender_owner
	synchronization.Дочекатись синхронізації  auctions
	dzk_auction.Отримати ID у цбд
	${cdb_data}  Отримати дані Аукціону ФГИ з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  cdb_data


Порівняти введені дані з даними в ЦБД
	[Tags]  compare  -prod
	[Setup]  Run Keyword If  '${site}' == 'prod'
	...  compare_data.Порівняти введені дані з даними в ЦБД  ['procuringEntity']['contactPoint']['name']
	[Template]  compare_data.Порівняти введені дані з даними в ЦБД
	\['value']['amount']
	\['title']
	\['dgfID']
	\['description']
	\['items'][0]['description']
	\['items'][0]['quantity']
	\['items'][0]['unit']['name']
	\['items'][0]['classification']['scheme']
	\['items'][0]['classification']['description']
	\['items'][0]['classification']['id']
	\['items'][0]['address']['postalCode']
	\['items'][0]['address']['countryName']
	\['items'][0]['address']['streetAddress']
	\['items'][0]['address']['region']
	\['items'][0]['address']['locality']


Перевірити відображення детальної інформації
	[Tags]  compare  -prod
	[Setup]  sale_keywords.Розгорнути детальну інформацію по всіх полях (за необхідністю)
	[Template]  compare_data.Порівняти відображені дані з даними в ЦБД
	\['title']
	\['dgfID']
	\['auctionID']
	\['description']
	\['value']['amount']
	\['value']['valueAddedTaxIncluded']
	\['enquiryPeriod']['startDate']
	\['enquiryPeriod']['endDate']
	\['tenderPeriod']['startDate']
	\['tenderPeriod']['endDate']
	\['minimalStep']['amount']
	\['guarantee']['amount']
	\['procuringEntity']['identifier']['legalName']
	\['procuringEntity']['identifier']['id']
	\['procuringEntity']['contactPoint']['name']
	\['procuringEntity']['contactPoint']['telephone']
	\['procuringEntity']['contactPoint']['email']
	\['items'][0]['description']
	\['items'][0]['classification']['description']
	\['items'][0]['classification']['id']
	\['items'][0]['classification']['scheme']
	\['items'][0]['quantity']
	\['items'][0]['unit']['name']
	\['items'][0]['address']['postalCode']
	\['items'][0]['address']['countryName']
	\['items'][0]['address']['streetAddress']
	\['items'][0]['address']['region']
	\['items'][0]['address']['locality']

#todo нужно понять что єто и зачем мі его вводим
#


Знайти тендер учасниками
	:FOR  ${i}  IN  provider1  tender_owner  viewer
	\  Знайти тендер користувачем  ${i}
	\  Зберегти пряме посилання на тендер
	\  Зберегти сесію  ${i}
	:FOR  ${i}  IN  2  3
	\  Завантажити сесію для  provider${i}
	\  Go to  ${data['tender_href']}
	\  Зберегти сесію  provider${i}


Подати заявки на участь в тендері
    Sleep  1m  #    Ждем пока в ЦБД сформируются даты приема предложений
	:FOR  ${i}  IN  1  2
	\  Завантажити сесію для  provider${i}
	\  Зберегти сесію  provider${i}
	\  Подати заявку для подачі пропозиції


Підтвердити заявки на участь
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  tender_owner
	Підтвердити заявки на участь у тендері  ${data['tender_id']}


Подати пропозицію
	:FOR  ${i}  IN  1  2
	\  Завантажити сесію для  provider${i}
	\  Дочекатись закінчення загрузки сторінки(skeleton)
	\  Перевірити кнопку подачі пропозиції  //*[contains(text(), 'Подача пропозиції')]
	\  Заповнити поле з ціною  1  ${i}
	\  Подати пропозицію


Дочекатися початку аукціону першим учасником
	Завантажити сесію для  provider1
	Дочекатись дати  ${data['date']}
	procurement_tender_detail.Дочекатися статусу тендера  Аукціон  15m


Отримати поcилання на участь та перегляд аукціону першим учасником
	${auction_participate_href}  ${auction_href}
	...  get_auction_href.Отримати посилання на участь та прегляд аукціону для учасника
	Set Global Variable  		${auction_href}
	Зберегти пряме посилання на тендер
	Перевірити сторінку участі в аукціоні  ${auction_participate_href}


Отримати поcилання на перегляд аукціону
	:FOR  ${i}  IN  tender_owner  provider3  viewer
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
	\  ${auction_href}  get_auction_href.Отримати посилання на прегляд аукціону не учасником
	\  Run Keyword And Expect Error  *  get_auction_href.Отримати посилання на участь та прегляд аукціону для учасника


*** Keywords ***
Precondition
	${edit_locators}  otherAssets_variables.get_edit_locators
	${view_locators}  otherAssets_variables.get_view_locators
	${data}  otherAssets_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}
    Додати першого користувача  ${user}  tender_owner
    Підготувати користувачів


Підготувати користувачів
    Run Keyword If  "${site}" == "prod"  Run Keywords
    ...  Додати користувача          prod_provider		provider1     AND
    ...  Додати користувача          prod_provider2		provider2     AND
    ...  Додати користувача          prod_provider1		provider3     AND
    ...  Додати користувача          prod_viewer		viewer
    Run Keyword If  "${site}" == "test"  Run Keywords
    ...  Додати користувача          user1           	provider1     AND
    ...  Додати користувача          user2           	provider2     AND
    ...  Додати користувача          user3           	provider3     AND
    ...  Додати користувача          test_viewer     	viewer


Зберегти пряме посилання на тендер
	${tender_href}  Get Location
	Set To Dictionary  ${data}  tender_href  ${tender_href}


Знайти тендер користувачем
	[Arguments]  ${role}
	Завантажити сесію для  ${role}
	Sleep  2
	Відкрити сторінку тестових торгів
	Знайти тендер по ID  ${data['tender_id']}


Натиснути кнопку "Додати документи"
    Reload Page
    Дочекатись закінчення загрузки сторінки(skeleton)
    ${selector}  Set Variable  //a[contains(@class, "btn-success") and contains(text(), "Додати документи")]
    Click Element  ${selector}


Натиснути кнопку "Підтвердити пропозицію"
    Wait Until Element Is Visible  //span[contains(text(), "Підтвердити пропозицію")]
    Click Element  //span[contains(text(), "Підтвердити пропозицію")]
    Дочекатись закінчення загрузки сторінки
    Wait Until Element Is Visible  //span[contains(text(), "Так")]
    Click Element  //span[contains(text(), "Так")]
    Дочекатись закінчення загрузки сторінки
    Wait Until Element Is Visible  //a[contains(text(), "Перейти")]
    Open Button  //a[contains(text(), "Перейти")]


Перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Підтвердити повідомлення про умови проведення аукціону
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  20
	Sleep  2
	Element Should Contain  //*[@class="page-header"]//h2  ${data['tender_id']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items'][0]['description']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items'][0]['quantity']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items'][0]['unit']['name']}
	${status}  Run Keyword And Return Status
	...  Element Should Contain  //h4  Ви зареєстровані як учасник. Очікуйте старту аукціону.
	Run Keyword If  ${status} != ${True}  Element Should Contain  //h4  Вхід на даний момент закритий.
	Go back