*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords  Capture Element Screenshot  //body
...  AND  Log Location
...  AND  Log  ${data}


*** Variables ***


#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output -e broken --noncritical compare -e -test suites/get_auction_href/cdb2_LandLease.robot
*** Test Cases ***
Створити аукціон
	Завантажити сесію для  ${tender_owner}
	cdb2_LandLease_step.Створити аукціон
	cdb2_LandLease_page.Отримати UAID та href для Аукціону
	cdb2_LandLease_page.Отримати ID у цбд
	Зберегти словник у файл  ${data}  data
	Log To Console  url=${data['tender_href']}


Отримати дані про аукціон з ЦБД
	[Tags]  compare
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	${cdb_data}  Wait Until Keyword Succeeds  60  15  Отримати дані Аукціону ДЗК з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  cdb_data


Порівняти введені дані з даними в ЦБД
	[Tags]  compare
	[Template]  compare_data.Порівняти введені дані з даними в ЦБД
	\['lotIdentifier']
	\['title']
	\['description']
	\['lotHolder']['identifier']['legalName']
	\['lotHolder']['identifier']['id']
	\['lotHolder']['address']['postalCode']
	\['lotHolder']['address']['region']
	\['lotHolder']['address']['locality']
	\['lotHolder']['address']['streetAddress']
	\['lotHolder']['contactPoint']['name']
	\['lotHolder']['contactPoint']['email']
	\['tenderAttempts']
	\['minNumberOfQualifiedBids']
	\['contractTerms']['leaseTerms']['leaseDuration']
	\['value']['amount']
	\['minimalStep']['amount']
	\['guarantee']['amount']
	\['budgetSpent']['amount']
	\['registrationFee']['amount']
	\['bankAccount']['bankName']
	\['bankAccount']['accountIdentification'][0]['description']
    \['bankAccount']['accountIdentification'][1]['id']
    \['bankAccount']['accountIdentification'][2]['id']
    \['bankAccount']['accountIdentification'][3]['id']
    \['bankAccount']['accountIdentification'][4]['id']
    \['bankAccount']['accountIdentification'][5]['id']
    \['bankAccount']['accountIdentification'][6]['id']
    \['bankAccount']['accountIdentification'][7]['id']
    \['bankAccount']['accountIdentification'][8]['id']
	\['items'][0]['description']
	\['items'][0]['additionalClassifications'][1]['id']
	\['items'][0]['classification']['id']
	\['items'][0]['classification']['description']
	\['items'][0]['additionalClassifications'][0]['id']
	\['items'][0]['additionalClassifications'][0]['description']
	\['items'][0]['quantity']
	\['items'][0]['unit']['name']
	\['items'][0]['address']['postalCode']
	\['items'][0]['address']['region']
	\['items'][0]['address']['locality']
	\['items'][0]['address']['streetAddress']


Перевірити відображення детальної інформації
	[Tags]  compare
	[Setup]  Run Keywords
	...  sale_keywords.Розгорнути детальну інформацію по всіх полях (за необхідністю)		AND
	...  Wait Until Keyword Succeeds  5m  15s  Дочекатися довантаження даних з ЦБД
	[Template]  compare_data.Порівняти відображені дані з даними в ЦБД
	\['title']
	\['lotIdentifier']
	\['auctionID']
	\['description']
	\['rectificationPeriod']['startDate']
	\['rectificationPeriod']['endDate']
	\['tenderPeriod']['startDate']
	\['tenderPeriod']['endDate']
	\['minimalStep']['amount']
	\['guarantee']['amount']
	\['budgetSpent']['amount']
	\['registrationFee']['amount']
	\['minNumberOfQualifiedBids']
	\['contractTerms']['leaseTerms']['leaseDuration']
	\['procuringEntity']['identifier']['legalName']
	\['procuringEntity']['identifier']['id']
	\['procuringEntity']['contactPoint']['email']
	\['procuringEntity']['contactPoint']['name']
	\['procuringEntity']['contactPoint']['telephone']
	\['procuringEntity']['address']['countryName']
	\['procuringEntity']['address']['streetAddress']
	\['procuringEntity']['address']['region']
	\['procuringEntity']['address']['locality']
	\['bankAccount']['bankName']
	\['bankAccount']['accountIdentification'][0]['description']
    \['bankAccount']['accountIdentification'][0]['id']
    \['bankAccount']['accountIdentification'][1]['id']
    \['bankAccount']['accountIdentification'][2]['id']
    \['bankAccount']['accountIdentification'][3]['id']
    \['bankAccount']['accountIdentification'][4]['id']
    \['bankAccount']['accountIdentification'][5]['id']
    \['bankAccount']['accountIdentification'][6]['id']
    \['bankAccount']['accountIdentification'][7]['id']
    \['bankAccount']['accountIdentification'][8]['id']
	\['lotHolder']['identifier']['legalName']
	\['lotHolder']['identifier']['id']
	\['lotHolder']['identifier']['scheme']
	\['lotHolder']['address']['postalCode']
	\['lotHolder']['address']['region']
	\['lotHolder']['address']['locality']
	\['lotHolder']['address']['streetAddress']
	\['lotHolder']['contactPoint']['name']
	\['lotHolder']['contactPoint']['email']
	\['items'][0]['description']
	\['items'][0]['classification']['scheme']
	\['items'][0]['classification']['id']
	\['items'][0]['classification']['description']
	\['items'][0]['additionalClassifications'][0]['scheme']
	\['items'][0]['additionalClassifications'][0]['id']
	\['items'][0]['additionalClassifications'][0]['description']
	\['items'][0]['additionalClassifications'][1]['id']
	\['items'][0]['quantity']
	\['items'][0]['unit']['name']
	\['items'][0]['address']['postalCode']
	\['items'][0]['address']['countryName']
	\['items'][0]['address']['region']
	\['items'][0]['address']['locality']
	\['items'][0]['address']['streetAddress']


Знайти аукціон учасниками
	[Tags]  -prod
	Знайти аукціон користувачем  ${provider1}
	Зберегти сесію  ${provider1}
	Завантажити сесію для  ${provider2}
	Go To  ${data['tender_href']}
	Зберегти сесію  ${provider2}
	Завантажити сесію для  ${provider3}
	Go To  ${data['tender_href']}
	Зберегти сесію  ${provider3}
	Sleep  90


Подати заявки на участь в тендері
	[Tags]  -prod  broken
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	:FOR  ${i}  IN  1  3
	\  Завантажити сесію для  ${provider${i}}
	\  Подати заявку для подачі пропозиції


Підтвердити заявки на участь
	[Tags]  -prod  broken
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Підтвердити заявки на участь у тендері  ${data['auctionID']}


Подати пропозицію учасниками
	[Tags]  -prod  -test
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	:FOR  ${i}  IN  1  3
	\  Завантажити сесію для  ${provider${i}}
	\  Reload Page
	\  Дочекатись закінчення загрузки сторінки
	\  Натиснути на кнопку подачі пропозиції
	\  Заповнити поле з ціною  1  1
	\  Подати пропозицію


Дочекатися початку аукціону
	[Tags]  -prod  -test
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  ${provider1}
	cdb2_ssp_auction_page.Дочекатися статусу лота  Аукціон  35 min


Отримати поcилання на участь учасниками
	[Tags]  -prod  -test
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
    :FOR  ${i}  IN  1  2
	\  Завантажити сесію для  ${provider${i}}
	\  Reload Page
	\  Дочекатись закінчення загрузки сторінки
	\  Натиснути кнопку "До аукціону"
	\  ${viewer_href}  Отримати URL на перегляд
    \  Set To Dictionary  ${data}  viewer_href  ${viewer_href}
	\  ${participate_href}  Wait Until Keyword Succeeds  60  3  Отримати URL для участі в аукціоні
	\  Set To Dictionary  ${data}  provider${i}_participate_href  ${participate_href}
	\  Перейти та перевірити сторінку участі в аукціоні  ${participate_href}
	\  Go Back


Перевірити неможливість отримати поcилання на участь в аукціоні
	[Tags]  -prod  -test
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	[Template]  Неможливість отримати поcилання на участь в аукціоні глядачем
	${viewer}
	${tender_owner2}
	${provider3}


*** Keywords ***
Precondition
	Set Global Variable  ${tender_owner}  USER_DZK
	Set Global Variable  ${tender_owner2}  test_tender_owner
	Set Global Variable  ${provider1}  user1
	Set Global Variable  ${provider2}  user2
	Set Global Variable  ${provider3}  user3
	Set Global Variable  ${viewer}  test_viewer
    Додати першого користувача  ${tender_owner}
    Підготувати користувачів


Підготувати користувачів
    Додати користувача	${tender_owner2}
    Додати користувача  ${provider1}
    Додати користувача  ${provider2}
    Додати користувача  ${provider3}
    Додати користувача  ${viewer}


Дочекатися довантаження даних з ЦБД
	Reload Page
	Дочекатись закінчення загрузки сторінки
	${title locator}  Set Variable  ${view_locators['title']}
	${title}  Get Text  ${title locator}
	Should Contain  ${title}  [ТЕСТУВАННЯ]


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
	new_search.Ввести фразу для пошуку  ${data['id']}
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
	Element Should Contain  //*[@class="page-header"]//h2  ${data['auctionID']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['0']['description']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['0']['quantity']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['0']['unit']['name']}
	Element Should Contain  //h4  Вхід на даний момент закритий.


Неможливість отримати поcилання на участь в аукціоні глядачем
	[Arguments]  ${user}
	Завантажити сесію для  ${user}
	Go to  ${data['tender_href']}
	Дочекатись закінчення загрузки сторінки
	${auction_participate_href}  Run Keyword And Expect Error  *  Run Keywords
	...  Натиснути кнопку "До аукціону"
	...  AND  Отримати URL для участі в аукціоні


Натиснути на кнопку подачі пропозиції
    ${button}  Set Variable  //*[contains(text(), 'Подача пропозиції')]
    Page Should Contain Element  ${button}
    Open button  ${button}
    Location Should Contain  /edit/
    Wait Until Keyword Succeeds  5m  3  Run Keywords
    ...  Reload Page  AND
    ...  Element Should Not Be Visible  //*[@class='modal-dialog ']//h4


Заповнити поле сума пропозиції
  [Documentation]  takes lot number and coefficient
  ...  fill bid field with max available price
  [Arguments]  ${lot number}  ${coefficient}
  ${block number}  Set Variable  ${lot number}+1
  ${a}=  Get Text  ${block}\[${block number}]//div[@class='amount lead'][1]
  ${a}=  get_number  ${a}
  ${amount}=  Evaluate  int(${a}*${coefficient})
  ${field number}=  Evaluate  ${lot number}-1
  Input Text  xpath=//*[@id="lotAmount${field number}"]/input[1]  ${amount}


Додати документ, що підтверджує кваліфікацію
	${selector}  Set Variable  //*[@document-caption='Документ']
	Створити та додати файл  ${selector}//input
	Click Element  ${selector}//*[@class='dropdown']
	Click Element  ${selector}//*[contains(text(),'Документи, що підтверджують кваліфікацію')]


Натиснути Подати пропозицію
	Click Element  ${send offer button}
	${ok button}  Set Variable  //*[@class='ivu-poptip-inner' and contains(.,'Анулювати пропозицію буде неможливо, подати пропозицію?')]//button[contains(.,'Так')]
	Wait Until Element Is Visible  ${ok button}
	Click Element  ${ok button}
