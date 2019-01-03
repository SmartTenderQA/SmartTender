*** Settings ***
Resource  ../../src/src.robot
Library  ../../src/pages/dgfOtherAssets/dgfOtherAssets_variables.py
Suite Setup  Precondition
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords  Capture Page Screenshot
...  AND  Log Location
...  AND  Log  ${data}
...  AND  debug


*** Variables ***
&{type_dict}
...  								property=Продаж майна банків, що ліквідуються
...  								requirements=Продаж права вимоги за кредитними договорами


#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output -e get_tender -v type:property -v hub:None suites/get_auction_href/dgfOtherAssets_get_auction_href.robot
*** Test Cases ***
Створити тендер
	[Tags]  create_tender
	Завантажити сесію для  tender_owner
	cdb1_sale_property.Створити тендер  ${type_dict['${type}']}
	debug


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Отримати дані про аукціон з ЦБД
	[Tags]  compare
	${cdb_data}  Отримати дані Аукціону ДЗК з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  cdb_data


Порівняти введені дані з даними в ЦБД
	[Tags]  compare
	[Template]  compare_data.Порівняти введені дані з даними в ЦБД


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
	Дочекатись дати  ${data['auctionPeriods']['startDate']}
	Дочекатися статусу тендера  Аукціон  10m


Отримати посилання на аукціон для першого учасника
    Wait Until Keyword Succeeds  5m  3
    ...  Отримати поcилання на участь та перегляд аукціону першим учасником


Отримати поcилання на перегляд аукціону
	:FOR  ${i}  IN  tender_owner  provider3  viewer
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
    \  Натиснути кнопку "Перегляд аукціону"
	\  ${auction_href}  Отримати URL на перегляд
	\  ${auction_participate_href}  Run Keyword And Expect Error  *  Отримати URL для участі в аукціоні


new case
	debug


*** Keywords ***
Precondition
	${edit_locators}  dgfOtherAssets_variables.get_edit_locators
	${view_locators}  dgfOtherAssets_variables.get_view_locators
	${data}  dgfOtherAssets_variables.get_data
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
	Reload Page
	Натиснути кнопку "До аукціону"
	${auction_participate_href}  Отримати URL для участі в аукціоні
	${auction_href}  			Отримати URL на перегляд
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
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['quantity']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['unit_name']}
	${status}  Run Keyword And Return Status
	...  Element Should Contain  //h4  Ви зареєстровані як учасник. Очікуйте старту аукціону.
	Run Keyword If  ${status} != ${True}  Element Should Contain  //h4  Вхід на даний момент закритий.
	Go back

