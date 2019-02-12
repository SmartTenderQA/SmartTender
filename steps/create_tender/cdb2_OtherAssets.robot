*** Settings ***
Library  ../../src/pages/sale/SPF/otherAssets/otherAssets_variables.py


*** Keywords ***
Створити аукціон
	Run Keyword If  '${site}' == 'prod'
	...  desktop.Змінити групу  Організатор. Реализация державного майна (E_ORGSPA)
	Відкрити сторінку Продаж/Оренда майна(тестові)
	Відкрити вікно створення тендеру
	create_tender.Вибрати тип процедури  Продаж майна

	Run Keyword  cdb2_OtherAssets.Заповнити "День старту електроного аукціону" ${site}
	cdb2_OtherAssets.Заповнити "Початкова ціна реалізації лоту"
	Run Keyword If  '${site}' == 'prod'
	...  cdb2_OtherAssets.Заповнити "Контактна особа"
	cdb2_OtherAssets.Заповнити "Предмет продажу"
	cdb2_OtherAssets.Заповнити "Позиції аукціону"
	cdb2_OtherAssets.Заповнити "Гарантійний внесок"

	create_tender.Зберегти чернетку
	actions.Оголосити тендер
	sale_keywords.Отримати та зберегти tender_id
	Зберегти словник у файл  ${data}  data


Завантажити локатори
	${edit_locators}  otherAssets_variables.get_edit_locators
	${view_locators}  otherAssets_variables.get_view_locators
	${data}  otherAssets_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}


#########################################################
#	                  Keywords							#
#########################################################
Заповнити "День старту електроного аукціону" test
	${startDate}  get_formated_time_with_delta  18  minutes  m
	otherAssets.Заповнити auctionPeriod.startDate  ${startDate}
    Set To Dictionary  ${data}  date  ${startDate}


Заповнити "День старту електроного аукціону" prod
	${startDate}  get_formated_time_with_delta  5  days  m
	otherAssets.Заповнити auctionPeriod.startDate  ${startDate}
    Set To Dictionary  ${data}  date  ${startDate}


Заповнити "Початкова ціна реалізації лоту"
	cdb2_OtherAssets.Заповнити "Ціна"
	cdb2_OtherAssets.Заповнити "Мінімальний крок аукціону"


Заповнити "Ціна"
	${amount}  random_number  100000  100000000
	otherAssets.Заповнити value.amount  ${amount}
	Set To Dictionary  ${data['value']}  amount  ${amount}


Заповнити "Мінімальний крок аукціону"
	${minimal_step_percent}  random_number  1  5
	otherAssets.Заповнити minimalStep.amount  ${minimal_step_percent}
	${minimal_step}  Evaluate  float(${data['value']['amount']})*${minimal_step_percent}/100
	Set To Dictionary  ${data['minimalStep']}  amount  ${minimal_step}


Заповнити "Контактна особа"
    ${name}  Set Variable  Прохоров И.А.
    tender_tab.Заповнити "Контактна особа"  ${name}
	Set To Dictionary  ${data['procuringEntity']['contactPoint']}  name  ${name}


Заповнити "Предмет продажу"
	cdb2_OtherAssets.Заповнити "Загальна назва аукціону"
	cdb2_OtherAssets.Заповнити "Номер лоту в замовника"
	cdb2_OtherAssets.Заповнити "Детальний опис"


Заповнити "Загальна назва аукціону"
	${title}  create_sentence  5
	otherAssets.Заповнити title  [ТЕСТУВАННЯ] ${title}
	Set To Dictionary  ${data}  title  [ТЕСТУВАННЯ] ${title}


Заповнити "Номер лоту в замовника"
	${first}  random_number  10000000  99999999
	${second}  random_number  10000  99999
	${dgfID}  Set Variable  F${first}-${second}
	otherAssets.Заповнити dgfID  ${dgfID}
	Set To Dictionary  ${data}  dgfID  ${dgfID}


Заповнити "Детальний опис"
	${description}  create_sentence  20
	otherAssets.Заповнити description  ${description}
	Set To Dictionary  ${data}  description  ${description}


Заповнити "Позиції аукціону"
	cdb2_OtherAssets.Заповнити "Найменування позиції"
	cdb2_OtherAssets.Заповнити "Кількість активів"
	cdb2_OtherAssets.Заповнити "Од. вим."
	cdb2_OtherAssets.Заповнити "Класифікація"
	cdb2_OtherAssets.Заповнити "Розташування об'єкту"


Заповнити "Найменування позиції"
	${description}  create_sentence  3
	otherAssets.Заповнити items.0.description  ${description}
	Set To Dictionary  ${data['items'][0]}  description  ${description}


Заповнити "Кількість активів"
	${quantity}  random_number  1  1000
	otherAssets.Заповнити items.0.quantity  ${quantity}
	Set To Dictionary  ${data['items'][0]}  quantity  ${quantity}


Заповнити "Од. вим."
	${name}  otherAssets.Заповнити items.0.unit.name
	Set To Dictionary  ${data['items'][0]['unit']}  name  ${name}


Заповнити "Класифікація"
	${classification}  otherAssets.Заповнити items.0.classification
	${scheme}  Set Variable  CPV
	Set To Dictionary  ${data['items'][0]['classification']}  scheme  ${scheme}
	Set To Dictionary  ${data['items'][0]['classification']}  id  ${classification[0]}
	Set To Dictionary  ${data['items'][0]['classification']}  description  ${classification[1]}


Заповнити "Розташування об'єкту"
	cdb2_OtherAssets.Заповнити "Індекс"
	cdb2_OtherAssets.Заповнити "Вулиця"
	cdb2_OtherAssets.Заповнити "Місто"


Заповнити "Індекс"
	${postalCode}  random_number  10000  99999
	otherAssets.Заповнити items.0.address.postalCode  ${postalCode}
	Set To Dictionary  ${data['items'][0]['address']}  postalCode  ${postalCode}


Заповнити "Вулиця"
	${text}  create_sentence  1
	${streetAddress}  Set Variable  ${text[:-1]}
	otherAssets.Заповнити items.0.address.streetAddress  ${streetAddress}
	Set To Dictionary  ${data['items'][0]['address']}  streetAddress  ${streetAddress}


Заповнити "Місто"
	${input}  Set Variable  //*[@id='pcModalMode_PW-1']//span[contains(text(), 'Місто')]/following-sibling::*//input
	${locality}  ${region}  ${countryName}  otherAssets.Заповнити items.0.address.locality
	Set To Dictionary  ${data['items'][0]['address']}  locality  ${locality}
	Set To Dictionary  ${data['items'][0]['address']}  region  ${region}
	Set To Dictionary  ${data['items'][0]['address']}  countryName  ${countryName}


Заповнити "Гарантійний внесок"
	${guarantee_amount_percent}  random_number  1  5
	${amount}  Evaluate  float(${data['value']['amount']})*${guarantee_amount_percent}/100
	Set To Dictionary  ${data['guarantee']}  amount  ${amount}
	Відкрити вкладку Гарантійний внесок
	otherAssets.Заповнити guarantee.amount  ${guarantee_amount_percent}
	Відкрити вкладку Тестовий аукціон
