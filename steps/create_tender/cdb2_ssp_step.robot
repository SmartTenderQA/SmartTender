*** Settings ***
Library  ../../src/pages/sale/SPF/cdb2_ssp_page/cdb2_ssp_asset_page/cdb2_ssp_asset_variables.py
Library  ../../src/pages/sale/SPF/cdb2_ssp_page/cdb2_ssp_lot_page/cdb2_ssp_lot_variables.py


*** Keywords ***
Створити об'єкт МП
	cdb2_ssp_step.Завантажити локатори для об'єкта

	start_page.Натиснути на іконку з баннеру  Комерційні тендери SmartTender
	old_search.Активувати вкладку ФГИ
	small_privatization_search.Активувати вкладку  Реєстр об'єктів приватизації
	small_privatization_search.Вибрати режим сторінки об'єктів приватизації  Кабінет
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	small_privatization_search.Натиснути створити  об'єкт
	cdb2_ssp_step.Заповнити "Назву об'єкту приватизації"
	cdb2_ssp_step.Заповнити "Опис об'єкту приватизації"
	cdb2_ssp_step.Заповнити "Рішення про затвердження переліку об'єктів"
	cdb2_ssp_step.Заповнити "Загальну інформацію про об'єкт"
	sale_keywords.Натиснути кнопку зберегти
	sale_keywords.Натиснути кнопку опублікувати


Завантажити локатори для об'єкта
	${edit_locators}  cdb2_ssp_asset_variables.get_edit_locators
	${view_locators}  cdb2_ssp_asset_variables.get_view_locators
	${data}  cdb2_ssp_asset_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}


Створити інформаційне повідомлення МП
	[Arguments]  ${id}
	cdb2_ssp_step.Завантажити локатори для ІП

	start_page.Натиснути на іконку з баннеру  Комерційні тендери SmartTender
	old_search.Активувати вкладку ФГИ
	small_privatization_search.Активувати вкладку  Реєстр об'єктів приватизації
	small_privatization_search.Вибрати режим сторінки об'єктів приватизації  Кабінет
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	small_privatization_search.Натиснути створити  інформаційне повідомлення
	cdb2_ssp_step.Заповнити "Унікальний код об'єкту"  ${id}
	cdb2_ssp_step.Заповнити "Рішення про затверждення умов продажу"
	cdb2_ssp_step.Заповнити "Умови аукціону"
	cdb2_ssp_step.Заповнити "Банківські реквізити"
	sale_keywords.Натиснути кнопку зберегти
	sale_keywords.Натиснути кнопку опублікувати
	sale_keywords.Натиснути кнопку опублікувати


Завантажити локатори для ІП
	${edit_locators}  cdb2_ssp_lot_variables.get_edit_locators
	${view_locators}  cdb2_ssp_lot_variables.get_view_locators
	${data}  cdb2_ssp_lot_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}


#########################################################
#	                  Keywords							#
#########################################################
#####################  Об'єкт ###########################
Заповнити "Назву об'єкту приватизації"
	${title}  create_sentence  5
	cdb2_ssp_asset_page.Заповнити title  ${title}
	Set To Dictionary  ${data}  title  [ТЕСТУВАННЯ] ${title}


Заповнити "Опис об'єкту приватизації"
	${description}  create_sentence  20
	cdb2_ssp_asset_page.Заповнити description  ${description}
	Set To Dictionary  ${data}  description  ${description}


Заповнити "Рішення про затвердження переліку об'єктів"
	cdb2_ssp_step.Заповнити "Назву рішення"
	cdb2_ssp_step.Заповнити "Номер рішення"
	cdb2_ssp_step.Заповнити "Дату рішення"


Заповнити "Назву рішення"
	${title}  create_sentence  5
	cdb2_ssp_asset_page.Заповнити decisions.0.title  ${title}
	Set To Dictionary  ${data['decisions'][0]}  title  ${title}


Заповнити "Номер рішення"
	${decisionID}  random_number  10000  100000
	cdb2_ssp_asset_page.Заповнити decisions.0.decisionID  ${decisionID}
	Set To Dictionary  ${data['decisions'][0]}  decisionID  ${decisionID}


Заповнити "Дату рішення"
	${decisionDate}  smart_get_time  0  m
	cdb2_ssp_asset_page.Заповнити decisions.0.decisionDate  ${decisionDate}
	Set To Dictionary  ${data['decisions'][0]}  decisionDate  ${decisionDate}:00


Заповнити "Загальну інформацію про об'єкт"
	cdb2_ssp_step.Заповнити "Опис об'єкту"
	cdb2_ssp_step.Заповнити "Вид об'єкту"
	cdb2_ssp_step.Заповнити "Кількість"
	cdb2_ssp_step.Заповнити "Одиниця виміру"
	cdb2_ssp_step.Заповнити "Адресу"


Заповнити "Опис об'єкту"
	${description}  create_sentence  20
	cdb2_ssp_asset_page.Заповнити items.0.description  ${description}
	Set To Dictionary  ${data['items'][0]}  description  ${description}


Заповнити "Вид об'єкту"
	${kind}  cdb2_ssp_asset_page.Заповнити items.0.classification.kind
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
	...  ELSE  cdb2_ssp_step.Заповнити "Класифікація об'єкту"


Заповнити "Класифікація об'єкту"
	${description}  cdb2_ssp_asset_page.Заповнити items.0.classification.description
	${id}  Evaluate  (re.findall(r'[0-9]*[-][0-9]*', "${description}"))[0]  re
	Set To Dictionary  ${data['items'][0]['classification']}  id  ${id}
	${description}  Evaluate  re.sub(r'[0-9]*[-][0-9]*.', '', "${description}", 1)  re
	Set To Dictionary  ${data['items'][0]['classification']}  description  ${description}


Заповнити "Кількість"
	${first}  random_number  1  1000
	${second}  random_number  1  100
    ${quantity}  Evaluate  str(round(float(${first})/float(${second}), 3))
	cdb2_ssp_asset_page.Заповнити items.0.quantity  ${quantity}
	Set To Dictionary  ${data['items'][0]}  quantity  ${quantity}


Заповнити "Одиниця виміру"
	${name}  cdb2_ssp_asset_page.Заповнити items.0.unit.name
	Set To Dictionary  ${data['items'][0]['unit']}  name  ${name}


Заповнити "Адресу"
	cdb2_ssp_step.Заповнити "Поштовий індекс предмету"
	cdb2_ssp_step.Заповнити "Країна предмету"
	cdb2_ssp_step.Заповнити "Місто предмету"
	cdb2_ssp_step.Заповнити "Вулиця предмету"


Заповнити "Поштовий індекс предмету"
	${postalCode}  random_number  10000  99999
	cdb2_ssp_asset_page.Заповнити items.0.address.postalCode  ${postalCode}
	Set To Dictionary  ${data['items'][0]['address']}  postalCode  ${postalCode}


Заповнити "Країна предмету"
	Set To Dictionary  ${data['items'][0]['address']}  countryName  Україна


Заповнити "Місто предмету"
	${locality}  cdb2_ssp_asset_page.Заповнити items.0.address.locality
	${region}  Evaluate  (re.findall(r'[А-я][^(]+[.]','${locality}'))[0]  re
	Set To Dictionary  ${data['items'][0]['address']}  region  ${region}
	${locality}  Evaluate  re.sub(r'.[(].*','','${locality}')  re
	Set To Dictionary  ${data['items'][0]['address']}  locality  ${locality}


Заповнити "Вулиця предмету"
	${streetAddress}  get_some_uuid
	cdb2_ssp_asset_page.Заповнити items.0.address.streetAddress  ${streetAddress}
	Set To Dictionary  ${data['items'][0]['address']}  streetAddress  ${streetAddress}



#####################  ИС ###########################
Заповнити "Унікальний код об'єкту"
	[Arguments]  ${id}
	cdb2_ssp_lot_page.Ввести унікальний код об'єкту  ${id}


Заповнити "Рішення про затверждення умов продажу"
	cdb2_ssp_step.Заповнити "Номер рішення для ІП"
	cdb2_ssp_step.Заповнити "Дату рішення для ІП"


Заповнити "Номер рішення для ІП"
	${decisionID}  random_number  1000  1000000
	cdb2_ssp_lot_page.Заповнити decisions.0.decisionID  ${decisionID}
	Set To Dictionary  ${data['decisions'][0]}  decisionID  ${decisionID}


Заповнити "Дату рішення для ІП"
	${decisionDate}  smart_get_time  0  m
	cdb2_ssp_lot_page.Заповнити decisions.0.decisionDate  ${decisionDate}
	Set To Dictionary  ${data['decisions'][0]}  decisionDate  ${decisionDate}:00


Заповнити "Умови аукціону"
	cdb2_ssp_step.Заповнити "Дата проведення аукціону"
	cdb2_ssp_step.Заповнити "Період між аукціонами"
	cdb2_ssp_step.Заповнити "Стартова ціна об’єкта"
	cdb2_ssp_step.Заповнити "Крок аукціону"
	cdb2_ssp_step.Заповнити "Розмір гарантійного внеску"
	cdb2_ssp_step.Заповнити "Реєстраційний внесок"
	cdb2_ssp_step.Заповнити "Кількість кроків аукціону"


Заповнити "Дата проведення аукціону"
	${delta days}  Set Variable  6
	${delta minutes}  Set Variable  30
	${date + delta prod}  get_formated_time_with_delta  ${delta days}  days  s
	${date + delta test}  get_formated_time_with_delta  ${delta minutes}  minutes  s
	${date + delta}  Set Variable If
	...  '${site}' == 'test'  ${date + delta test}
	...  '${site}' == 'prod'  ${date + delta prod}
	${date + delta}  Evaluate  '${date + delta}'[:-2]+'00'
	cdb2_ssp_lot_page.Заповнити auctions.0.auctionPeriod.startDate  ${date + delta}
	Set To Dictionary  ${data['auctions'][0]['auctionPeriod']}  startDate  ${date + delta}


Заповнити "Період між аукціонами"
	${period}  random_number  20  35
	cdb2_ssp_lot_page.Заповнити auctions.1.tenderingDuration  ${period}
	:FOR  ${i}  IN RANGE  1  3
    \    Set To Dictionary  ${data['auctions'][${i}]}  tenderingDuration  P${period}D


Заповнити "Стартова ціна об’єкта"
	${value}  random_number  100000  1000000
	cdb2_ssp_lot_page.Заповнити auctions.0.value.amount  ${value}
	Set To Dictionary  ${data['auctions'][0]['value']}  amount  ${value}


Заповнити "Крок аукціону"
	${step}  random_number  1000  10000
	cdb2_ssp_lot_page.Заповнити auctions.0.minimalStep.amount  ${step}
	Set To Dictionary  ${data['auctions'][0]['minimalStep']}  amount  ${step}


Заповнити "Розмір гарантійного внеску"
	${warrantyFee}  random_number  100  5000
	cdb2_ssp_lot_page.Заповнити auctions.0.guarantee.amount  ${warrantyFee}
	Set To Dictionary  ${data['auctions'][0]['guarantee']}  amount  ${warrantyFee}


Заповнити "Реєстраційний внесок"
	${registrationFee}  random_number  100  5000
	cdb2_ssp_lot_page.Заповнити auctions.0.registrationFee.amount  ${registrationFee}
	:FOR  ${i}  IN RANGE  0  3
    \    Set To Dictionary  ${data['auctions'][${i}]['registrationFee']}  amount  ${registrationFee}


Заповнити "Кількість кроків аукціону"
	${stepCount}  random_number  1  99
	cdb2_ssp_lot_page.Заповнити auctions.2.auctionParameters.dutchSteps  ${stepCount}
	Set To Dictionary  ${data['auctions'][2]['auctionParameters']}  dutchSteps  ${stepCount}


Заповнити "Банківські реквізити"
	cdb2_ssp_step.Заповнити "Найменування банку"
	cdb2_ssp_step.Заповнити "Тип реквізиту"
	cdb2_ssp_step.Заповнити "Значення реквізиту"
	cdb2_ssp_step.Заповнити "Опис реквізиту"


Заповнити "Найменування банку"
	${bankName}  create_sentence  5
	cdb2_ssp_lot_page.Заповнити auctions.0.bankAccount.bankName  ${bankName}
	:FOR  ${i}  IN RANGE  0  3
    \    Set To Dictionary  ${data['auctions'][${i}]['bankAccount']}  bankName  ${bankName}


Заповнити "Тип реквізиту"
	${type}  cdb2_ssp_lot_page.Заповнити auctions.0.bankAccount.accountIdentification.0.scheme
	:FOR  ${i}  IN RANGE  0  3
    \    Set To Dictionary  ${data['auctions'][${i}]['bankAccount']['accountIdentification'][0]}  scheme  ${type}


Заповнити "Значення реквізиту"
	${id}  random_number  1000000  9999999
	cdb2_ssp_lot_page.Заповнити auctions.0.bankAccount.accountIdentification.0.id  ${id}
	:FOR  ${i}  IN RANGE  0  3
    \    Set To Dictionary  ${data['auctions'][${i}]['bankAccount']['accountIdentification'][0]}  id  ${id}



Заповнити "Опис реквізиту"
	${description}  create_sentence  10
	cdb2_ssp_lot_page.Заповнити auctions.0.bankAccount.accountIdentification.0.description  ${description}
	:FOR  ${i}  IN RANGE  0  3
    \    Set To Dictionary  ${data['auctions'][${i}]['bankAccount']['accountIdentification'][0]}  description  ${description}
