*** Settings ***
Resource  ../../src/src.robot
Library  ../../src/pages/dgfAssets/dgfAssets_variables.py
Suite Setup  Precondition
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords  Capture Page Screenshot
...  AND  Log Location
...  AND  Log  ${data}
#...  AND  debug


*** Variables ***
&{type_dict}
...  								property=Продаж майна банків, що ліквідуються
...  								requirements=Продаж права вимоги за кредитними договорами


#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output --noncritical compare -e get_tender -v type:property -v hub:None suites/get_auction_href/dgfAssets_get_auction_href.robot
*** Test Cases ***
Створити тендер
	[Tags]  create_tender
	Завантажити сесію для  tender_owner
	sale_dgfAssets.Створити тендер  ${type_dict['${type}']}


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Отримати дані про аукціон з ЦБД
	[Tags]  compare
	Знайти тендер користувачем  tender_owner
	synchronization.Дочекатись синхронізації  auctions
	dzk_auction.Отримати ID у цбд
	${cdb_data}  Отримати дані Аукціону ФГВ з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  cdb_data


Порівняти введені дані з даними в ЦБД
	[Tags]  compare
	[Template]  compare_data.Порівняти введені дані з даними в ЦБД
	\['date']  m
	\['dgfDecisionID']
	\['dgfDecisionDate']  d
	\['value']['amount']
	\['minimalStep']['amount']
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
	[Tags]  compare
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


Знайти тендер учасниками
	Знайти тендер користувачем	provider1
	Зберегти пряме посилання на тендер


Подати заявки на участь в тендері
    Sleep  1m  #    Ждем пока в ЦБД сформируются даты приема предложений
	:FOR  ${i}  IN  1  2
	\  Завантажити сесію для  provider${i}
	\  Go To  ${data['tender_href']}
	\  Зберегти сесію  provider${i}
	\  Подати заявку для подачі пропозиції


Підтвердити заявки на участь
	Підтвердити заявки на участь у тендері  ${data['tender_id']}


Подати пропозицію
	:FOR  ${i}  IN  1  2
	\  Завантажити сесію для  provider${i}
	\  Дочекатись закінчення загрузки сторінки(skeleton)
	\  Перевірити кнопку подачі пропозиції  //*[contains(text(), 'Подача пропозиції')]
	\  Заповнити поле з ціною  1  ${i}
	\  Подати пропозицію
	\  Go Back


Дочекатися початку аукціону першим учасником
	Завантажити сесію для  provider1
	Дочекатись дати  ${data['date']}
	procurement_tender_detail.Дочекатися статусу тендера  Аукціон  10m


Отримати посилання на аукціон для першого учасника
    Wait Until Keyword Succeeds  5m  3
    ...  Отримати поcилання на участь та перегляд аукціону першим учасником


Отримати поcилання на перегляд аукціону
	:FOR  ${i}  IN  tender_owner  provider3  viewer
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
	\  ${auction_href}  get_auction_href.Отримати посилання на прегляд аукціону не учасником
	\  Run Keyword And Expect Error  *  get_auction_href.Отримати посилання на участь та прегляд аукціону для учасника


Забрати гарантійний внесок учасниками
	[Tags]  broken
	procurement_tender_detail.Дочекатися статусу тендера  Кваліфікація  90m
	Забрати гарантійний внесок учасником  provider1
	Run Keyword And Expect Error  *  Забрати гарантійний внесок учасником  provider2


*** Keywords ***
Precondition
	${edit_locators}  dgfAssets_variables.get_edit_locators
	${view_locators}  dgfAssets_variables.get_view_locators
	${data}  dgfAssets_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}
    Додати першого користувача  Bened  tender_owner
    Підготувати користувачів


Підготувати користувачів
	Run Keyword If  "${site}" == "test"  Run Keywords
    ...  Додати користувача			 test_tender_owner	tender_owner2 	AND
    ...  Додати користувача          user1           	provider1     	AND
    ...  Додати користувача          user2           	provider2     	AND
    ...  Додати користувача          user3           	provider3     	AND
    ...  Додати користувача          test_viewer     	viewer


Знайти тендер користувачем
	[Arguments]  ${role}
	Завантажити сесію для  ${role}
	Sleep  2
	Відкрити сторінку тестових торгів
	Знайти тендер по ID  ${data['tender_id']}


Отримати та зберегти tender_id
	${tender_id}  Get Element Attribute  (//tr[contains(@class, 'Row')])[1]//a[not(contains(@href, 'smart'))]  text
	Should Not Be Equal  ${tender_id}  ${EMPTY}
	Set To Dictionary  ${data}  tender_id=${tender_id}


Зберегти пряме посилання на тендер
	${tender_href}  Get Location
	Set To Dictionary  ${data}  tender_href  ${tender_href}


Отримати поcилання на участь та перегляд аукціону першим учасником
	Go To  ${data['tender_href']}
	${auction_participate_href}  ${auction_href}
	...  get_auction_href.Отримати посилання на участь та прегляд аукціону для учасника
	Set Global Variable  		${auction_href}
	Перевірити сторінку участі в аукціоні  ${auction_participate_href}


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


Забрати гарантійний внесок учасником
	[Arguments]  ${user}
	Завантажити сесію для  ${user}
	Натиснути "Забрати гарантійний внесок"
	Натиснути "Відмовитися від участі"
	#todo Тут нужно доделать после того как поймем, что и как


Натиснути "Забрати гарантійний внесок"
	${get guarantee locator}  Set Variable  //*[@class='action-block-item text-center']//button[contains(.,'Забрати гарантійний внесок')]
	${frame locator}  Set Variable  //*[@class='ivu-modal-content']//iframe
	Click Element  ${get guarantee locator}
	Wait Until Page Contains Element  ${frame locator}
	Select Frame  ${frame locator}
	Wait Until Element Is Visible  //*[text()='Відмовитись від участі?']


Натиснути "Відмовитися від участі"
	Click Element  //*[@id='firstYes']
	Wait Until Element Is Not Visible  //*[@id='firstYes']
	Wait Until Element Is Visible  //*[text()='Ви впевнені? Дана дія має незворотній характер!']
	Click Element  //*[@id='secondYes']
	Wait Until Element Is Not Visible  //*[@id='secondYes']
