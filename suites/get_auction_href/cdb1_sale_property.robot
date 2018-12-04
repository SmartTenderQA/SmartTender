*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Створити словник  data
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
&{type_dict}
...  								property=Продаж майна банків, що ліквідуються
...  								requirements=Продаж права вимоги за кредитними договорами


*** Test Cases ***
Створити тендер
	[Tags]  create_tender
	Підготувати організатора
	cdb1_sale_property.Створити тендер  ${type_dict['${type}']}
	Close Browser


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Знайти тендер учасниками
	Підготувати учасників
	Знайти тендер користувачем	provider1
	Зберегти пряме посилання на тендер
	Switch Browser  provider2
	Go To  ${data['tender_href']}


Подати заявки на участь в тендері
	:FOR  ${i}  IN  1  2
	\  Switch Browser  provider${i}
	\  Подати заявку для подачі пропозиції


Підтвердити заявки на участь
	Підтвердити заявки на участь у тендері  ${data['tender_id']}


Подати пропозицію
	:FOR  ${i}  IN  1  2
	\  Switch Browser  provider${i}
	\  Reload Page
	\  Дочекатись закінчення загрузки сторінки(skeleton)
	\  Перевірити кнопку подачі пропозиції  //*[contains(text(), 'Подача пропозиції')]
	\  Заповнити поле з ціною  1  1
	\  Подати пропозицію
	\  Go Back


Дочекатися початку аукціону першим учасником
	Close Browser
	Switch Browser  provider1
	Дочекатись дати  ${data['auctionPeriods']['startDate']}
	Дочекатися статусу тендера  Аукціон  10m


Отримати поcилання на участь та перегляд аукціону першим учасником
	Натиснути кнопку "До аукціону"
	${auction_participate_href}  Wait Until Keyword Succeeds  60  3  Отримати URL для участі в аукціоні
	${auction_href}  			Отримати URL на перегляд
	Set Global Variable  		${auction_href}
	Перевірити сторінку участі в аукціоні  ${auction_participate_href}
	Close Browser


Отримати поcилання на перегляд аукціону
	[Setup]  Run Keywords  Підготувати організатора  Підготувати глядачів
	:FOR  ${i}  IN  tender_owner  provider3  viewer
	\  Switch Browser  ${i}
	\  Go To  ${data['tender_href']}
	\  Натиснути кнопку "Перегляд аукціону"
	\  ${auction_href}  Отримати URL на перегляд
	\  ${auction_participate_href}  Run Keyword And Expect Error  *  Отримати URL для участі в аукціоні


*** Keywords ***
Підготувати організатора
	Start  Bened  tender_owner
	Go Back


Підготувати учасників
	Start  user1  provider1
	Start  user2  provider2


Підготувати глядачів
	Start  user3  provider3
	Start  test_viewer  viewer


Знайти тендер користувачем
	[Arguments]  ${role}
	Switch Browser  ${role}
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

