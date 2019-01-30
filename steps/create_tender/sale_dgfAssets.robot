*** Settings ***
Library  ../../src/pages/sale/DGF/dgfAssets/dgfAssets_variables.py


*** Keywords ***
Створити тендер
	[Arguments]  ${auction_type}
	Відкрити сторінку Аукціони ФГВ(test)
	actions.Натиснути додати(F7)  Додавання. Тендери

	create_tender.Вибрати тип процедури  ${auction_type}

	sale_dgfAssets.Заповнити "День старту електроного аукціону"
	sale_dgfAssets.Заповнити "Рішення дирекції/комітету"
	sale_dgfAssets.Заповнити "Початкова ціна реалізації лоту"
	sale_dgfAssets.Заповнити "Предмет продажу"
	sale_dgfAssets.Заповнити "Позиції аукціону"
	sale_dgfAssets.Заповнити "Гарантійний внесок"

	create_tender.Зберегти чернетку
	actions.Оголосити тендер
	sale_keywords.Отримати та зберегти tender_id
	Зберегти словник у файл  ${data}  data


Завантажити локатори
	${edit_locators}  dgfAssets_variables.get_edit_locators
	${view_locators}  dgfAssets_variables.get_view_locators
	${data}  dgfAssets_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}
#########################################################
#	                  Keywords							#
#########################################################
Заповнити "День старту електроного аукціону"
	${startDate}  get_time_now_with_deviation  20  minutes
	dgfAssets.Заповнити auctionPeriod.startDate  ${startDate}
    Set To Dictionary  ${data}  date  ${startDate}


Заповнити "Рішення дирекції/комітету"
	sale_dgfAssets.Заповнити "Номер рішення"
	sale_dgfAssets.Заповнити "Дату рішення"


Заповнити "Номер рішення"
	${id_f}  random_number  1000  9999
	${id_l}  random_number  0  9
	${dgfDecisionID}  Set Variable  ${id_f}/${id_l}
	dgfAssets.Заповнити dgfDecisionID  ${dgfDecisionID}
	Set To Dictionary  ${data}  dgfDecisionID  ${dgfDecisionID}


Заповнити "Дату рішення"
	${dgfDecisionDate}  smart_get_time  0  d
	dgfAssets.Заповнити dgfDecisionDate  ${dgfDecisionDate}
	Set To Dictionary  ${data}  dgfDecisionDate  ${dgfDecisionDate}


Заповнити "Початкова ціна реалізації лоту"
	sale_dgfAssets.Заповнити "Ціна"
	sale_dgfAssets.Заповнити "Мінімальний крок аукціону"


Заповнити "Ціна"
	${amount}  random_number  100000  100000000
	dgfAssets.Заповнити value.amount  ${amount}
	Set To Dictionary  ${data['value']}  amount  ${amount}


Заповнити "Мінімальний крок аукціону"
	${minimal_step_percent}  random_number  1  5
	dgfAssets.Заповнити minimalStep.amount  ${minimal_step_percent}
	${minimal_step}  Evaluate  float(${data['value']['amount']})*${minimal_step_percent}/100
	Set To Dictionary  ${data['minimalStep']}  amount  ${minimal_step}


Заповнити "Предмет продажу"
	sale_dgfAssets.Заповнити "Загальна назва аукціону"
	sale_dgfAssets.Заповнити "Номер лоту в ФГВ"
	sale_dgfAssets.Заповнити "Детальний опис"


Заповнити "Загальна назва аукціону"
	${title}  create_sentence  5
	dgfAssets.Заповнити title  ${title}
	Set To Dictionary  ${data}  title  [ТЕСТУВАННЯ] ${title}


Заповнити "Номер лоту в ФГВ"
	${first}  random_number  10000000  99999999
	${second}  random_number  10000  99999
	${dgfID}  Set Variable  F${first}-${second}
	dgfAssets.Заповнити dgfID  ${dgfID}
	Set To Dictionary  ${data}  dgfID  ${dgfID}


Заповнити "Детальний опис"
	${description}  create_sentence  20
	dgfAssets.Заповнити description  ${description}
	Set To Dictionary  ${data}  description  ${description}


Заповнити "Позиції аукціону"
	sale_dgfAssets.Заповнити "Опис активу"
	sale_dgfAssets.Заповнити "Кількість активів"
	sale_dgfAssets.Заповнити "Од. вим."
	sale_dgfAssets.Заповнити "Класифікація"
	sale_dgfAssets.Заповнити "Розташування об'єкту"


Заповнити "Опис активу"
	${description}  create_sentence  3
	dgfAssets.Заповнити items.0.description  ${description}
	Set To Dictionary  ${data['items'][0]}  description  ${description}


Заповнити "Кількість активів"
	${quantity}  random_number  1  1000
	dgfAssets.Заповнити items.0.quantity  ${quantity}
	Set To Dictionary  ${data['items'][0]}  quantity  ${quantity}


Заповнити "Од. вим."
	${name}  dgfAssets.Заповнити items.0.unit.name
	Set To Dictionary  ${data['items'][0]['unit']}  name  ${name}


Заповнити "Класифікація"
	${classification}  dgfAssets.Заповнити items.0.classification
	${scheme}  Set Variable  CAV
	Set To Dictionary  ${data['items'][0]['classification']}  scheme  ${scheme}
	Set To Dictionary  ${data['items'][0]['classification']}  id  ${classification[0]}
	Set To Dictionary  ${data['items'][0]['classification']}  description  ${classification[1]}



Заповнити "Розташування об'єкту"
	sale_dgfAssets.Заповнити "Індекс"
	sale_dgfAssets.Заповнити "Вулиця"
	sale_dgfAssets.Заповнити "Місто"


Заповнити "Індекс"
	${postalCode}  random_number  10000  99999
	dgfAssets.Заповнити items.0.address.postalCode  ${postalCode}
	Set To Dictionary  ${data['items'][0]['address']}  postalCode  ${postalCode}


Заповнити "Вулиця"
	${text}  create_sentence  1
	${streetAddress}  Set Variable  ${text[:-1]}
	dgfAssets.Заповнити items.0.address.streetAddress  ${streetAddress}
	Set To Dictionary  ${data['items'][0]['address']}  streetAddress  ${streetAddress}


Заповнити "Місто"
	${input}  Set Variable  //*[@id='pcModalMode_PW-1']//span[contains(text(), 'Місто')]/following-sibling::*//input
	${locality}  ${region}  ${countryName}  dgfAssets.Заповнити items.0.address.locality
	Set To Dictionary  ${data['items'][0]['address']}  locality  ${locality}
	Set To Dictionary  ${data['items'][0]['address']}  region  ${region}
	Set To Dictionary  ${data['items'][0]['address']}  countryName  ${countryName}


Заповнити "Гарантійний внесок"
	${guarantee_amount_percent}  random_number  1  5
	${amount}  Evaluate  float(${data['value']['amount']})*${guarantee_amount_percent}/100
	Set To Dictionary  ${data['guarantee']}  amount  ${amount}
	Відкрити вкладку Гарантійний внесок
	dgfAssets.Заповнити guarantee.amount  ${guarantee_amount_percent}
	Відкрити вкладку Тестовий аукціон
