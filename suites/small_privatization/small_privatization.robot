*** Settings ***
Resource  ../../src/src.robot
Library  ../../src/pages/small_privatization/small_privatization_object/small_privatization_object_variables.py
Library  ../../src/pages/small_privatization/small_privatization_informational_message/small_privatization_informational_message_variables.py
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Run Keywords  Capture Page Screenshot
...  AND  Log Location
...  AND  Log  ${data}


*** Variables ***

#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output --noncritical compare -v user:ssp_tender_owner -v hub:None suites/small_privatization/small_privatization.robot
#robot --consolecolors on -L TRACE:INFO -d test_output --noncritical compare -e -prod -v user:prod_ssp_owner -v hub:None suites/small_privatization/small_privatization.robot
*** Test Cases ***
Створити об'єкт МП
	Завантажити сесію для  tender_owner
	Завантажити variables.py для об'єкта
	small_privatization_step.Створити об'єкт МП
	small_privatization_object.Отримати UAID для Об'єкту
	small_privatization_object.Отримати ID у цбд
	${location}  Get Location
	Log To Console  url=${location}
	Зберегти словник у файл  ${data}  asset


Отримати дані про об'єкт з ЦБД
	[Tags]  compare
	${cdb_data}  Отримати дані об'єкту приватизації з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  asset_cdb_data


Порівняти введені дані з даними в ЦБД
	[Tags]  compare
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
	[Tags]  compare
	[Setup]  Run Keywords
	...  dzk_auction.Розгорнути детальну інформацію по всіх полях (за необхідністю)		AND
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
	[Setup]  Go To  ${start page}
	Set Global Variable  ${asset_data}  ${data}
	Завантажити variables.py для інформаційного повідомлення
	small_privatization_step.Створити інформаційне повідомлення МП  ${cdb_data['assetID']}
	small_privatization_informational_message.Дочекатися статусу повідомлення  Опубліковано  10 min
	small_privatization_object.Отримати ID у цбд
	${location}  Get Location
	Log To Console  url=${location}
	Зберегти словник у файл  ${data}  message


Отримати дані про інформаційне повідомлення з ЦБД
	[Tags]  compare
	${cdb_data}  Отримати дані інформаційного повідомлення приватизації з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  message_cdb_data


Порівняти введені дані з даними в ЦБД
	[Tags]  compare
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
	[Tags]  compare
	[Setup]  Run Keywords
	...  dzk_auction.Розгорнути детальну інформацію по всіх полях (за необхідністю)		AND
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
	[Tags]  -prod
	small_privatization_informational_message.Дочекатися статусу повідомлення  Аукціон  15 min
	small_privatization_informational_message.Дочекатися опублікування посилання на лот  15 min
	small_privatization_informational_message.Перейти до аукціону
	small_privatization_auction.Отримати UAID та href для Аукціону
	Log To Console  lot-id=${data['tender_id']}
	Log To Console  lot-href=${data['tender_href']}
	Зберегти сесію  tender_owner


Знайти аукціон учасниками
	[Tags]  -prod
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Знайти аукціон користувачем  provider1
	Зберегти сесію  provider1
	Завантажити сесію для  provider2
	Go To  ${data['tender_href']}
	Зберегти сесію  provider2
	Завантажити сесію для  provider3
	Go To  ${data['tender_href']}
	Зберегти сесію  provider3
	Sleep  90


Подати заявки на участь в тендері
	[Tags]  -prod
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	:FOR  ${i}  IN  1  3
	\  Завантажити сесію для  provider${i}
	\  Подати заявку для подачі пропозиції


Підтвердити заявки на участь
	[Tags]  -prod
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Підтвердити заявки на участь у тендері  ${data['tender_id']}


Подати пропозицію учасниками
	[Tags]  -prod
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	:FOR  ${i}  IN  1  3
	\  Завантажити сесію для  provider${i}
	\  Reload Page
	\  Дочекатись закінчення загрузки сторінки(skeleton)
	\  Натиснути на кнопку подачі пропозиції
	\  Заповнити поле з ціною  1  1
	\  Подати пропозицію


Дочекатися початку аукціону
	[Tags]  -prod
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  provider1
	small_privatization_auction.Дочекатися статусу лота  Аукціон  30 min


Отримати поcилання на участь учасниками
	[Tags]  -prod
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
    :FOR  ${i}  IN  1  3
	\  Завантажити сесію для  provider${i}
	\  Reload Page
	\  Дочекатись закінчення загрузки сторінки(skeleton)
	\  ${participate_href}  ${viewer_href}  get_auction_href.Отримати посилання на участь та прегляд аукціону для учасника
    \  Set To Dictionary  ${data}  viewer_href  ${viewer_href}
	\  Set To Dictionary  ${data}  provider${i}_participate_href  ${participate_href}
	\  Перейти та перевірити сторінку участі в аукціоні  ${participate_href}
	\  Go Back


Перевірити неможливість отримати поcилання на участь в аукціоні
	[Tags]  -prod
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	[Template]  Неможливість отримати поcилання на участь в аукціоні глядачем
	viewer
	tender_owner2
	provider3


*** Keywords ***
Precondition
	Додати першого користувача  ${user}  tender_owner
    Підготувати користувачів


Завантажити variables.py для об'єкта
	${edit_locators}  small_privatization_object_variables.get_edit_locators
	${view_locators}  small_privatization_object_variables.get_view_locators
	${data}  small_privatization_object_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}


Завантажити variables.py для інформаційного повідомлення
	${edit_locators}  small_privatization_informational_message_variables.get_edit_locators
	${view_locators}  small_privatization_informational_message_variables.get_view_locators
	${data}  small_privatization_informational_message_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}


Postcondition
    Log  ${data}
    Close All Browsers


Підготувати користувачів
    Run Keyword If  "${site}" == "prod"  Run Keywords
    ...  Додати користувача			 prod_tender_owner  tender_owner2 	AND
    ...  Додати користувача          prod_provider  	provider1     	AND
    ...  Додати користувача          prod_provider1  	provider2     	AND
    ...  Додати користувача          prod_provider2  	provider3     	AND
    ...  Додати користувача          prod_provider2  	provider3     	AND
    ...  Додати користувача          prod_viewer     	viewer
    Run Keyword If  "${site}" == "test"  Run Keywords
    ...  Додати користувача			 test_tender_owner	tender_owner2 	AND
    ...  Додати користувача          user1           	provider1     	AND
    ...  Додати користувача          user2           	provider2     	AND
    ...  Додати користувача          user3           	provider3     	AND
    ...  Додати користувача          test_viewer     	viewer


Знайти аукціон користувачем
	[Arguments]  ${role}
	Завантажити сесію для  ${role}
	Sleep  2
	start_page.Натиснути На торговельний майданчик
	old_search.Активувати вкладку ФГИ
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	new_search.Очистити фільтр пошуку
	new_search.Очистити фільтр пошуку
	new_search.Ввести фразу для пошуку  ${data['tender_id']}
	new_search.Натиснути кнопку пошуку
	Дочекатись закінчення загрузки сторінки(skeleton)
	new_search.Перейти по результату пошуку за номером  1
	Дочекатись закінчення загрузки сторінки(skeleton)


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
	Element Should Contain  //h4  Вхід на даний момент закритий.


Неможливість отримати поcилання на участь в аукціоні глядачем
	[Arguments]  ${user}
	Завантажити сесію для  ${user}
	Go to  ${data['tender_href']}
	Дочекатись закінчення загрузки сторінки(skeleton)
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
