*** Settings ***
Library  ../../src/pages/sale/SPF/propertyLease/propertyLease_variables.py

*** Keywords ***
Створити аукціон
	Відкрити сторінку Продаж/Оренда майна(тестові)
	actions.Натиснути додати(F7)  Додавання. Тендери
	create_tender.Вибрати тип процедури  Оренда майна
	cdb2_PropertyLease.Заповнити "День старту електроного аукціону"
	cdb2_PropertyLease.Заповнити "Початкова ціна реалізації лоту"
	cdb2_PropertyLease.Заповнити "Предмет продажу"
	cdb2_PropertyLease.Заповнити "Позиції аукціону"
#    PropertyLease.Очистити поле "Прийом пропозицій по"
	cdb2_PropertyLease.Заповнити "Гарантійний внесок"
    cdb2_PropertyLease.Заповнити "Умови договору аренди"

	create_tender.Зберегти чернетку
	actions.Оголосити тендер
	sale_keywords.Отримати та зберегти tender_id
	Зберегти словник у файл  ${data}  data



Завантажити локатори
	${edit_locators}  propertyLease_variables.get_edit_locators
	${view_locators}  propertyLease_variables.get_view_locators
	${data}  propertyLease_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}


#########################################################
#	                  Keywords							#
#########################################################
Заповнити "День старту електроного аукціону"
	${startDate}  get_time_now_with_deviation  18  minutes
	propertyLease.Заповнити auctionPeriod.startDate  ${startDate}
    Set To Dictionary  ${data}  date  ${startDate}


Заповнити "Початкова ціна реалізації лоту"
	cdb2_PropertyLease.Заповнити "Ціна"
	cdb2_PropertyLease.Заповнити "Мінімальний крок аукціону"


Заповнити "Ціна"
	${amount}  random_number  100000  100000000
	propertyLease.Заповнити value.amount  ${amount}
	Set To Dictionary  ${data['value']}  amount  ${amount}


Заповнити "Мінімальний крок аукціону"
	${minimal_step_percent}  random_number  1  5
	propertyLease.Заповнити minimalStep.amount  ${minimal_step_percent}
	${minimal_step}  Evaluate  float(${data['value']['amount']})*${minimal_step_percent}/100
	Set To Dictionary  ${data['minimalStep']}  amount  ${minimal_step}


Заповнити "Предмет продажу"
	cdb2_PropertyLease.Заповнити "Загальна назва аукціону"
	cdb2_PropertyLease.Заповнити "Номер лоту в замовника"
	cdb2_PropertyLease.Заповнити "Детальний опис"


Заповнити "Загальна назва аукціону"
	${title}  create_sentence  5
	propertyLease.Заповнити title  ${title}
	Set To Dictionary  ${data}  title  [ТЕСТУВАННЯ] ${title}


Заповнити "Номер лоту в замовника"
	${first}  random_number  10000000  99999999
	${second}  random_number  10000  99999
	${lotIdentifier}  Set Variable  F${first}-${second}
	propertyLease.Заповнити lotIdentifier  ${lotIdentifier}
	Set To Dictionary  ${data}  lotIdentifier  ${lotIdentifier}


Заповнити "Детальний опис"
	${description}  create_sentence  20
	propertyLease.Заповнити description  ${description}
	Set To Dictionary  ${data}  description  ${description}


Заповнити "Позиції аукціону"
	cdb2_PropertyLease.Заповнити "Найменування позиції"
	cdb2_PropertyLease.Заповнити "Кількість активів"
	cdb2_PropertyLease.Заповнити "Од. вим."
	cdb2_PropertyLease.Заповнити "Класифікація"
	cdb2_PropertyLease.Заповнити "Розташування об'єкту"


Заповнити "Найменування позиції"
	${description}  create_sentence  3
	propertyLease.Заповнити items.0.description  ${description}
	Set To Dictionary  ${data['items'][0]}  description  ${description}


Заповнити "Кількість активів"
	${quantity}  random_number  1  1000
	propertyLease.Заповнити items.0.quantity  ${quantity}
	Set To Dictionary  ${data['items'][0]}  quantity  ${quantity}


Заповнити "Од. вим."
	${name}  propertyLease.Заповнити items.0.unit.name
	Set To Dictionary  ${data['items'][0]['unit']}  name  ${name}


Заповнити "Класифікація"
	${classification}  propertyLease.Заповнити items.0.classification
	${scheme}  Set Variable  CPV
	Set To Dictionary  ${data['items'][0]['classification']}  scheme  ${scheme}
	Set To Dictionary  ${data['items'][0]['classification']}  id  ${classification[0]}
	Set To Dictionary  ${data['items'][0]['classification']}  description  ${classification[1]}


Заповнити "Розташування об'єкту"
	cdb2_PropertyLease.Заповнити "Індекс"
	cdb2_PropertyLease.Заповнити "Вулиця"
	cdb2_PropertyLease.Заповнити "Місто"


Заповнити "Індекс"
	${postalCode}  random_number  10000  99999
	propertyLease.Заповнити items.0.address.postalCode  ${postalCode}
	Set To Dictionary  ${data['items'][0]['address']}  postalCode  ${postalCode}


Заповнити "Вулиця"
	${text}  create_sentence  1
	${streetAddress}  Set Variable  ${text[:-1]}
	propertyLease.Заповнити items.0.address.streetAddress  ${streetAddress}
	Set To Dictionary  ${data['items'][0]['address']}  streetAddress  ${streetAddress}


Заповнити "Місто"
	${input}  Set Variable  //*[@id='pcModalMode_PW-1']//span[contains(text(), 'Місто')]/following-sibling::*//input
	${locality}  ${region}  ${countryName}  propertyLease.Заповнити items.0.address.locality
	Set To Dictionary  ${data['items'][0]['address']}  locality  ${locality}
	Set To Dictionary  ${data['items'][0]['address']}  region  ${region}
	Set To Dictionary  ${data['items'][0]['address']}  countryName  ${countryName}


Заповнити "Гарантійний внесок"
	${guarantee_amount_percent}  random_number  1  5
	${amount}  Evaluate  float(${data['value']['amount']})*${guarantee_amount_percent}/100
	Set To Dictionary  ${data['guarantee']}  amount  ${amount}
	Відкрити вкладку Гарантійний внесок
	propertyLease.Заповнити guarantee.amount  ${guarantee_amount_percent}


Заповнити "Умови договору аренди"
    ${leaseDuration}  random_number  1  20
    Відкрити вкладку Умови договору аренди
    propertyLease.Заповнити contractTerms.leaseTerms.leaseDuration  ${leaseDuration}
    ${leaseDuration}  Evaluate  'P'+'${leaseDuration}'+'M'
    Set To Dictionary  ${data['contractTerms']['leaseTerms']}  leaseDuration  ${leaseDuration}
    Відкрити вкладку Тестовий аукціон
