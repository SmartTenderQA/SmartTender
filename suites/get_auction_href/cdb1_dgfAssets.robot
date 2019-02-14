*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords  Capture Page Screenshot
...  AND  Log Location
...  AND  Log  ${data}


*** Variables ***
&{type_dict}
...  								property=Продаж майна банків, що ліквідуються
...  								requirements=Продаж права вимоги за кредитними договорами


#Запуск
#Отримати посилання на аукціон
#robot --consolecolors on -L TRACE:INFO -d test_output --noncritical compare -i get_auction_href -v type:property -v hub:None -v where:test suites/get_auction_href/cdb1_dgfAssets.robot
#robot --consolecolors on -L TRACE:INFO -d test_output --noncritical compare -i get_auction_href -v type:requirements -v hub:None -v where:test suites/get_auction_href/cdb1_dgfAssets.robot
#Кваліфікація учасника
#robot --consolecolors on -L TRACE:INFO -d test_output --noncritical compare -i qualification -v where:test suites/get_auction_href/cdb1_dgfAssets.robot

*** Test Cases ***
Створити тендер
	[Tags]  create_tender  get_auction_href  qualification
	Завантажити сесію для  ${tender_owner}
	cdb1_dgfAssets_step.Створити тендер  ${type_dict['${type}']}
	Знайти тендер користувачем  ${tender_owner}
	Run Keyword If  not('iis' in '${IP}')
	...  cdb2_LandLease_page.Отримати ID у цбд


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Отримати дані про аукціон з ЦБД
	[Tags]  compare  get_auction_href
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	${cdb_data}  Wait Until Keyword Succeeds  60  15  Отримати дані Аукціону ФГВ з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  cdb_data


Порівняти введені дані з даними в ЦБД
	[Tags]  compare  get_auction_href
	[Template]  compare_data.Порівняти введені дані з даними в ЦБД
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
	[Tags]  compare  get_auction_href
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
	[Tags]  make_a_proposal  get_auction_href  qualification
	Знайти тендер користувачем	${provider1}
	Зберегти пряме посилання на тендер


Подати заявки на участь в тендері
	[Tags]  make_a_proposal  get_auction_href  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
    Sleep  1m  #    Ждем пока в ЦБД сформируются даты приема предложений
	:FOR  ${i}  IN  ${provider1}  ${provider2}
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
	\  Зберегти сесію  ${i}
	\  Подати заявку на участь в аукціоні


Підтвердити заявки на участь
	[Tags]  make_a_proposal  get_auction_href  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Підтвердити заявки на участь у тендері  ${data['tender_id']}


Подати пропозицію
	[Tags]  make_a_proposal  get_auction_href  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	:FOR  ${i}  IN  1  2
	\  Завантажити сесію для  ${provider${i}}
	\  Дочекатись закінчення загрузки сторінки(skeleton)
	\  Перевірити кнопку подачі пропозиції  //*[contains(text(), 'Подача пропозиції')]
	\  Заповнити поле з ціною  1  ${i}
	\  Подати пропозицію
	\  Go Back


Дочекатися початку аукціону першим учасником
	[Tags]  get_auction_href
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  ${provider1}
	Дочекатись дати  ${data['date']}
	procurement_tender_detail.Дочекатися статусу тендера  Аукціон  10m


Отримати посилання на аукціон для першого учасника
	[Tags]  get_auction_href
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
    Wait Until Keyword Succeeds  5m  3
    ...  Отримати поcилання на участь та перегляд аукціону першим учасником


Отримати поcилання на перегляд аукціону
	[Tags]  get_auction_href
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	:FOR  ${i}  IN  ${tender_owner}  ${viewer}   #provider3
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
	\  ${auction_href}  get_auction_href.Отримати посилання на прегляд аукціону не учасником
	\  Run Keyword And Expect Error  *  get_auction_href.Отримати посилання на участь та прегляд аукціону для учасника


Дочекатися початку кваліфікації
	[Tags]  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  ${provider2}
	#todo nuzhno vinesti keyword
	cdb2_ssp_lot_page.Дочекатися статусу повідомлення  Кваліфікація  120m
	#


Подати кваліфікаційні документи
	[Tags]  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	sale_keywords.Натиснути "Кваліфікаційні документи"
	sale_keywords.Додати кваліфікаційний документ за типом  Документи, що підтверджують кваліфікацію
	sale_keywords.Додати кваліфікаційний документ за типом  Цінова пропозиція
	sale_keywords.Додати кваліфікаційний документ за типом  Документи, що підтверджують відповідність
	sale_keywords.Додати кваліфікаційний документ за типом  Протокол аукціону
	sale_keywords.Завантажити кваліфікаційні документи


Отримати дані про аукціон з ЦБД
	[Tags]  compare  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	${cdb_data}  Отримати дані Аукціону ФГВ з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  cdb_data_with_docs


Перевірити коректність документів в ЦБД
	[Tags]  compare  qualification
	[Template]  compare_data.Порівняти створений документ з документом в ЦБД
	${data['documents'][0]}
	${data['documents'][1]}
	${data['documents'][2]}
	${data['documents'][3]}


Перевірити коректність відображення документів
	[Tags]  compare  qualification
	[Setup]  Run Keywords  Go Back									AND
	...  Дочекатись закінчення загрузки сторінки(skeleton)			AND
	...  sale_keywords.Розгорнути кваліфікаційні документи переможця
	[Template]  compare_data.Порівняти відображений документ з документом в ЦБД
	${data['documents'][0]}
	${data['documents'][1]}
	${data['documents'][2]}
	${data['documents'][3]}


Замінити кваліфікаційні документи
	[Tags]  qualification
	No Operation


Перевірити відображення детальної інформації про документи після змін
	[Tags]  qualification
	No Operation


Кваліфікація переможця аукціону
	[Tags]  qualification
	[Setup]  Завантажити сесію для  ${tender_owner}
	Відкрити сторінку Аукціони ФГВ(test)
	Wait Until Keyword Succeeds  10m  30s  sale_create_tender.Знайти переможця за назвою аукціона
	sale_create_tender.Натиснути "Кваліфікація"
	sale_create_tender.Натиснути "Підтвердити перевірку протоколу"
	sale_create_tender.Додати протокол рішення
	sale_create_tender.Натиснути "Кваліфікація"
	sale_create_tender.Натиснути "Підтвердити оплату"


Прикріпити та підписати договір
	[Tags]  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Sleep  2m
	sale_create_tender.Натиснути "Прикріпити договір"
	sale_create_tender.Заповнити поле "Номер договору"
	sale_create_tender.Заповнити поле "Дата підписання"
	sale_create_tender.Прикріпити документ договору
	sale_create_tender.Зберегти договір
	sale_create_tender.Натиснути "Підписати договір"
	Завантажити сесію для  ${provider2}
	cdb2_ssp_lot_page.Дочекатися статусу повідомлення  Завершено  10m


Отримати дані про аукціон з ЦБД
	[Tags]  compare  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	${cdb_data}  Отримати дані Аукціону ФГВ з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  cdb_data_with_docs


Перевірити коректність документів в ЦБД
	[Tags]  compare  qualification
	[Template]  compare_data.Порівняти створений документ з документом в ЦБД
	${data['documents'][0]}
	${data['documents'][1]}
	${data['documents'][2]}
	${data['documents'][3]}
	${data['documents'][4]}
	${data['documents'][5]}


Перевірити коректність відображення документів
	[Tags]  compare  qualification
	[Setup]  Run Keywords  Дочекатись закінчення загрузки сторінки(skeleton)			AND
	...  sale_keywords.Розгорнути кваліфікаційні документи переможця
	[Template]  compare_data.Порівняти відображений документ з документом в ЦБД
	${data['documents'][0]}
	${data['documents'][1]}
	${data['documents'][2]}
	${data['documents'][3]}
	${data['documents'][4]}
	${data['documents'][5]}


Забрати гарантійний внесок учасниками
	[Tags]  broken
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	procurement_tender_detail.Дочекатися статусу тендера  Кваліфікація  90m
	Забрати гарантійний внесок учасником  ${provider1}
	Run Keyword And Expect Error  *  Забрати гарантійний внесок учасником  ${provider2}


*** Keywords ***
Precondition
	Run Keyword If  '${where}' == 'test'  Run Keywords
	...  Set Global Variable  ${tender_owner}  Bened  AND
	...  Set Global Variable  ${provider1}  user2  AND
	...  Set Global Variable  ${provider2}  user3  AND
	...  Set Global Variable  ${provider3}  user4  AND
	...  Set Global Variable  ${viewer}  test_viewer
	...  ELSE
	...  Set Global Variable  ${tender_owner}  fgv_prod_owner  AND
	...  Set Global Variable  ${provider1}  prod_provider  AND
	...  Set Global Variable  ${provider2}  prod_provider2  AND
	...  Set Global Variable  ${provider3}  prod_provider1  AND
	...  Set Global Variable  ${viewer}  prod_viewer
	cdb1_dgfAssets_step.Завантажити локатори
    Додати першого користувача  ${tender_owner}
    Підготувати користувачів


Підготувати користувачів
	Додати користувача  test_tender_owner
    Додати користувача  user1
    Додати користувача  user2
    Додати користувача  user3
    Додати користувача  test_viewer


Знайти тендер користувачем
	[Arguments]  ${user_name}
	Завантажити сесію для  ${user_name}
	Sleep  2
	Відкрити сторінку тестових торгів
	Знайти тендер по ID  ${data['tender_id']}


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


Подати заявку на участь в аукціоні
	Відкрити бланк подачі заявки
	Додати файл для подачі заявки
	Ввести ім'я для подачі заявки
	Run Keyword If  '${type}' == 'requirements'  Run Keywords
	...  Вибрати правовий статус  Фізична особа		AND
	...  Ввести ІПН
	Підтвердити відповідність для подачі заявки
	Відправити заявку для подачі пропозиції та закрити валідаційне вікно
