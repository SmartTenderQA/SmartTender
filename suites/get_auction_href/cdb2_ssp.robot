*** Settings ***
Resource  ../../src/src.robot
Library  ../../src/pages/sale/SPF/cdb2_ssp_page/cdb2_ssp_asset_page/cdb2_ssp_asset_variables.py
Library  ../../src/pages/sale/SPF/cdb2_ssp_page/cdb2_ssp_lot_page/cdb2_ssp_lot_variables.py
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Run Keywords  Capture Element Screenshot  //body
...  AND  Log Location
...  AND  Log  ${data}


*** Variables ***

#Запуск
#Отримати посилання на аукціон
#prod
#robot --consolecolors on -L TRACE:INFO -d test_output --noncritical compare -i create_tender -v where:prod -v hub:none suites/get_auction_href/cdb2_ssp.robot
#test
#robot --consolecolors on -L TRACE:INFO -d test_output --noncritical compare -i get_auction_href -v where:test -v hub:none suites/get_auction_href/cdb2_ssp.robot
#Кваліфікація учасника
#test
#robot --consolecolors on -L TRACE:INFO -d test_output --noncritical compare -i qualification -v where:test -v hub:none suites/get_auction_href/cdb2_ssp.robot
*** Test Cases ***
Створити об'єкт МП
	[Tags]  create_tender  make_a_proposal  get_auction_href  qualification
	Завантажити сесію для  ${tender_owner}
	cdb2_ssp_step.Створити об'єкт МП
	cdb2_ssp_asset_page.Отримати UAID для Об'єкту
	sale_keywords.Отримати prozorro ID
	${location}  Get Location
	Log  ОП url= ${location}  WARN
	Зберегти словник у файл  ${data}  asset


Отримати дані про об'єкт з ЦБД
	[Tags]  compare  get_auction_href  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	${cdb_data}  Wait Until Keyword Succeeds  180  15  Отримати дані об'єкту приватизації з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  asset_cdb_data


Порівняти введені дані з даними в ЦБД
	[Tags]  compare  get_auction_href  qualification
	[Template]  compare_data.Порівняти введені дані з даними в ЦБД
	\['title']
	\['description']
	\['decisions'][0]['title']
	\['decisions'][0]['decisionID']
	\['decisions'][0]['decisionDate']
	\['items'][0]['description']
	\['items'][0]['classification']['id']
	\['items'][0]['classification']['description']
	\['items'][0]['quantity']
	\['items'][0]['unit']['name']
	\['items'][0]['address']['postalCode']
	\['items'][0]['address']['countryName']
	\['items'][0]['address']['region']
	\['items'][0]['address']['locality']
	\['items'][0]['address']['streetAddress']


Перевірити відображення детальної інформації про об'єкт
	[Tags]  compare  get_auction_href  qualification
	[Setup]  Run Keywords
	...  sale_keywords.Розгорнути детальну інформацію по всіх полях (за необхідністю)		AND
	...  Run Keyword If  '${site}' == 'test'  compare_data.Порівняти відображені дані з даними в ЦБД  ['assetCustodian']['identifier']['scheme']
	[Template]  compare_data.Порівняти відображені дані з даними в ЦБД
	\['assetID']
	\['title']
	\['description']
	\['decisions'][0]['title']
	\['decisions'][0]['decisionID']
	\['decisions'][0]['decisionDate']
	\['assetCustodian']['identifier']['legalName']
	\['assetCustodian']['identifier']['id']
	\['assetCustodian']['contactPoint']['name']
	\['assetCustodian']['contactPoint']['telephone']
	\['assetCustodian']['contactPoint']['email']
	\['items'][0]['description']
	\['items'][0]['classification']['description']
	\['items'][0]['classification']['id']
	\['items'][0]['classification']['scheme']
	\['items'][0]['address']['postalCode']
	\['items'][0]['address']['countryName']
	\['items'][0]['address']['region']
	\['items'][0]['address']['locality']
	\['items'][0]['address']['streetAddress']
	\['items'][0]['quantity']
	\['items'][0]['unit']['name']


Створити інформаційне повідомлення МП
	[Tags]  create_tender  make_a_proposal  get_auction_href  qualification
	[Setup]  Go To Smart  ${start page}
	Set Global Variable  ${asset_data}  ${data}
	cdb2_ssp_step.Створити інформаційне повідомлення МП  ${assetID}
	cdb2_ssp_lot_page.Дочекатися статусу повідомлення  Опубліковано  20 min
	Run Keyword If  '${site}' == 'test'
	...  sale_keywords.Отримати prozorro ID
	${location}  Get Location
	Log  ИС url= ${location}  WARN
	Зберегти словник у файл  ${data}  message


Отримати дані про інформаційне повідомлення з ЦБД
	[Tags]  compare  get_auction_href  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	${cdb_data}  Wait Until Keyword Succeeds  180  15  Отримати дані інформаційного повідомлення приватизації з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  message_cdb_data


Порівняти введені дані з даними в ЦБД
	[Tags]  compare  get_auction_href  qualification
	[Template]  compare_data.Порівняти введені дані з даними в ЦБД
	\['decisions'][0]['decisionID']
	\['decisions'][0]['decisionDate']  m
	\['auctions'][0]['auctionPeriod']['startDate']
	\['auctions'][1]['tenderingDuration']
	\['auctions'][2]['tenderingDuration']
	\['auctions'][0]['value']['amount']
	\['auctions'][0]['minimalStep']['amount']
	\['auctions'][0]['guarantee']['amount']
	\['auctions'][0]['registrationFee']['amount']
	\['auctions'][2]['auctionParameters']['dutchSteps']
	\['auctions'][0]['bankAccount']['bankName']
	\['auctions'][1]['bankAccount']['bankName']
	\['auctions'][2]['bankAccount']['bankName']
	\['auctions'][0]['bankAccount']['accountIdentification'][0]['scheme']
	\['auctions'][1]['bankAccount']['accountIdentification'][0]['scheme']
	\['auctions'][2]['bankAccount']['accountIdentification'][0]['scheme']
	\['auctions'][0]['bankAccount']['accountIdentification'][0]['id']
	\['auctions'][1]['bankAccount']['accountIdentification'][0]['id']
	\['auctions'][2]['bankAccount']['accountIdentification'][0]['id']
	\['auctions'][0]['bankAccount']['accountIdentification'][0]['description']
	\['auctions'][1]['bankAccount']['accountIdentification'][0]['description']
	\['auctions'][2]['bankAccount']['accountIdentification'][0]['description']


Перевірити відображення детальної інформації про інформаційне повідомлення
	[Tags]  compare  get_auction_href  qualification
	[Setup]  Run Keywords
	...  sale_keywords.Розгорнути детальну інформацію по всіх полях (за необхідністю)		AND
	...  Run Keyword If  '${site}' == 'test'  compare_data.Порівняти відображені дані з даними в ЦБД  ['lotCustodian']['identifier']['scheme']
	[Template]  compare_data.Порівняти відображені дані з даними в ЦБД
	\['lotID']
	\['title']
	\['description']
	\['decisions'][0]['decisionID']
	\['decisions'][0]['decisionDate']
	\['decisions'][1]['title']
	\['decisions'][1]['decisionID']
	\['decisions'][1]['decisionDate']
	\['auctions'][0]['auctionPeriod']['startDate']
	\['auctions'][0]['value']['amount']
	\['auctions'][1]['value']['amount']
	\['auctions'][2]['value']['amount']
	\['auctions'][0]['value']['valueAddedTaxIncluded']
	\['auctions'][1]['value']['valueAddedTaxIncluded']
	\['auctions'][2]['value']['valueAddedTaxIncluded']
	\['auctions'][0]['guarantee']['amount']
	\['auctions'][1]['guarantee']['amount']
	\['auctions'][2]['guarantee']['amount']
	\['auctions'][0]['registrationFee']['amount']
	\['auctions'][1]['registrationFee']['amount']
	\['auctions'][2]['registrationFee']['amount']
	\['auctions'][0]['minimalStep']['amount']
	\['auctions'][1]['minimalStep']['amount']
	\['auctions'][0]['minimalStep']['valueAddedTaxIncluded']
	\['auctions'][1]['minimalStep']['valueAddedTaxIncluded']
	\['auctions'][2]['auctionParameters']['dutchSteps']
	\['auctions'][0]['bankAccount']['bankName']
	\['auctions'][1]['bankAccount']['bankName']
	\['auctions'][2]['bankAccount']['bankName']
	\['auctions'][0]['bankAccount']['accountIdentification'][0]['id']
	\['auctions'][1]['bankAccount']['accountIdentification'][0]['id']
	\['auctions'][2]['bankAccount']['accountIdentification'][0]['id']
	\['auctions'][0]['bankAccount']['accountIdentification'][0]['scheme']
	\['auctions'][1]['bankAccount']['accountIdentification'][0]['scheme']
	\['auctions'][2]['bankAccount']['accountIdentification'][0]['scheme']
	\['lotCustodian']['identifier']['legalName']
	\['lotCustodian']['identifier']['id']
	\['lotCustodian']['contactPoint']['name']
	\['lotCustodian']['contactPoint']['telephone']
	\['lotCustodian']['contactPoint']['email']
	\['items'][0]['description']
	\['items'][0]['classification']['description']
	\['items'][0]['classification']['id']
	\['items'][0]['classification']['scheme']
	\['items'][0]['quantity']
	\['items'][0]['unit']['name']
	\['items'][0]['address']['postalCode']
	\['items'][0]['address']['countryName']
	\['items'][0]['address']['region']
	\['items'][0]['address']['locality']
	\['items'][0]['address']['streetAddress']


Дочекатися початку прийому пропозицій
	[Tags]  make_a_proposal  get_auction_href  qualification
	cdb2_ssp_lot_page.Дочекатися статусу повідомлення  Аукціон  30 min
	cdb2_ssp_lot_page.Дочекатися опублікування посилання на лот  15 min
	cdb2_ssp_lot_page.Перейти до аукціону
	cdb2_ssp_auction_page.Отримати UAID та href для Аукціону
	Log To Console  lot-id=${data['tender_id']}
	Log To Console  lot-href=${data['tender_href']}
	Зберегти сесію  tender_owner


Знайти аукціон учасниками
	[Tags]  make_a_proposal  get_auction_href  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Знайти аукціон користувачем  ${provider1}
	Зберегти сесію  ${provider1}
	Завантажити сесію для  ${provider2}
	Go To Smart  ${data['tender_href']}
	Зберегти сесію  ${provider2}
	Завантажити сесію для  ${provider3}
	Go To Smart  ${data['tender_href']}
	Зберегти сесію  ${provider3}
	Sleep  90


Подати заявки на участь в тендері
	[Tags]  make_a_proposal  get_auction_href  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	:FOR  ${i}  IN  1  2  3
	\  Завантажити сесію для  ${provider${i}}
	\  Подати заявку для подачі пропозиції


Підтвердити заявки на участь
	[Tags]  make_a_proposal  get_auction_href  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Підтвердити заявки на участь у тендері  ${data['tender_id']}


Подати пропозицію учасниками
	[Tags]  make_a_proposal  get_auction_href  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	:FOR  ${i}  IN  1  2  3
	\  Завантажити сесію для  ${provider${i}}
	\  Reload Page
	\  Дочекатись закінчення загрузки сторінки
	\  Натиснути на кнопку подачі пропозиції
	\  Заповнити поле з ціною  1  ${i}
	\  Подати пропозицію


Дочекатися початку аукціону
	[Tags]  get_auction_href
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  ${provider1}
	cdb2_ssp_auction_page.Дочекатися статусу лота  Аукціон  30 min


Отримати поcилання на участь учасниками
	[Tags]  get_auction_href
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
    :FOR  ${i}  IN  1  2  3
	\  Завантажити сесію для  ${provider${i}}
	\  Reload Page
	\  Дочекатись закінчення загрузки сторінки
	\  ${participate_href}  ${viewer_href}  get_auction_href.Отримати посилання на участь та прегляд аукціону для учасника
    \  Set To Dictionary  ${data}  viewer_href  ${viewer_href}
	\  Set To Dictionary  ${data}  provider${i}_participate_href  ${participate_href}
	\  Перейти та перевірити сторінку участі в аукціоні  ${participate_href}
	\  Go Back


Перевірити неможливість отримати поcилання на участь в аукціоні
	[Tags]  get_auction_href
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	[Template]  Неможливість отримати поcилання на участь в аукціоні глядачем
	${viewer}
	${tender_owner2}


Дочекатися початку кваліфікації
	[Tags]  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  ${tender_owner}
	#todo nuzhno vinesti keyword
	cdb2_ssp_auction_page.Дочекатися статусу лота  Очікується опублікування протоколу  120m
	#


Дискваліфікувати переможця аукціону
	[Tags]  qualification
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	cdb2_ssp_auction_page.Розгорнути результати аукціону для учасника  ${provider3}
	cdb2_ssp_auction_page.Натиснути "Дискваціфікувати"
	cdb2_ssp_auction_page.Натиснути дискваліфікація  Завантажити рішення про відмову у затвердженні протоколу
	cdb2_ssp_auction_page.Завантажити кваліфікаційний документ  Рішення про відмову у затвердженні протоколу




*** Keywords ***
Precondition
	Run Keyword If  '${where}' == 'test'  Run Keywords
	...  Set Global Variable  ${tender_owner}  ssp_tender_owner			AND
	...  Set Global Variable  ${tender_owner2}  test_tender_owner		AND
	...  Set Global Variable  ${provider1}  user1						AND
	...  Set Global Variable  ${provider2}  user2						AND
	...  Set Global Variable  ${provider3}  user3						AND
	...  Set Global Variable  ${viewer}  test_viewer
	Run Keyword If  'prod' in '${where}'  Run Keywords
	...  Set Global Variable  ${tender_owner}  prod_ssp_owner			AND
	...  Set Global Variable  ${tender_owner2}  prod_tender_owner		AND
	...  Set Global Variable  ${provider1}  prod_provider				AND
	...  Set Global Variable  ${provider2}  prod_provider2				AND
	...  Set Global Variable  ${provider3}  prod_provider1				AND
	...  Set Global Variable  ${viewer}  prod_viewer
	Додати першого користувача  ${tender_owner}
    Підготувати користувачів


Postcondition
    Log  ${data}
    Close All Browsers


Підготувати користувачів
    Додати користувача  ${tender_owner2}
    Додати користувача  ${provider1}
    Додати користувача  ${provider2}
    Додати користувача  ${provider3}
    Додати користувача  ${viewer}


Знайти аукціон користувачем
	[Arguments]  ${user_name}
	Завантажити сесію для  ${user_name}
	Sleep  2
	start_page.Натиснути на іконку з баннеру  Комерційні тендери SmartTender
	old_search.Активувати вкладку ФГИ
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	new_search.Очистити фільтр пошуку
	new_search.Очистити фільтр пошуку
	new_search.Ввести фразу для пошуку  ${data['tender_id']}
	new_search.Натиснути кнопку пошуку
	Дочекатись закінчення загрузки сторінки
	new_search.Перейти по результату пошуку за номером  1
	Дочекатись закінчення загрузки сторінки


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Location Should Contain  bidder_id=
	Підтвердити повідомлення про умови проведення аукціону
	${status}  Run Keyword And Return Status  Page Should Not Contain  Not Found
	Run Keyword If  ${status} != ${true}  Sleep  30
	Run Keyword If  ${status} != ${true}  Перейти та перевірити сторінку участі в аукціоні  ${auction_href}
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  20
	Sleep  2
	Element Should Contain  //*[@class="page-header"]//h2  ${data['tender_id']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${asset_data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${asset_data['items'][0]['description']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${asset_data['items'][0]['quantity']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${asset_data['items'][0]['unit']['name']}
	Page Should Contain Element  //h4[contains(text(),'Вхід на даний момент закритий.')]|//h4[contains(text(),'Ви зареєстровані як учасник. Очікуйте старту аукціону.')]


Неможливість отримати поcилання на участь в аукціоні глядачем
	[Arguments]  ${user}
	Завантажити сесію для  ${user}
	Go to  ${data['tender_href']}
	Дочекатись закінчення загрузки сторінки
	${auction_href}  get_auction_href.Отримати посилання на прегляд аукціону не учасником
	Run Keyword And Expect Error  *  get_auction_href.Отримати посилання на участь та прегляд аукціону для учасника


Натиснути на кнопку подачі пропозиції
    ${button}  Set Variable  //*[contains(text(), 'Подача пропозиції')]
    Page Should Contain Element  ${button}
    Open button  ${button}
    Location Should Contain  /edit/
    Wait Until Keyword Succeeds  5m  3  Run Keywords
    ...  Reload Page  AND
    ...  Element Should Not Be Visible  //*[@class='modal-dialog ']//h4
