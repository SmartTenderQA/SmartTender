*** Keywords ***
Створити тендер
	[Arguments]  ${auction_type}
	Відкрити сторінку Аукціони ФГВ(test)
	Відкрити вікно створення тендеру
	create_tender.Вибрати тип процедури  ${auction_type}
	cdb1_sale_property.Заповнити value.amount
	cdb1_sale_property.Заповнити minimalStep.percent
	cdb1_sale_property.Заповнити dgfDecisionID
	cdb1_sale_property.Заповнити dgfDecisionDate

	cdb1_sale_property.Заповнити title
	cdb1_sale_property.Заповнити dgfID
	cdb1_sale_property.Заповнити description

	cdb1_sale_property.Заповнити items.title
	cdb1_sale_property.Заповнити items.quantity
	cdb1_sale_property.Заповнити items.unit.name
	cdb1_sale_property.Заповнити items.classification.description
	cdb1_sale_property.Заповнити items.postalcode
	cdb1_sale_property.Заповнити items.strretaddress
	cdb1_sale_property.Заповнити items.locality

	cdb1_sale_property.Заповнити guarantee.amount

	cdb1_sale_property.Заповнити auctionPeriod.startDate

	Зберегти чернетку
	Оголосити тендер
	Отримати та зберегти tender_id
	Зберегти словник у файл  ${data}  data


#########################################################
#	                  Keywords							#
#########################################################
Заповнити auctionPeriod.startDate
	${startDate}  get_time_now_with_deviation  8  minutes
    Wait Until Keyword Succeeds  30  3  Заповнити та перевірити поле с датою  День старту  ${startDate}
    ${auctionPeriods}  Create Dictionary  startDate=${startDate}
    Set To Dictionary  ${data}  auctionPeriods  ${auctionPeriods}


Заповнити value.amount
	${amount}  random_number  100000  100000000
	${selector}  Set Variable  xpath=//*[contains(text(), 'Ціна')]/following-sibling::table//input
	Заповнити текстове поле  ${selector}  ${amount}
	${value}  Create Dictionary  amount=${amount}
	Set To Dictionary  ${data}  value  ${value}


Заповнити minimalStep.percent
	${minimal_step_percent}  random_number  1  5
	Wait Until Keyword Succeeds  120  3  Заповнити та перевірити мінімальний крок аукціону  ${minimal_step_percent}
	Set To Dictionary  ${data.value}  minimalStep_ percent  ${minimal_step_percent}


Заповнити dgfDecisionID
	${id_f}  random_number  1000  9999
	${id_l}  random_number  0  9
	${id}  Set Variable  ${id_f}/${id_l}
	${selector}  Set Variable  xpath=//*[contains(text(), 'Номер')]/following-sibling::table//input
	Заповнити текстове поле  ${selector}  ${id}
	Set To Dictionary  ${data}  dgfDecisionID=${id}


Заповнити dgfDecisionDate
	${time}  smart_get_time  0  d
	Wait Until Keyword Succeeds  120  3  Заповнити та перевірити дату Рішення Дирекції  ${time}
	Set To Dictionary  ${data}  dgfDecisionDate=${time}


Заповнити title
	${text}  create_sentence  5
	${title}  Set Variable  [ТЕСТУВАННЯ] ${text}
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Загальна назва')]/following-sibling::table//input
	Заповнити текстове поле  ${selector}  ${title}
	Set To Dictionary  ${data}  title=${title}


Заповнити dgfID
	${first}  random_number  10000000  99999999
	${second}  random_number  10000  99999
	${dgfID}  Set Variable  F${first}-${second}
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Номер лоту')]/following-sibling::table//input
	Заповнити текстове поле  ${selector}  ${dgfID}
	Set To Dictionary  ${data}  dgfID=${dgfID}


Заповнити description
	${description}  create_sentence  20
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Детальний опис')]/following-sibling::table//textarea
	Заповнити текстове поле  ${selector}  ${description}
	Set To Dictionary  ${data}  description=${description}


Заповнити items.title
	${title}  create_sentence  3
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Опис активу')]/following-sibling::*//input
	Заповнити текстове поле  ${selector}  ${title}
	${dict}  Create Dictionary  title=${title}
	Set To Dictionary  ${data}  items  ${dict}


Заповнити items.quantity
	${quantity}  random_number  1  1000
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Кількість активів')]/following-sibling::*//input
	Заповнити текстове поле  ${selector}  ${quantity}
	Set To Dictionary  ${data['items']}  quantity  ${quantity}


Заповнити items.unit.name
	${input}  Set Variable  //*[@id='pcModalMode_PW-1']//span[contains(text(), 'Од. вим.')]/following-sibling::*//input
	${selector}  Set Variable  //*[contains(text(), 'ОВ. Найменування')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
	${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
	Set To Dictionary  ${data['items']}  unit_name  ${name}


Заповнити items.classification.description
	${input}  Set Variable  (//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Класифікація')]/following-sibling::div)[2]//input
	${selector}  Set Variable  //*[contains(text(), 'Код класифікації')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
	${description}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
	Set To Dictionary  ${data['items']}  classification_description  ${description}


Заповнити items.postalcode
	${postalcode}  random_number  10000  99999
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Індекс')]/following-sibling::table//input
	Заповнити текстове поле  ${selector}  ${postalcode}
	Set To Dictionary  ${data['items']}  postalcode  ${postalcode}


Заповнити items.strretaddress
	${text}  create_sentence  1
	${strretaddress}  Set Variable  ${text[:-1]}
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Вулиця')]/following-sibling::table//input
	Заповнити текстове поле  ${selector}  ${strretaddress}
	Set To Dictionary  ${data['items']}  strretaddress  ${strretaddress}


Заповнити items.locality
	${input}  Set Variable  //*[@id='pcModalMode_PW-1']//span[contains(text(), 'Місто')]/following-sibling::*//input
	${selector}  Set Variable  //*[contains(text(), 'Місто')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
	${locality}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
	Set To Dictionary  ${data['items']}  locality  ${locality}


Заповнити guarantee.amount
	${guarantee_amount_percent}  random_number  1  5
	${value}  Create Dictionary  percent=${guarantee_amount_percent}
	Set To Dictionary  ${data.value}  guarantee=${value}
	Відкрити вкладку Гарантійний внесок
	Wait Until Keyword Succeeds  120  3  Заповнити та перевірити гарантійний внесок  ${guarantee_amount_percent}
	Відкрити вкладку Тестовий аукціон