*** Settings ***
Documentation    Suite description
Resource  ../../../src/src.robot
Resource  creation_by_pattern_keywords.robot
Suite Setup  Precondition
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Element Screenshot  //body

*** Variables ***
${create by pattern btn}            //*[@data-qa="button-create-by-pattern"]

#zapusk
#robot --consolecolors on -L TRACE:INFO -d test_output -i by_pattern -v hub:none -v where:test suites/sale/creation_by_pattern/cdb2_LandLease_creation_by_pattern.robot
*** Test Cases ***
Знайти аукціон
	[Tags]  by_pattern  change_mode
	start_page.Натиснути на іконку з баннеру  Аукціони на продаж державного майна
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	small_privatization_search.Встановити фільтр "Організатор"  Адвокатське Бюро "І Ес Ей Сторожук та Партнери"
	${page count}  small_privatization_search.Отримати кількість сторінок
	${random page}  random_number  1  ${page count}
	small_privatization_search.Перейти на сторінку за номером  ${random page}
	${auctions count}  new_search.Порахувати кількість торгів
	${random auction}  random_number  1  ${auctions count}
	new_search.Перейти по результату пошуку за номером  ${random auction}


Створити аукціон за зразком
	[Tags]  by_pattern
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	sale_keywords.Отримати prozorro ID
	${cdb_data_old}  Wait Until Keyword Succeeds  180  15  Отримати дані Аукціону ДЗК з cdb по id  ${data['id']}
	Log  ${cdb_data_old}
	Зберегти Словник У Файл  ${cdb_data_old}  old
	Set Global Variable  ${cdb_data_old}  ${cdb_data_old}
	Click Element  ${create by pattern btn}
	Дочекатись закінчення загрузки сторінки
	Run Keyword  cdb2_LandLease_step.Заповнити "Дата проведення аукціону" ${site}
	sale_keywords.Натиснути кнопку зберегти
	sale_keywords.Натиснути кнопку опублікувати
	sale_keywords.Отримати prozorro ID
	${cdb_data_new}  Wait Until Keyword Succeeds  180  15  Отримати дані Аукціону ДЗК з cdb по id  ${data['id']}
	Log  ${cdb_data_new}
	Зберегти Словник У Файл  ${cdb_data_new}  new
	Set Global Variable  ${cdb_data_new}  ${cdb_data_new}


Порівняти дані в цбд для двох об'єктів
	[Tags]  by_pattern
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	[Template]  creation_by_pattern_keywords.Порівняти дані словників за назвою поля
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][0]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][0]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][0]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][1]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][1]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][1]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][2]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][2]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][2]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][3]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][3]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][3]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][4]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][4]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][4]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][5]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][5]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][5]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][6]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][6]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][6]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][7]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][7]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][7]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][8]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][8]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][8]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['bankName']
	${cdb_data_old}  ${cdb_data_new}  ['minNumberOfQualifiedBids']
	${cdb_data_old}  ${cdb_data_new}  ['registrationFee']['currency']
	${cdb_data_old}  ${cdb_data_new}  ['registrationFee']['amount']
	${cdb_data_old}  ${cdb_data_new}  ['submissionMethod']
	${cdb_data_old}  ${cdb_data_new}  ['procurementMethodType']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['contactPoint']['telephone']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['contactPoint']['name']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['contactPoint']['email']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['identifier']['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['identifier']['id']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['identifier']['legalName']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['name']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['address']['countryName']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['address']['streetAddress']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['address']['region']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['address']['locality']
	${cdb_data_old}  ${cdb_data_new}  ['owner']
	${cdb_data_old}  ${cdb_data_new}  ['guarantee']['currency']
	${cdb_data_old}  ${cdb_data_new}  ['guarantee']['amount']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['hash']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['description']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['title']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['url']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['format']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['documentOf']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['documentType']
	${cdb_data_old}  ${cdb_data_new}  ['title']
	${cdb_data_old}  ${cdb_data_new}  ['procurementMethodDetails']
	${cdb_data_old}  ${cdb_data_new}  ['auctionParameters']['type']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['contactPoint']['telephone']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['contactPoint']['name']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['contactPoint']['email']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['identifier']['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['identifier']['id']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['identifier']['legalName']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['name']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['address']['postalCode']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['address']['countryName']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['address']['streetAddress']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['address']['region']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['address']['locality']
	${cdb_data_old}  ${cdb_data_new}  ['description']
	${cdb_data_old}  ${cdb_data_new}  ['title_en']
	${cdb_data_old}  ${cdb_data_new}  ['budgetSpent']['currency']
	${cdb_data_old}  ${cdb_data_new}  ['budgetSpent']['amount']
	${cdb_data_old}  ${cdb_data_new}  ['budgetSpent']['valueAddedTaxIncluded']
	${cdb_data_old}  ${cdb_data_new}  ['contractTerms']['type']
	${cdb_data_old}  ${cdb_data_new}  ['contractTerms']['leaseTerms']['leaseDuration']
	${cdb_data_old}  ${cdb_data_new}  ['submissionMethodDetails']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['description']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['classification']['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['classification']['id']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['classification']['description']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][0]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][0]['id']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][0]['description']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][1]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][1]['id']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][1]['description']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['postalCode']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['countryName']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['streetAddress']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['region']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['locality']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['unit']['code']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['unit']['name']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['quantity']
	${cdb_data_old}  ${cdb_data_new}  ['procurementMethod']
	${cdb_data_old}  ${cdb_data_new}  ['value']['currency']
	${cdb_data_old}  ${cdb_data_new}  ['value']['amount']
	${cdb_data_old}  ${cdb_data_new}  ['value']['valueAddedTaxIncluded']
	${cdb_data_old}  ${cdb_data_new}  ['minimalStep']['currency']
	${cdb_data_old}  ${cdb_data_new}  ['minimalStep']['amount']
	${cdb_data_old}  ${cdb_data_new}  ['minimalStep']['valueAddedTaxIncluded']
	${cdb_data_old}  ${cdb_data_new}  ['mode']
	${cdb_data_old}  ${cdb_data_new}  ['title_ru']
	${cdb_data_old}  ${cdb_data_new}  ['awardCriteria']



Створити об'єкт за зразком та змінити режим публікації
	[Tags]  change_mode
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	sale_keywords.Отримати prozorro ID
	${cdb_data_old}  Wait Until Keyword Succeeds  180  15  Отримати дані Аукціону ДЗК з cdb по id  ${data['id']}
	Log  ${cdb_data_old}
	Зберегти Словник У Файл  ${cdb_data_old}  old
	Set Global Variable  ${cdb_data_old}  ${cdb_data_old}
	Click Element  ${create by pattern btn}
	Дочекатись закінчення загрузки сторінки
	cdb2_ssp_asset_page.Активувати перемемик тестового режиму на  викл
	cdb2_LandLease_step.Заповнити "Дата проведення аукціону" prod
	sale_keywords.Натиснути кнопку зберегти
	sale_keywords.Натиснути кнопку опублікувати
	sale_keywords.Отримати prozorro ID
	${cdb_data_new}  Wait Until Keyword Succeeds  180  15  Отримати дані Аукціону ДЗК з cdb по id  ${data['id']}
	Log  ${cdb_data_new}
	Зберегти Словник У Файл  ${cdb_data_new}  new
	Set Global Variable  ${cdb_data_new}  ${cdb_data_new}
	Dictionary Should Not Contain Key  ${cdb_data_new}  mode  Oops! В аукцыону створеного за зразком залишився тестовий режим


Порівняти дані в цбд для двох об'єктів
	[Tags]  change_mode
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	[Template]  creation_by_pattern_keywords.Порівняти дані словників за назвою поля
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][0]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][0]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][0]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][1]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][1]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][1]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][2]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][2]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][2]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][3]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][3]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][3]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][4]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][4]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][4]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][5]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][5]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][5]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][6]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][6]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][6]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][7]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][7]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][7]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][8]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][8]['id']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['accountIdentification'][8]['description']
	${cdb_data_old}  ${cdb_data_new}  ['bankAccount']['bankName']
	${cdb_data_old}  ${cdb_data_new}  ['minNumberOfQualifiedBids']
	${cdb_data_old}  ${cdb_data_new}  ['registrationFee']['currency']
	${cdb_data_old}  ${cdb_data_new}  ['registrationFee']['amount']
	${cdb_data_old}  ${cdb_data_new}  ['submissionMethod']
	${cdb_data_old}  ${cdb_data_new}  ['procurementMethodType']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['contactPoint']['telephone']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['contactPoint']['name']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['contactPoint']['email']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['identifier']['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['identifier']['id']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['identifier']['legalName']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['name']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['address']['countryName']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['address']['streetAddress']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['address']['region']
	${cdb_data_old}  ${cdb_data_new}  ['procuringEntity']['address']['locality']
	${cdb_data_old}  ${cdb_data_new}  ['owner']
	${cdb_data_old}  ${cdb_data_new}  ['guarantee']['currency']
	${cdb_data_old}  ${cdb_data_new}  ['guarantee']['amount']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['hash']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['description']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['title']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['url']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['format']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['documentOf']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['documentType']
	${cdb_data_old}  ${cdb_data_new}  ['title']
	${cdb_data_old}  ${cdb_data_new}  ['procurementMethodDetails']
	${cdb_data_old}  ${cdb_data_new}  ['auctionParameters']['type']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['contactPoint']['telephone']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['contactPoint']['name']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['contactPoint']['email']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['identifier']['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['identifier']['id']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['identifier']['legalName']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['name']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['address']['postalCode']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['address']['countryName']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['address']['streetAddress']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['address']['region']
	${cdb_data_old}  ${cdb_data_new}  ['lotHolder']['address']['locality']
	${cdb_data_old}  ${cdb_data_new}  ['description']
	${cdb_data_old}  ${cdb_data_new}  ['budgetSpent']['currency']
	${cdb_data_old}  ${cdb_data_new}  ['budgetSpent']['amount']
	${cdb_data_old}  ${cdb_data_new}  ['budgetSpent']['valueAddedTaxIncluded']
	${cdb_data_old}  ${cdb_data_new}  ['contractTerms']['type']
	${cdb_data_old}  ${cdb_data_new}  ['contractTerms']['leaseTerms']['leaseDuration']
	${cdb_data_old}  ${cdb_data_new}  ['submissionMethodDetails']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['description']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['classification']['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['classification']['id']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['classification']['description']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][0]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][0]['id']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][0]['description']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][1]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][1]['id']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][1]['description']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['postalCode']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['countryName']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['streetAddress']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['region']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['locality']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['unit']['code']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['unit']['name']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['quantity']
	${cdb_data_old}  ${cdb_data_new}  ['procurementMethod']
	${cdb_data_old}  ${cdb_data_new}  ['value']['currency']
	${cdb_data_old}  ${cdb_data_new}  ['value']['amount']
	${cdb_data_old}  ${cdb_data_new}  ['value']['valueAddedTaxIncluded']
	${cdb_data_old}  ${cdb_data_new}  ['minimalStep']['currency']
	${cdb_data_old}  ${cdb_data_new}  ['minimalStep']['amount']
	${cdb_data_old}  ${cdb_data_new}  ['minimalStep']['valueAddedTaxIncluded']
	${cdb_data_old}  ${cdb_data_new}  ['awardCriteria']


*** Keywords ***
Precondition
    ${tender_owner}  Set Variable If
    ...  '${where}' == 'test'  USER_DZK
    ...  'prod' in '${where}'  no_user
   	Set Global Variable  ${tender_owner}  ${tender_owner}
    Додати першого користувача  ${tender_owner}
    cdb2_LandLease_step.Завантажити локатори
