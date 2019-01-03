*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Створити словник  data
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot

#  robot --consolecolors on -L TRACE:INFO -d test_output -e get_tender -v hub:None -v type:property suites/get_auction_href/cdb1_sale_property.robot
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
	\  Заповнити поле з ціною  1  1
	\  Подати пропозицію
	\  Go Back


Дочекатися початку аукціону першим учасником
	Завантажити сесію для  provider1
	Дочекатись дати  ${data['auctionPeriods']['startDate']}
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


Отримати поcилання на участь та перегляд аукціону першим учасником
	Reload Page
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
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['quantity']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['unit_name']}
	${status}  Run Keyword And Return Status
	...  Element Should Contain  //h4  Ви зареєстровані як учасник. Очікуйте старту аукціону.
	Run Keyword If  ${status} != ${True}  Element Should Contain  //h4  Вхід на даний момент закритий.
	Go back

