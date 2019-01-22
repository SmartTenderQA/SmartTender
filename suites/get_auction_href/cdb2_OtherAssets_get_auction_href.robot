*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot


#zapusk
#Отримати посилання на аукціон
#robot --consolecolors on -L TRACE:INFO -d test_output --noncritical compare -i get_auction_href -v hub:None suites/get_auction_href/cdb2_OtherAssets_get_auction_href.robot
#Кваліфікація учасника
#robot --consolecolors on -L TRACE:INFO -d test_output -i qualification -v hub:None suites/get_auction_href/cdb2_OtherAssets_get_auction_href.robot
*** Variables ***


*** Test Cases ***
Створити аукціон
	[Tags]  create_tender  get_auction_href  qualification
	Завантажити сесію для  ${tender_owner}
	cdb2_OtherAssets.Створити аукціон


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Отримати дані про аукціон з ЦБД
	[Tags]  compare  get_auction_href
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Знайти тендер користувачем  ${tender_owner}
	synchronization.Дочекатись синхронізації  auctions
	dzk_auction.Отримати ID у цбд
	${cdb_data}  Отримати дані Аукціону ФГИ з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  cdb_data


Порівняти введені дані з даними в ЦБД
	[Tags]  compare  get_auction_href
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
	[Tags]  find_auction  get_auction_href  qualification
	:FOR  ${i}  IN  ${provider1}  ${tender_owner}  ${viewer}
	\  Знайти тендер користувачем  ${i}
	\  Зберегти пряме посилання на тендер
	\  Зберегти сесію  ${i}
	:FOR  ${i}  IN  2  3
	\  Завантажити сесію для  ${provider${i}}
	\  Go to  ${data['tender_href']}
	\  Зберегти сесію  ${provider${i}}


Подати заявки на участь в тендері
	[Tags]  make_a_proposal  get_auction_href  qualification
    Sleep  1m  #    Ждем пока в ЦБД сформируются даты приема предложений
	:FOR  ${i}  IN  1  2
	\  Завантажити сесію для  ${provider${i}}
	\  Зберегти сесію  ${provider${i}}
	\  Подати заявку для подачі пропозиції


Підтвердити заявки на участь
	[Tags]  make_a_proposal  get_auction_href  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  ${tender_owner}
	Підтвердити заявки на участь у тендері  ${data['tender_id']}


Подати пропозицію
	[Tags]  make_a_proposal  get_auction_href  qualification
	:FOR  ${i}  IN  1  2
	\  Завантажити сесію для  ${provider${i}}
	\  Дочекатись закінчення загрузки сторінки(skeleton)
	\  Перевірити кнопку подачі пропозиції  //*[contains(text(), 'Подача пропозиції')]
	\  Заповнити поле з ціною  1  ${i}
	\  Подати пропозицію


Дочекатися початку аукціону першим учасником
	[Tags]  get_auction_href
	Завантажити сесію для  ${provider1}
	Дочекатись дати  ${data['date']}
	procurement_tender_detail.Дочекатися статусу тендера  Аукціон  15m


Отримати поcилання на участь та перегляд аукціону першим учасником
	[Tags]  get_auction_href
	${auction_participate_href}  ${auction_href}
	...  get_auction_href.Отримати посилання на участь та прегляд аукціону для учасника
	Set Global Variable  		${auction_href}
	Зберегти пряме посилання на тендер
	Перевірити сторінку участі в аукціоні  ${auction_participate_href}


Отримати поcилання на перегляд аукціону
	[Tags]  get_auction_href
	:FOR  ${i}  IN  ${tender_owner}  ${provider3}  ${viewer}
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
	\  ${auction_href}  get_auction_href.Отримати посилання на прегляд аукціону не учасником
	\  Run Keyword And Expect Error  *  get_auction_href.Отримати посилання на участь та прегляд аукціону для учасника


Дочекатися початку кваліфікації
	[Tags]  qualification
	Завантажити сесію для  ${provider2}
	#todo nuzhno vinesti keyword
	small_privatization_informational_message.Дочекатися статусу повідомлення  Кваліфікація  120m


Подати кваліфікаційні документи
	[Tags]  qualification
	sale_keywords.Натиснути "Кваліфікаційні документи"
	sale_keywords.Додати кваліфікаційний документ за типом  [Оберіть тип документа]
	sale_keywords.Додати кваліфікаційний документ за типом  Документи, що підтверджують кваліфікацію
	sale_keywords.Додати кваліфікаційний документ за типом  Цінова пропозиція
	sale_keywords.Додати кваліфікаційний документ за типом  Документи, що підтверджують відповідність
	sale_keywords.Додати кваліфікаційний документ за типом  Протокол аукціону
	sale_keywords.Завантажити кваліфікаційні документи


Перевірити відображення детальної інформації про документи
	[Tags]  qualification
	No Operation


Замінити кваліфікаційні документи
	[Tags]  qualification
	No Operation


Перевірити відображення детальної інформації про документи після змін
	[Tags]  qualification
	No Operation


Кваліфікація переможця аукціону
	[Tags]  qualification
	[Setup]  Run Keywords  Завантажити сесію для  ${tender_owner}	AND
	...  Go To  ${start_page}										AND
	...  Навести мишку на іконку з заголовку  Меню_користувача		AND
	...  Натиснути  Особистий кабінет
	Відкрити сторінку Продаж/Оренда майна(тестові)
	sale_create_tender.Знайти переможця за назвою аукціона
	sale_create_tender.Натиснути "Кваліфікація"
	sale_create_tender.Натиснути "Підтвердити перевірку протоколу"
	sale_create_tender.Додати протокол рішення


Прикріпити та підписати договір
	[Tags]  qualification
	sale_create_tender.Натиснути "Прикріпити договір"
	sale_create_tender.Заповнити поле "Номер договору"
	sale_create_tender.Заповнити поле "Дата підписання"
	sale_create_tender.Прикріпити документ договору
	sale_create_tender.Зберегти договір
	sale_create_tender.Натиснути "Підписати договір"
	Завантажити сесію для  ${provider2}
	small_privatization_informational_message.Статус повідомлення повинен бути  Завершено


*** Keywords ***
Precondition
	Set Global Variable  ${tender_owner}  Bened
	Set Global Variable  ${provider1}  user1
	Set Global Variable  ${provider2}  user2
	Set Global Variable  ${provider3}  user3
	Set Global Variable  ${viewer}  test_viewer
	cdb2_OtherAssets.Завантажити локатори
    Додати першого користувача  ${tender_owner}
    Підготувати користувачів


Підготувати користувачів
    Додати користувача  ${provider1}
    Додати користувача  ${provider2}
    Додати користувача  ${provider3}
    Додати користувача  ${viewer}


Зберегти пряме посилання на тендер
	${tender_href}  Get Location
	Set To Dictionary  ${data}  tender_href  ${tender_href}


Знайти тендер користувачем
	[Arguments]  ${user_name}
	Завантажити сесію для  ${user_name}
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