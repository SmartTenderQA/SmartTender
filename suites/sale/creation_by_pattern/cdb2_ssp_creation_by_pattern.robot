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
#robot --consolecolors on -L TRACE:INFO -d test_output -i tag -v hub:none -v where:test suites/sale/creation_by_pattern/cdb2_ssp_creation_by_pattern.robot
*** Test Cases ***
Знайти об'єкт приватизації
	[Tags]  by_pattern  change_mode
	start_page.Натиснути на іконку з баннеру  Аукціони на продаж державного майна
	small_privatization_search.Активувати вкладку  Реєстр об'єктів приватизації
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	${object count}  small_privatization_search.Отримати кількість лотів
	${random object}  random_number  1  ${object count}
	small_privatization_search.Перейти по результату пошуку за номером  ${random object}
	${object url}  Get Location
	Log  ${object url}  WARN


Створити об'єкт за зразком
	[Tags]  by_pattern
	sale_keywords.Отримати prozorro ID
	${cdb_data_old}  Wait Until Keyword Succeeds  180  15  Отримати дані об'єкту приватизації з cdb по id  ${data['id']}
	Log  ${cdb_data_old}
	Зберегти Словник У Файл  ${cdb_data_old}  old
	Set Global Variable  ${cdb_data_old}  ${cdb_data_old}
	Click Element  ${create by pattern btn}
	Дочекатись закінчення загрузки сторінки
	sale_keywords.Натиснути кнопку зберегти
	sale_keywords.Натиснути кнопку опублікувати
	sale_keywords.Отримати prozorro ID
	${cdb_data_new}  Wait Until Keyword Succeeds  180  15  Отримати дані об'єкту приватизації з cdb по id  ${data['id']}
	Log  ${cdb_data_new}
	Зберегти Словник У Файл  ${cdb_data_new}  new
	Set Global Variable  ${cdb_data_new}  ${cdb_data_new}


Порівняти дані в цбд для двох об'єктів
	[Tags]  by_pattern
	[Template]  creation_by_pattern_keywords.Порівняти дані словників за назвою поля
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['title']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['documentOf']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['documentType']
	${cdb_data_old}  ${cdb_data_new}  ['description']
	${cdb_data_old}  ${cdb_data_new}  ['title']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['registrationDetails']['status']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['description']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['classification']['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['classification']['description']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['classification']['id']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][0]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][0]['description']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][0]['id']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['postalCode']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['countryName']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['streetAddress']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['region']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['locality']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['unit']['code']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['unit']['name']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['quantity']
	${cdb_data_old}  ${cdb_data_new}  ['mode']
	${cdb_data_old}  ${cdb_data_new}  ['title_ru']
	${cdb_data_old}  ${cdb_data_new}  ['owner']
	${cdb_data_old}  ${cdb_data_new}  ['decisions'][0]['decisionDate']
	${cdb_data_old}  ${cdb_data_new}  ['decisions'][0]['decisionID']
	${cdb_data_old}  ${cdb_data_new}  ['decisions'][0]['decisionOf']
	${cdb_data_old}  ${cdb_data_new}  ['decisions'][0]['title']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['contactPoint']['telephone']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['contactPoint']['name']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['contactPoint']['email']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['identifier']['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['identifier']['id']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['identifier']['legalName']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['name']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['address']['countryName']


Створити об'єкт за зразком та змінити режим публікації
	[Tags]  change_mode
	sale_keywords.Отримати prozorro ID
	${cdb_data_old}  Wait Until Keyword Succeeds  180  15  Отримати дані об'єкту приватизації з cdb по id  ${data['id']}
	Log  ${cdb_data_old}
	Зберегти Словник У Файл  ${cdb_data_old}  old
	Set Global Variable  ${cdb_data_old}  ${cdb_data_old}
	Click Element  ${create by pattern btn}
	Дочекатись закінчення загрузки сторінки
	small_privatization_search.Активувати перемемик тестового режиму на  викл
	sale_keywords.Натиснути кнопку зберегти
	sale_keywords.Натиснути кнопку опублікувати
	sale_keywords.Отримати prozorro ID
	${cdb_data_new}  Wait Until Keyword Succeeds  180  15  Отримати дані об'єкту приватизації з cdb по id  ${data['id']}
	Log  ${cdb_data_new}
	Зберегти Словник У Файл  ${cdb_data_new}  new
	Set Global Variable  ${cdb_data_new}  ${cdb_data_new}
	Dictionary Should Not Contain Key  ${cdb_data_new}  mode  Oops! В об'єкта створеного за зразком залишився тестовий режим


Порівняти дані в цбд для двох об'єктів
	[Tags]  change_mode
	[Template]  creation_by_pattern_keywords.Порівняти дані словників за назвою поля
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['title']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['documentOf']
	${cdb_data_old}  ${cdb_data_new}  ['documents'][0]['documentType']
	${cdb_data_old}  ${cdb_data_new}  ['description']
	${cdb_data_old}  ${cdb_data_new}  ['title']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['registrationDetails']['status']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['description']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['classification']['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['classification']['description']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['classification']['id']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][0]['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][0]['description']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['additionalClassifications'][0]['id']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['postalCode']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['countryName']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['streetAddress']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['region']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['address']['locality']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['unit']['code']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['unit']['name']
	${cdb_data_old}  ${cdb_data_new}  ['items'][0]['quantity']
	${cdb_data_old}  ${cdb_data_new}  ['owner']
	${cdb_data_old}  ${cdb_data_new}  ['decisions'][0]['decisionDate']
	${cdb_data_old}  ${cdb_data_new}  ['decisions'][0]['decisionID']
	${cdb_data_old}  ${cdb_data_new}  ['decisions'][0]['decisionOf']
	${cdb_data_old}  ${cdb_data_new}  ['decisions'][0]['title']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['contactPoint']['telephone']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['contactPoint']['name']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['contactPoint']['email']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['identifier']['scheme']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['identifier']['id']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['identifier']['legalName']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['name']
	${cdb_data_old}  ${cdb_data_new}  ['assetCustodian']['address']['countryName']


*** Keywords ***
Precondition
    ${tender_owner}  Set Variable If
    ...  '${where}' == 'test'  ssp_tender_owner
    ...  'prod' in '${where}'  prod_ssp_owner
   	Set Global Variable  ${tender_owner}  ${tender_owner}
    Додати першого користувача  ${tender_owner}
    cdb2_ssp_step.Завантажити локатори для об'єкта


