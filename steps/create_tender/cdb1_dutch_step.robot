*** Settings ***
Library  ../../src/pages/sale/DGF/cdb1_dutch_page/cdb1_dutch_variables.py


*** Keywords ***
Створити аукціон
	cdb1_dutch_step.Завантажити локатори

	Run Keyword  Відкрити сторінку Аукціони ФГВ(${site})
	Відкрити вікно створення тендеру

	create_tender.Вибрати тип процедури  Голландський аукціон

	cdb1_dutch_step.Заповнити "День старту електроного аукціону"
	cdb1_dutch_step.Заповнити "Рішення дирекції/комітету"
	cdb1_dutch_step.Заповнити "Початкова ціна реалізації лоту"
	Run Keyword If  '${site}' == 'prod'
	...  cdb1_dutch_step.Заповнити "Контактна особа"
	cdb1_dutch_step.Заповнити "Предмет продажу"
	cdb1_dutch_step.Заповнити "Позиції аукціону"
	cdb1_dutch_step.Заповнити "Гарантійний внесок"

	create_tender.Зберегти чернетку
	actions.Оголосити тендер
	sale_keywords.Отримати та зберегти tender_id
	Зберегти словник у файл  ${data}  data


Завантажити локатори
	${edit_locators}  cdb1_dutch_variables.get_edit_locators
	${view_locators}  cdb1_dutch_variables.get_view_locators
	${data}  cdb1_dutch_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}


#########################################################
#	                  Keywords							#
#########################################################
Заповнити "День старту електроного аукціону"
	${date}  get_formated_time_with_delta  5  days  m
	cdb1_dutch_page.Заповнити auctionPeriod.startDate  ${date}
    Set To Dictionary  ${data}  date  ${date}


Заповнити "Рішення дирекції/комітету"
	cdb1_dutch_step.Заповнити "Номер рішення"
	cdb1_dutch_step.Заповнити "Дату рішення"


Заповнити "Номер рішення"
	${id_f}  random_number  1000  9999
	${id_l}  random_number  0  9
	${dgfDecisionID}  Set Variable  ${id_f}/${id_l}
	cdb1_dutch_page.Заповнити dgfDecisionID  ${dgfDecisionID}
	Set To Dictionary  ${data}  dgfDecisionID  ${dgfDecisionID}


Заповнити "Дату рішення"
	${dgfDecisionDate}  smart_get_time  0  d
	cdb1_dutch_page.Заповнити dgfDecisionDate  ${dgfDecisionDate}
	Set To Dictionary  ${data}  dgfDecisionDate  ${dgfDecisionDate}


Заповнити "Початкова ціна реалізації лоту"
	cdb1_dutch_step.Заповнити "Ціна"
	cdb1_dutch_step.Заповнити "Мінімальний крок аукціону"


Заповнити "Ціна"
	${amount}  random_number  100000  100000000
	cdb1_dutch_page.Заповнити value.amount  ${amount}
	Set To Dictionary  ${data['value']}  amount  ${amount}


Заповнити "Мінімальний крок аукціону"
	${minimal_step_percent}  random_number  1  5
	cdb1_dutch_page.Заповнити minimalStep.amount  ${minimal_step_percent}
	${minimal_step}  Evaluate  float(${data['value']['amount']})*${minimal_step_percent}/100
	Set To Dictionary  ${data['minimalStep']}  amount  ${minimal_step}


Заповнити "Контактна особа"
    ${name}  Set Variable  Прохоров И.А.
    tender_tab.Заповнити "Контактна особа"  ${name}
	Set To Dictionary  ${data['procuringEntity']['contactPoint']}  name  ${name}


Заповнити "Предмет продажу"
	cdb1_dutch_step.Заповнити "Загальна назва аукціону"
	cdb1_dutch_step.Заповнити "Номер лоту в ФГВ"
	cdb1_dutch_step.Заповнити "Детальний опис"


Заповнити "Загальна назва аукціону"
	${title}  create_sentence  5
	cdb1_dutch_page.Заповнити title  [ТЕСТУВАННЯ] ${title}
	Set To Dictionary  ${data}  title  [ТЕСТУВАННЯ] ${title}


Заповнити "Номер лоту в ФГВ"
	${first}  random_number  10000000  99999999
	${second}  random_number  10000  99999
	${dgfID}  Set Variable  F${first}-${second}
	cdb1_dutch_page.Заповнити dgfID  ${dgfID}
	Set To Dictionary  ${data}  dgfID  ${dgfID}


Заповнити "Детальний опис"
	${description}  create_sentence  20
	cdb1_dutch_page.Заповнити description  ${description}
	Set To Dictionary  ${data}  description  ${description}


Заповнити "Позиції аукціону"
	cdb1_dutch_step.Заповнити "Опис активу"
	cdb1_dutch_step.Заповнити "Кількість активів"
	cdb1_dutch_step.Заповнити "Од. вим."
	cdb1_dutch_step.Заповнити "Класифікація"
	cdb1_dutch_step.Заповнити "Розташування об'єкту"


Заповнити "Опис активу"
	${description}  create_sentence  3
	cdb1_dutch_page.Заповнити items.0.description  ${description}
	Set To Dictionary  ${data['items'][0]}  description  ${description}


Заповнити "Кількість активів"
	${quantity}  random_number  1  1000
	cdb1_dutch_page.Заповнити items.0.quantity  ${quantity}
	Set To Dictionary  ${data['items'][0]}  quantity  ${quantity}


Заповнити "Од. вим."
	${name}  cdb1_dutch_page.Заповнити items.0.unit.name
	Set To Dictionary  ${data['items'][0]['unit']}  name  ${name}


Заповнити "Класифікація"
	${classification}  cdb1_dutch_page.Заповнити items.0.classification
	${scheme}  Set Variable  CAV
	Set To Dictionary  ${data['items'][0]['classification']}  scheme  ${scheme}
	Set To Dictionary  ${data['items'][0]['classification']}  id  ${classification[0]}
	Set To Dictionary  ${data['items'][0]['classification']}  description  ${classification[1]}


Заповнити "Розташування об'єкту"
	cdb1_dutch_step.Заповнити "Індекс"
	cdb1_dutch_step.Заповнити "Вулиця"
	cdb1_dutch_step.Заповнити "Місто"


Заповнити "Індекс"
	${postalCode}  random_number  10000  99999
	cdb1_dutch_page.Заповнити items.0.address.postalCode  ${postalCode}
	Set To Dictionary  ${data['items'][0]['address']}  postalCode  ${postalCode}


Заповнити "Вулиця"
	${text}  create_sentence  1
	${streetAddress}  Set Variable  ${text[:-1]}
	cdb1_dutch_page.Заповнити items.0.address.streetAddress  ${streetAddress}
	Set To Dictionary  ${data['items'][0]['address']}  streetAddress  ${streetAddress}


Заповнити "Місто"
	${input}  Set Variable  //*[@id='pcModalMode_PW-1']//span[contains(text(), 'Місто')]/following-sibling::*//input
	${locality}  ${region}  ${countryName}  cdb1_dutch_page.Заповнити items.0.address.locality
	Set To Dictionary  ${data['items'][0]['address']}  locality  ${locality}
	Set To Dictionary  ${data['items'][0]['address']}  region  ${region}
	Set To Dictionary  ${data['items'][0]['address']}  countryName  ${countryName}


Заповнити "Гарантійний внесок"
	${guarantee_amount_percent}  random_number  1  5
	${amount}  Evaluate  float(${data['value']['amount']})*${guarantee_amount_percent}/100
	Set To Dictionary  ${data['guarantee']}  amount  ${amount}
	Відкрити вкладку Гарантійний внесок
	cdb1_dutch_page.Заповнити guarantee.amount  ${guarantee_amount_percent}
	Відкрити вкладку Тестовий аукціон