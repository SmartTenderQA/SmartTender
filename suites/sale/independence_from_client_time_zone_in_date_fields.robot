*** Settings ***
Documentation    Suite description
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Element Screenshot  //body

*** Variables ***


#zapusk
#robot --consolecolors on -L TRACE:INFO -d test_output -v hub:none -v where:test suites/sale/independence_from_client_time_zone_in_date_fields.robot
*** Test Cases ***
Створити об'єкт МП
	[Tags]  cdb2_ssp
	cdb2_ssp_step.Створити об'єкт МП
	cdb2_ssp_asset_page.Отримати UAID для Об'єкту
	sale_keywords.Отримати prozorro ID
	${cdb_data}  Wait Until Keyword Succeeds  180  15  Отримати дані об'єкту приватизації з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  asset_cdb_data


Перевірити дату рішення для об'єкта МП в ЦБД
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	compare_data.Порівняти введені дані з даними в ЦБД  ['decisions'][0]['decisionDate']


Перевірити дату рішення для об'єкта МП на сторінці детальної інформації
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	sale_keywords.Розгорнути детальну інформацію по всіх полях (за необхідністю)
    compare_data.Порівняти відображені дані з даними в ЦБД  ['decisions'][0]['decisionDate']


Перевірити дату рішення для об'єкта МП на сторінці редагування
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	${edit btn}  Set Variable  //*[@data-qa="button-to-edit-page"]
	elements.Дочекатися відображення елемента на сторінці  ${edit btn}
	Click Element  ${edit btn}
	Дочекатись закінчення загрузки сторінки
	${decisionDate is}  Get Element Attribute  ${edit_locators['decisions'][0]['decisionDate']}  value
	Should Be Equal  ${decisionDate is}  ${data['decisions'][0]['decisionDate'][:-3]}  Oops! decisionDate на сторінці редагування змінилася


Створити та перевірити ІП для МП
	[Tags]  cdb2_ssp
	Go To  ${start page}

	cdb2_ssp_step.Завантажити локатори для ІП

	start_page.Натиснути на іконку з баннеру  Комерційні тендери SmartTender
	old_search.Активувати вкладку ФГИ
	small_privatization_search.Активувати вкладку  Реєстр об'єктів приватизації
	small_privatization_search.Вибрати режим сторінки об'єктів приватизації  Кабінет
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	small_privatization_search.Натиснути створити  інформаційне повідомлення
	cdb2_ssp_step.Заповнити "Унікальний код об'єкту"  ${assetID}
	cdb2_ssp_step.Заповнити "Рішення про затверждення умов продажу"
	cdb2_ssp_step.Заповнити "Умови аукціону"
	cdb2_ssp_step.Заповнити "Банківські реквізити"
	sale_keywords.Натиснути кнопку зберегти
	sale_keywords.Натиснути кнопку опублікувати

	sale_keywords.Отримати prozorro ID
	${cdb_data}  Wait Until Keyword Succeeds  180  15  Отримати дані інформаційного повідомлення приватизації з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  lot_cdb_data


Перевірити дату рішення для об'єкта ІП в ЦБД
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	compare_data.Порівняти введені дані з даними в ЦБД  ['decisions'][0]['decisionDate']


Перевірити дату рішення для ІП МП на сторінці детальної інформації
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	sale_keywords.Розгорнути детальну інформацію по всіх полях (за необхідністю)
    compare_data.Порівняти відображені дані з даними в ЦБД  ['decisions'][0]['decisionDate']


Перевірити дату рішення для ІП МП на сторінці редагування
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	${edit btn}  Set Variable  //*[@data-qa="button-to-edit-page"]
	elements.Дочекатися відображення елемента на сторінці  ${edit btn}
	Click Element  ${edit btn}
	Дочекатись закінчення загрузки сторінки
	${decisionDate is}  Get Element Attribute  ${edit_locators['decisions'][0]['decisionDate']}  value
	Should Be Equal  ${decisionDate is}  ${data['decisions'][0]['decisionDate'][:-3]}  Oops! decisionDate на сторінці редагування змінилася


*** Keywords ***
Precondition
    ${tender_owner}  Set Variable If
    ...  '${where}' == 'test'  ssp_tender_owner
    ...  'prod' in '${where}'  prod_ssp_owner
   	Set Global Variable  ${tender_owner}  ${tender_owner}
    Додати першого користувача  ${tender_owner}