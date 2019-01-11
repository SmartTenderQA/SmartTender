*** Keywords ***
Створити аукціон
	Run Keyword  Відкрити сторінку Аукціони ФГВ(${site})
	Відкрити вікно створення тендеру

	create_tender.Вибрати тип процедури  Голландський аукціон

	dutch_step.Заповнити "День старту електроного аукціону"
	dutch_step.Заповнити "Рішення дирекції/комітету"
	dutch_step.Заповнити "Початкова ціна реалізації лоту"
	Run Keyword If  '${site}' == 'prod'
	...  dutch_step.Заповнити "Контактна особа"
	dutch_step.Заповнити "Предмет продажу"
	dutch_step.Заповнити "Позиції аукціону"
	dutch_step.Заповнити "Гарантійний внесок"

	create_tender.Зберегти чернетку
	actions.Оголосити тендер
	sale_keywords.Отримати та зберегти tender_id
	Зберегти словник у файл  ${data}  data



#########################################################
#	                  Keywords							#
#########################################################
Заповнити "День старту електроного аукціону"
	${date}  get_formated_time_with_delta  5  days  m
	${formated date}  Run Keyword If  "${site}" == "prod"  convert_data_for_web_client  ${date}
	...  ELSE IF  "${site}" == "test"  Set Variable  ${date}
	dutch.Заповнити auctionPeriod.startDate  ${formated date}
    Set To Dictionary  ${data}  date  ${date}


Заповнити "Рішення дирекції/комітету"
	dutch_step.Заповнити "Номер рішення"
	dutch_step.Заповнити "Дату рішення"


Заповнити "Номер рішення"
	${id_f}  random_number  1000  9999
	${id_l}  random_number  0  9
	${dgfDecisionID}  Set Variable  ${id_f}/${id_l}
	dutch.Заповнити dgfDecisionID  ${dgfDecisionID}
	Set To Dictionary  ${data}  dgfDecisionID  ${dgfDecisionID}


Заповнити "Дату рішення"
	${dgfDecisionDate}  smart_get_time  0  d
	${formated date}  Run Keyword If  "${site}" == "prod"  convert_data_for_web_client  ${dgfDecisionDate}
	...  ELSE IF  "${site}" == "test"  Set Variable  ${dgfDecisionDate}
	dutch.Заповнити dgfDecisionDate  ${formated date}
	Set To Dictionary  ${data}  dgfDecisionDate  ${formated date}


Заповнити "Початкова ціна реалізації лоту"
	dutch_step.Заповнити "Ціна"
	dutch_step.Заповнити "Мінімальний крок аукціону"


Заповнити "Ціна"
	${amount}  random_number  100000  100000000
	dutch.Заповнити value.amount  ${amount}
	Set To Dictionary  ${data['value']}  amount  ${amount}


Заповнити "Мінімальний крок аукціону"
	${minimal_step_percent}  random_number  1  5
	dutch.Заповнити minimalStep.amount  ${minimal_step_percent}
	${minimal_step}  Evaluate  float(${data['value']['amount']})*${minimal_step_percent}/100
	Set To Dictionary  ${data['minimalStep']}  amount  ${minimal_step}


Заповнити "Контактна особа"
	${name}  dutch.Заповнити procuringEntity.contactPoint.name
	Set To Dictionary  ${data['procuringEntity']['contactPoint']}  name  ${name}


Заповнити "Предмет продажу"
	dutch_step.Заповнити "Загальна назва аукціону"
	dutch_step.Заповнити "Номер лоту в ФГВ"
	dutch_step.Заповнити "Детальний опис"


Заповнити "Загальна назва аукціону"
	${title}  create_sentence  5
	dutch.Заповнити title  [ТЕСТУВАННЯ] ${title}
	Set To Dictionary  ${data}  title  [ТЕСТУВАННЯ] ${title}


Заповнити "Номер лоту в ФГВ"
	${first}  random_number  10000000  99999999
	${second}  random_number  10000  99999
	${dgfID}  Set Variable  F${first}-${second}
	dutch.Заповнити dgfID  ${dgfID}
	Set To Dictionary  ${data}  dgfID  ${dgfID}


Заповнити "Детальний опис"
	${description}  create_sentence  20
	dutch.Заповнити description  ${description}
	Set To Dictionary  ${data}  description  ${description}


Заповнити "Позиції аукціону"
	dutch_step.Заповнити "Опис активу"
	dutch_step.Заповнити "Кількість активів"
	dutch_step.Заповнити "Од. вим."
	dutch_step.Заповнити "Класифікація"
	dutch_step.Заповнити "Розташування об'єкту"


Заповнити "Опис активу"
	${description}  create_sentence  3
	dutch.Заповнити items.0.description  ${description}
	Set To Dictionary  ${data['items'][0]}  description  ${description}


Заповнити "Кількість активів"
	${quantity}  random_number  1  1000
	dutch.Заповнити items.0.quantity  ${quantity}
	Set To Dictionary  ${data['items'][0]}  quantity  ${quantity}


Заповнити "Од. вим."
	${name}  dutch.Заповнити items.0.unit.name
	Set To Dictionary  ${data['items'][0]['unit']}  name  ${name}


Заповнити "Класифікація"
	${classification}  dutch.Заповнити items.0.classification
	${scheme}  Set Variable  CAV
	Set To Dictionary  ${data['items'][0]['classification']}  scheme  ${scheme}
	Set To Dictionary  ${data['items'][0]['classification']}  id  ${classification[0]}
	Set To Dictionary  ${data['items'][0]['classification']}  description  ${classification[1]}


Заповнити "Розташування об'єкту"
	dutch_step.Заповнити "Індекс"
	dutch_step.Заповнити "Вулиця"
	dutch_step.Заповнити "Місто"


Заповнити "Індекс"
	${postalCode}  random_number  10000  99999
	dutch.Заповнити items.0.address.postalCode  ${postalCode}
	Set To Dictionary  ${data['items'][0]['address']}  postalCode  ${postalCode}


Заповнити "Вулиця"
	${text}  create_sentence  1
	${streetAddress}  Set Variable  ${text[:-1]}
	dutch.Заповнити items.0.address.streetAddress  ${streetAddress}
	Set To Dictionary  ${data['items'][0]['address']}  streetAddress  ${streetAddress}


Заповнити "Місто"
	${input}  Set Variable  //*[@id='pcModalMode_PW-1']//span[contains(text(), 'Місто')]/following-sibling::*//input
	${locality}  ${region}  ${countryName}  dutch.Заповнити items.0.address.locality
	Set To Dictionary  ${data['items'][0]['address']}  locality  ${locality}
	Set To Dictionary  ${data['items'][0]['address']}  region  ${region}
	Set To Dictionary  ${data['items'][0]['address']}  countryName  ${countryName}


Заповнити "Гарантійний внесок"
	${guarantee_amount_percent}  random_number  1  5
	${amount}  Evaluate  float(${data['value']['amount']})*${guarantee_amount_percent}/100
	Set To Dictionary  ${data['guarantee']}  amount  ${amount}
	Відкрити вкладку Гарантійний внесок
	dutch.Заповнити guarantee.amount  ${guarantee_amount_percent}
	Відкрити вкладку Тестовий аукціон