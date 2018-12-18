*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Створити словник  data
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot


*** Variables ***
&{type_dict}
...  								property=Продаж майна банків, що ліквідуються
...  								requirements=Продаж права вимоги за кредитними договорами


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
	cdb1_sale_property.Створити тендер  ${type_dict['${type}']}


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Знайти тендер учасниками
	Знайти тендер користувачем	provider1
	Зберегти пряме посилання на тендер


Подати заявки на участь в тендері
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
	\  Заповнити поле з ціною  1  1
	\  Подати пропозицію
	\  Go Back


Дочекатися початку аукціону першим учасником
	Завантажити сесію для  provider1
	Дочекатись дати  ${data['auctionPeriods']['startDate']}
	Дочекатися статусу тендера  Аукціон  10m


Отримати поcилання на участь та перегляд аукціону першим учасником
	Натиснути кнопку "До аукціону"
	${auction_participate_href}  Wait Until Keyword Succeeds  4m  3  Отримати URL для участі в аукціоні
	${auction_href}  			Отримати URL на перегляд
	Set Global Variable  		${auction_href}
	Перевірити сторінку участі в аукціоні  ${auction_participate_href}


Отримати поcилання на перегляд аукціону
	:FOR  ${i}  IN  tender_owner  provider3  viewer
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
	\  Wait Until Keyword Succeeds  60  2  Натиснути кнопку "Перегляд аукціону"
	\  ${auction_href}  Отримати URL на перегляд
	\  ${auction_participate_href}  Run Keyword And Expect Error  *  Отримати URL для участі в аукціоні


*** Keywords ***
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

