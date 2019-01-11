*** Settings ***
Resource  ../../src/src.robot
Library  ../../src/pages/dutch/dutch_variables.py
Suite Setup  Precondition
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot  AND
...                                        Log  ${data}


#zapusk
#robot --consolecolors on -L TRACE:INFO -d test_output --noncritical compare -e get_tender -e -prod -v hub:None -v user:fgv_prod_owner suites/get_auction_href/dutch.robot
#robot --consolecolors on -L TRACE:INFO -d test_output --noncritical compare -e get_tender -v hub:None -v user:Bened suites/get_auction_href/dutch.robot
*** Test Cases ***
Створити аукціон
	[Tags]  create_tender
	Завантажити сесію для  tender_owner
	dutch_step.Створити аукціон


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
	${cdb_data}  Отримати дані Аукціону ФГВ з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  cdb_data


Порівняти введені дані з даними в ЦБД
	[Tags]  compare  -prod
	[Setup]  Run Keyword If  '${site}' == 'prod'
	...  compare_data.Порівняти введені дані з даними в ЦБД  ['procuringEntity']['contactPoint']['name']
	[Template]  compare_data.Порівняти введені дані з даними в ЦБД
	\['date']  m
	\['dgfDecisionID']
	\['dgfDecisionDate']  d
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
	[Setup]  dzk_auction.Розгорнути детальну інформацію по всіх полях (за необхідністю)
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
	\['auctionPeriod']['startDate']
	\['dgfDecisionID']
	\['dgfDecisionDate']  d
	\['auctionParameters']['dutchSteps']
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
#\['minimalStep']['amount']


Знайти тендер учасниками
	:FOR  ${i}  IN  provider1  tender_owner  viewer
	\  Знайти тендер користувачем  ${i}
	\  Зберегти пряме посилання на тендер
	\  Зберегти сесію  ${i}
	:FOR  ${i}  IN  2  3
	\  Завантажити сесію для  provider${i}
	\  Go to  ${data['tender_href']}
	\  Зберегти сесію  provider${i}


Подати заявку на участь в тендері учасниками
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Sleep  1m  #    Ждем пока в ЦБД сформируются даты приема предложений
	:FOR  ${i}  IN  1  2
	\  Завантажити сесію для  provider${i}
	\  Зберегти сесію  provider${i}
	\  Подати заявку для подачі пропозиції


Підтвердити заявки на участь
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  tender_owner
	Підтвердити заявки на участь у тендері  ${data['tender_id']}


Підтвердити пропозицію
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	:FOR  ${i}  IN  provider1  provider2
	\  Завантажити сесію для  ${i}
	\  Run Keyword If  "${site}" == "test"  Натиснути кнопку "Додати документи"
	\  Run Keyword If  "${site}" == "test"  Натиснути кнопку "Підтвердити пропозицію"


Отримати посилання на аукціон для учасників
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Sleep  1m  #    Ссылка на участие формируется быстрее чем страница формируется(простой способ не поймать 404)
	:FOR  ${i}  IN  provider1  provider2
	\  Завантажити сесію для  ${i}
    \  ${auction_participate_href}  ${auction_href}  Wait Until Keyword Succeeds  5m  3
    \  ...  get_auction_href.Отримати посилання на участь та прегляд аукціону для учасника
    \  Wait Until Keyword Succeeds  1m  20s
    \  ...  Перевірити сторінку участі в аукціоні  ${auction_participate_href}


Перевірити неможливість отримати посилання на перегляд
	[Documentation]  В голандском аукционе есть только ссылка на участие(особенность типа торгов)
	:FOR  ${i}  IN  provider1  provider3  tender_owner  viewer
	\  Завантажити сесію для  ${i}
	\  Run Keyword And Expect Error  *  get_auction_href.Отримати посилання на прегляд аукціону не учасником


*** Keywords ***
Precondition
	${edit_locators}  dutch_variables.get_edit_locators
	${view_locators}  dutch_variables.get_view_locators
	${data}  dutch_variables.get_data
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