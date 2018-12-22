*** Keywords ***
Створити об'єкт МП
	start_page.Натиснути На торговельний майданчик
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
	small_privatization_object.Натиснути кнопку зберегти
	small_privatization_object.Опублікувати об'єкт у реєстрі


#########################################################
#	                  Keywords							#
#########################################################
Заповнити "Назву об'єкту приватизації"
	${title}  create_sentence  5
	small_privatization_object.Заповнити title  ${title}
	Set To Dictionary  ${spo_data}  title  ${title}


Заповнити "Опис об'єкту приватизації"
	${description}  create_sentence  20
	small_privatization_object.Заповнити description  ${description}
	Set To Dictionary  ${spo_data}  description  ${description}


Заповнити "Рішення про затвердження переліку об'єктів"
	small_privatization_step.Заповнити "Назву рішення"
	small_privatization_step.Заповнити "Номер рішення"
	small_privatization_step.Заповнити "Дату рішення"


Заповнити "Назву рішення"
	${title}  create_sentence  5
	small_privatization_object.Заповнити decisions.0.title  ${title}
	Set To Dictionary  ${spo_data['decisions'][0]}  title  ${title}


Заповнити "Номер рішення"
	${decisionID}  random_number  10000  100000
	small_privatization_object.Заповнити decisions.0.decisionID  ${decisionID}
	Set To Dictionary  ${spo_data['decisions'][0]}  decisionID  ${decisionID}


Заповнити "Дату рішення"
	${decisionDate}  smart_get_time  0  m
	small_privatization_object.Заповнити decisions.0.decisionDate  ${decisionDate}
	Set To Dictionary  ${spo_data['decisions'][0]}  decisionDate  ${decisionDate}


Заповнити "Загальну інформацію про об'єкт"
	small_privatization_step.Заповнити "Опис об'єкту"
	small_privatization_step.Заповнити "Вид об'єкту"
	small_privatization_step.Заповнити "Кількість"
	small_privatization_step.Заповнити "Одиниця виміру"
	small_privatization_step.Заповнити "Адресу"


Заповнити "Опис об'єкту"
	${description}  create_sentence  20
	small_privatization_object.Заповнити items.0.description  ${description}
	Set To Dictionary  ${spo_data['items'][0]}  description  ${description}


Заповнити "Вид об'єкту"
	${kind}  small_privatization_object.Заповнити items.0.classification.kind
	Set To Dictionary  ${spo_data['items'][0]['classification']}  kind  ${kind}
	Run Keyword If  "102" in "${kind}"  Run Keywords
	...  Set To Dictionary  ${spo_data['items'][0]['classification']}  id  '42990000-2'
	...  AND  Set To Dictionary  ${spo_data['items'][0]['classification']}  description  'Машини спеціального призначення різні'
	...  ELSE IF  "301" in "${kind}"  Run Keywords
	...  Set To Dictionary  ${spo_data['items'][0]['classification']}  id  '08110000-0'
	...  AND  Set To Dictionary  ${spo_data['items'][0]['classification']}  description  'Корпоративні права Акціонерного товариства'
	...  ELSE IF  "302" in "${kind}"  Run Keywords
	...  Set To Dictionary  ${spo_data['items'][0]['classification']}  id  '08160000-5'
	...  AND  Set To Dictionary  ${spo_data['items'][0]['classification']}  description  'Корпоративні права інші'
	...  ELSE  small_privatization_step.Заповнити "Класифікація об'єкту"


Заповнити "Класифікація об'єкту"
	${description}  small_privatization_object.Заповнити items.0.classification.description
	${id}  Evaluate  (re.findall(r'[0-9]*[-][0-9]*', "${description}"))[0]  re
	Set To Dictionary  ${spo_data['items'][0]['classification']}  id  ${id}
	${description}  Evaluate  re.sub(r'[0-9]*[-][0-9]*.', '', "${description}", 1)  re
	Set To Dictionary  ${spo_data['items'][0]['classification']}  description  ${description}


Заповнити "Кількість"
	${first}  random_number  1  1000
	${second}  random_number  1  100
    ${quantity}  Evaluate  str(round(float(${first})/float(${second}), 3))
	small_privatization_object.Заповнити items.0.quantity  ${quantity}
	Set To Dictionary  ${spo_data['items'][0]}  quantity  ${quantity}


Заповнити "Одиниця виміру"
	${name}  small_privatization_object.Заповнити items.0.unit.name
	Set To Dictionary  ${spo_data['items'][0]['unit']}  name  ${name}


Заповнити "Адресу"
	small_privatization_step.Заповнити "Поштовий індекс предмету"
	small_privatization_step.Заповнити "Країна предмету"
	small_privatization_step.Заповнити "Місто предмету"
	small_privatization_step.Заповнити "Вулиця предмету"


Заповнити "Поштовий індекс предмету"
	${postalCode}  random_number  10000  99999
	small_privatization_object.Заповнити items.0.address.postalCode  ${postalCode}
	Set To Dictionary  ${spo_data['items'][0]['address']}  postalCode  ${postalCode}


Заповнити "Країна предмету"
	${name}  Set Variable  Україна
	${countryName}  small_privatization_object.Заповнити items.0.address.countryName  ${name}
	Set To Dictionary  ${spo_data['items'][0]['address']}  countryName  ${countryName}


Заповнити "Місто предмету"
	${locality}  small_privatization_object.Заповнити items.0.address.locality
	${region}  Evaluate  (re.findall(r'[А-я][^(]+[.]','${locality}'))[0]  re
	Set To Dictionary  ${spo_data['items'][0]['address']}  region  ${region}
	${locality}  Evaluate  re.sub(r'.[(].*','','${locality}')  re
	Set To Dictionary  ${spo_data['items'][0]['address']}  locality  ${locality}


Заповнити "Вулиця предмету"
	${streetAddress}  get_some_uuid
	small_privatization_object.Заповнити items.0.address.streetAddress  ${streetAddress}
	Set To Dictionary  ${spo_data['items'][0]['address']}  streetAddress  ${streetAddress}