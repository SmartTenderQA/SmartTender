*** Settings ***
Library  ../../src/pages/sale/SPF/small_privatization/small_privatization_object/small_privatization_object_variables.py
Library  ../../src/pages/sale/SPF/small_privatization/small_privatization_informational_message/small_privatization_informational_message_variables.py


*** Keywords ***
Створити об'єкт МП
	start_page.Натиснути на іконку з баннеру  Комерційні тендери SmartTender
	old_search.Активувати вкладку ФГИ
	small_privatization_search.Активувати вкладку  Реєстр об'єктів приватизації
	small_privatization_search.Вибрати режим сторінки об'єктів приватизації  Кабінет
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	small_privatization_search.Натиснути створити  об'єкт
	small_privatization_step.Заповнити "Назву об'єкту приватизації"
	small_privatization_step.Заповнити "Опис об'єкту приватизації"
	small_privatization_step.Заповнити "Рішення про затвердження переліку об'єктів"
	small_privatization_step.Заповнити "Загальну інформацію про об'єкт"
	sale_keywords.Натиснути кнопку зберегти
	sale_keywords.Натиснути кнопку опублікувати


Завантажити локатори для об'єкта
	${edit_locators}  small_privatization_object_variables.get_edit_locators
	${view_locators}  small_privatization_object_variables.get_view_locators
	${data}  small_privatization_object_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}


Створити інформаційне повідомлення МП
	[Arguments]  ${id}
	start_page.Натиснути на іконку з баннеру  Комерційні тендери SmartTender
	old_search.Активувати вкладку ФГИ
	small_privatization_search.Активувати вкладку  Реєстр об'єктів приватизації
	small_privatization_search.Вибрати режим сторінки об'єктів приватизації  Кабінет
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	small_privatization_search.Натиснути створити  інформаційне повідомлення
	small_privatization_step.Заповнити "Унікальний код об'єкту"  ${id}
	small_privatization_step.Заповнити "Рішення про затверждення умов продажу"
	small_privatization_step.Заповнити "Умови аукціону"
	small_privatization_step.Заповнити "Банківські реквізити"
	small_privatization_informational_message.Зберегти чернетку інформаційного повідомлення
	small_privatization_informational_message.Передати на перевірку інформаційне повідомлення


Завантажити локатори для ІП
	${edit_locators}  small_privatization_informational_message_variables.get_edit_locators
	${view_locators}  small_privatization_informational_message_variables.get_view_locators
	${data}  small_privatization_informational_message_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}


#########################################################
#	                  Keywords							#
#########################################################
#####################  Об'єкт ###########################
Заповнити "Назву об'єкту приватизації"
	${title}  create_sentence  5
	small_privatization_object.Заповнити title  ${title}
	Set To Dictionary  ${data}  title  [ТЕСТУВАННЯ] ${title}


Заповнити "Опис об'єкту приватизації"
	${description}  create_sentence  20
	small_privatization_object.Заповнити description  ${description}
	Set To Dictionary  ${data}  description  ${description}


Заповнити "Рішення про затвердження переліку об'єктів"
	small_privatization_step.Заповнити "Назву рішення"
	small_privatization_step.Заповнити "Номер рішення"
	small_privatization_step.Заповнити "Дату рішення"


Заповнити "Назву рішення"
	${title}  create_sentence  5
	small_privatization_object.Заповнити decisions.0.title  ${title}
	Set To Dictionary  ${data['decisions'][0]}  title  ${title}


Заповнити "Номер рішення"
	${decisionID}  random_number  10000  100000
	small_privatization_object.Заповнити decisions.0.decisionID  ${decisionID}
	Set To Dictionary  ${data['decisions'][0]}  decisionID  ${decisionID}


Заповнити "Дату рішення"
	${decisionDate}  smart_get_time  0  m
	small_privatization_object.Заповнити decisions.0.decisionDate  ${decisionDate}
	Set To Dictionary  ${data['decisions'][0]}  decisionDate  ${decisionDate}:00


Заповнити "Загальну інформацію про об'єкт"
	small_privatization_step.Заповнити "Опис об'єкту"
	small_privatization_step.Заповнити "Вид об'єкту"
	small_privatization_step.Заповнити "Кількість"
	small_privatization_step.Заповнити "Одиниця виміру"
	small_privatization_step.Заповнити "Адресу"


Заповнити "Опис об'єкту"
	${description}  create_sentence  20
	small_privatization_object.Заповнити items.0.description  ${description}
	Set To Dictionary  ${data['items'][0]}  description  ${description}


Заповнити "Вид об'єкту"
	${kind}  small_privatization_object.Заповнити items.0.classification.kind
	Set To Dictionary  ${data['items'][0]['classification']}  kind  ${kind}
	Run Keyword If  "102" in "${kind}"  Run Keywords
	...  Set To Dictionary  ${data['items'][0]['classification']}  id  42990000-2
	...  AND  Set To Dictionary  ${data['items'][0]['classification']}  description  Машини спеціального призначення різні
	...  ELSE IF  "301" in "${kind}"  Run Keywords
	...  Set To Dictionary  ${data['items'][0]['classification']}  id  08110000-0
	...  AND  Set To Dictionary  ${data['items'][0]['classification']}  description  Корпоративні права Акціонерного товариства
	...  ELSE IF  "302" in "${kind}"  Run Keywords
	...  Set To Dictionary  ${data['items'][0]['classification']}  id  08160000-5
	...  AND  Set To Dictionary  ${data['items'][0]['classification']}  description  Корпоративні права інші
	...  ELSE  small_privatization_step.Заповнити "Класифікація об'єкту"


Заповнити "Класифікація об'єкту"
	${description}  small_privatization_object.Заповнити items.0.classification.description
	${id}  Evaluate  (re.findall(r'[0-9]*[-][0-9]*', "${description}"))[0]  re
	Set To Dictionary  ${data['items'][0]['classification']}  id  ${id}
	${description}  Evaluate  re.sub(r'[0-9]*[-][0-9]*.', '', "${description}", 1)  re
	Set To Dictionary  ${data['items'][0]['classification']}  description  ${description}


Заповнити "Кількість"
	${first}  random_number  1  1000
	${second}  random_number  1  100
    ${quantity}  Evaluate  str(round(float(${first})/float(${second}), 3))
	small_privatization_object.Заповнити items.0.quantity  ${quantity}
	Set To Dictionary  ${data['items'][0]}  quantity  ${quantity}


Заповнити "Одиниця виміру"
	${name}  small_privatization_object.Заповнити items.0.unit.name
	Set To Dictionary  ${data['items'][0]['unit']}  name  ${name}


Заповнити "Адресу"
	small_privatization_step.Заповнити "Поштовий індекс предмету"
	small_privatization_step.Заповнити "Країна предмету"
	small_privatization_step.Заповнити "Місто предмету"
	small_privatization_step.Заповнити "Вулиця предмету"


Заповнити "Поштовий індекс предмету"
	${postalCode}  random_number  10000  99999
	small_privatization_object.Заповнити items.0.address.postalCode  ${postalCode}
	Set To Dictionary  ${data['items'][0]['address']}  postalCode  ${postalCode}


Заповнити "Країна предмету"
	Set To Dictionary  ${data['items'][0]['address']}  countryName  Україна


Заповнити "Місто предмету"
	${locality}  small_privatization_object.Заповнити items.0.address.locality
	${region}  Evaluate  (re.findall(r'[А-я][^(]+[.]','${locality}'))[0]  re
	Set To Dictionary  ${data['items'][0]['address']}  region  ${region}
	${locality}  Evaluate  re.sub(r'.[(].*','','${locality}')  re
	Set To Dictionary  ${data['items'][0]['address']}  locality  ${locality}


Заповнити "Вулиця предмету"
	${streetAddress}  get_some_uuid
	small_privatization_object.Заповнити items.0.address.streetAddress  ${streetAddress}
	Set To Dictionary  ${data['items'][0]['address']}  streetAddress  ${streetAddress}



#####################  ИС ###########################
Заповнити "Унікальний код об'єкту"
	[Arguments]  ${id}
	small_privatization_informational_message.Ввести унікальний код об'єкту  ${id}


Заповнити "Рішення про затверждення умов продажу"
	small_privatization_step.Заповнити "Номер рішення для ІП"
	small_privatization_step.Заповнити "Дату рішення для ІП"


Заповнити "Номер рішення для ІП"
	${decisionID}  random_number  1000  1000000
	small_privatization_informational_message.Заповнити decisions.0.decisionID  ${decisionID}
	Set To Dictionary  ${data['decisions'][0]}  decisionID  ${decisionID}


Заповнити "Дату рішення для ІП"
	${decisionDate}  smart_get_time  0  m
	small_privatization_informational_message.Заповнити decisions.0.decisionDate  ${decisionDate}
	Set To Dictionary  ${data['decisions'][0]}  decisionDate  ${decisionDate}


Заповнити "Умови аукціону"
	small_privatization_step.Заповнити "Дата проведення аукціону"
	small_privatization_step.Заповнити "Період між аукціонами"
	small_privatization_step.Заповнити "Стартова ціна об’єкта"
	small_privatization_step.Заповнити "Крок аукціону"
	small_privatization_step.Заповнити "Розмір гарантійного внеску"
	small_privatization_step.Заповнити "Реєстраційний внесок"
	small_privatization_step.Заповнити "Кількість кроків аукціону"


Заповнити "Дата проведення аукціону"
	${delta days}  Set Variable  6
	${delta minutes}  Set Variable  15
	${date + delta prod}  get_formated_time_with_delta  ${delta days}  days  s
	${date + delta test}  get_formated_time_with_delta  ${delta minutes}  minutes  s
	${date + delta}  Set Variable If
	...  '${site}' == 'test'  ${date + delta test}
	...  '${site}' == 'prod'  ${date + delta prod}
	${date + delta}  Evaluate  '${date + delta}'[:-2]+'00'
	small_privatization_informational_message.Заповнити auctions.0.auctionPeriod.startDate  ${date + delta}
	Set To Dictionary  ${data['auctions'][0]['auctionPeriod']}  startDate  ${date + delta}


Заповнити "Період між аукціонами"
	${period}  random_number  20  35
	small_privatization_informational_message.Заповнити auctions.1.tenderingDuration  ${period}
	:FOR  ${i}  IN RANGE  1  3
    \    Set To Dictionary  ${data['auctions'][${i}]}  tenderingDuration  P${period}D


Заповнити "Стартова ціна об’єкта"
	${value}  random_number  100000  1000000
	small_privatization_informational_message.Заповнити auctions.0.value.amount  ${value}
	Set To Dictionary  ${data['auctions'][0]['value']}  amount  ${value}


Заповнити "Крок аукціону"
	${step}  random_number  1000  10000
	small_privatization_informational_message.Заповнити auctions.0.minimalStep.amount  ${step}
	Set To Dictionary  ${data['auctions'][0]['minimalStep']}  amount  ${step}


Заповнити "Розмір гарантійного внеску"
	${warrantyFee}  random_number  100  5000
	small_privatization_informational_message.Заповнити auctions.0.guarantee.amount  ${warrantyFee}
	Set To Dictionary  ${data['auctions'][0]['guarantee']}  amount  ${warrantyFee}


Заповнити "Реєстраційний внесок"
	${registrationFee}  random_number  100  5000
	small_privatization_informational_message.Заповнити auctions.0.registrationFee.amount  ${registrationFee}
	:FOR  ${i}  IN RANGE  0  3
    \    Set To Dictionary  ${data['auctions'][${i}]['registrationFee']}  amount  ${registrationFee}


Заповнити "Кількість кроків аукціону"
	${stepCount}  random_number  1  99
	small_privatization_informational_message.Заповнити auctions.2.auctionParameters.dutchSteps  ${stepCount}
	Set To Dictionary  ${data['auctions'][2]['auctionParameters']}  dutchSteps  ${stepCount}


Заповнити "Банківські реквізити"
	small_privatization_step.Заповнити "Найменування банку"
	small_privatization_informational_message.Натиснути Додати реквізити
	small_privatization_step.Заповнити "Тип реквізиту"
	small_privatization_step.Заповнити "Значення реквізиту"
	small_privatization_step.Заповнити "Опис реквізиту"


Заповнити "Найменування банку"
	${bankName}  create_sentence  5
	small_privatization_informational_message.Заповнити auctions.0.bankAccount.bankName  ${bankName}
	:FOR  ${i}  IN RANGE  0  3
    \    Set To Dictionary  ${data['auctions'][${i}]['bankAccount']}  bankName  ${bankName}


Заповнити "Тип реквізиту"
	${type}  small_privatization_informational_message.Заповнити auctions.0.bankAccount.accountIdentification.0.scheme
	:FOR  ${i}  IN RANGE  0  3
    \    Set To Dictionary  ${data['auctions'][${i}]['bankAccount']['accountIdentification'][0]}  scheme  ${type}


Заповнити "Значення реквізиту"
	${id}  random_number  1000000  9999999
	small_privatization_informational_message.Заповнити auctions.0.bankAccount.accountIdentification.0.id  ${id}
	:FOR  ${i}  IN RANGE  0  3
    \    Set To Dictionary  ${data['auctions'][${i}]['bankAccount']['accountIdentification'][0]}  id  ${id}



Заповнити "Опис реквізиту"
	${description}  create_sentence  10
	small_privatization_informational_message.Заповнити auctions.0.bankAccount.accountIdentification.0.description  ${description}
	:FOR  ${i}  IN RANGE  0  3
    \    Set To Dictionary  ${data['auctions'][${i}]['bankAccount']['accountIdentification'][0]}  description  ${description}
