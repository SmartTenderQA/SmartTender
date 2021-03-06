*** Keywords ***
Створити тендер
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
	Wait Until Keyword Succeeds  30  .5  actions.Натиснути додати(F7)  Додавання. Тендери
  	create_tender.Вибрати тип процедури  Допорогові закупівлі
    below.Заповнити amount для tender
  	below.Заповнити minimalStep для tender
  	Run Keyword If  '${site}' == 'prod'
  	...  below.Заповнити contact для tender ${site}
  	tender_tab.Заповнити "Вид предмету закупівлі"  Товари
  	below.Заповнити title для tender
  	below.Заповнити description для tender
  	below.Додати предмет в тендер
  	below.Заповнити endDate періоду обговорення
  	below.Заповнити startDate періоду пропозицій
  	below.Заповнити endDate періоду пропозицій
    docs_tab.Додати документ до тендара власником (webclient)
    create_tender.Зберегти чернетку
    actions.Оголосити тендер


#########################################################
#	                  Keywords							#
#########################################################
Заповнити endDate періоду обговорення
    ${date}  get_time_now_with_deviation  5  minutes
    ${prod date}  service.get_only_numbers  ${date}
    tender_tab.Заповнити "Обговорення закупівлі до"  ${date}  ${prod date}
    Set To Dictionary  ${data['enquiryPeriod']}  endDate  ${date}


Заповнити startDate періоду пропозицій
    ${date}  get_time_now_with_deviation  6  minutes
    ${prod date}  service.get_only_numbers  ${date}
    tender_tab.Заповнити "Прийом пропозицій з"  ${date}  ${prod date}
    Set To Dictionary  ${data['tenderPeriod']}  startDate  ${date}


Заповнити endDate періоду пропозицій
    ${date}  get_time_now_with_deviation  22  minutes
    ${prod date}  service.get_only_numbers  ${date}
    tender_tab.Заповнити "Прийом пропозицій по"  ${date}  ${prod date}
    Set To Dictionary  ${data['tenderPeriod']}  endDate  ${date}


Заповнити contact для tender test
    ${name}  Set Variable  Прохоров И.А.
    tender_tab.Заповнити "Контактна особа"  ${name}
    Set To Dictionary  ${data['procuringEntity']['contactPoint']}  name  ${name}


Заповнити contact для tender prod
    #${name}  Вибрати "Контактна особа"
    ${name}  Set Variable  Прохоров И.А.
    tender_tab.Заповнити "Контактна особа"  ${name}
    Set To Dictionary  ${data['procuringEntity']['contactPoint']}  name  ${name}


Заповнити amount для tender
    ${amount}  random_number  100000  100000000
    ${amount}  tender_tab.Заповнити "Очікувана вартість закупівлі"  ${amount}
    Set To Dictionary  ${data['value']}  amount  ${amount}


Заповнити minimalStep для tender
    ${minimal_step_percent}  random_number  1  5
    ${amount}  tender_tab.Заповнити "Мінімальний крок аукціону"   ${minimal_step_percent}
    ${amount}  Evaluate  (${data['value']['amount']} * ${minimal_step_percent})/100
    Set To Dictionary  ${data['minimalStep']}  amount  ${amount}


Заповнити title для tender
    ${text}  create_sentence  5
    ${title}  Set Variable  [ТЕСТУВАННЯ] ${text}
    tender_tab.Заповнити "Узагальнена назва закупівлі"   ${title}
    Set To Dictionary  ${data}  title  ${title}


Заповнити description для tender
    ${description}  create_sentence  15
    tender_tab.Заповнити "Примітки до закупівлі"  ${description}
    Set To Dictionary  ${data}  description  ${description}


Додати предмет в тендер
    below.Заповнити description для item
    below.Заповнити quantity для item
    below.Заповнити id для item
    below.Заповнити unit.name для item
    below.Заповнити postalCode для item
    below.Заповнити startDate для item
    below.Заповнити endDate для item
    below.Заповнити streetAddress для item
    below.Заповнити locality для item


Заповнити description для item
    ${description}  create_sentence  5
    tender_tab.Заповнити "Назва предмета закупівлі"  ${description}
    Set To Dictionary  ${data['items'][0]}  description  ${description}


Заповнити quantity для item
    ${quantity}  random_number  1  1000
    tender_tab.Заповнити "Об'єм постачання"  ${quantity}
    Set To Dictionary  ${data['items'][0]}  quantity  ${quantity}


Заповнити id для item
    ${value}    tender_tab.Заповнити "Класифікація"
    ${id}       Evaluate  re.search(r'(?P<id>\\d.+)', u'${value}').group('id')  re
    ${description}  Evaluate  re.search(r'(?P<description>\\D.+) ', u'${value}').group('description')  re
    Set To Dictionary  ${data['items'][0]['classification']}  id  ${id}
    Set To Dictionary  ${data['items'][0]['classification']}  description  ${description}


Заповнити unit.name для item
    ${unit name}  tender_tab.Заповнити "Одиниця виміру"
    Set To Dictionary  ${data['items'][0]['unit']}  name  ${unit name}


Заповнити postalCode для item
    ${postal code}  random_number  10000  99999
    tender_tab.Заповнити "Індекс"  ${postal code}
    Set To Dictionary  ${data['items'][0]['deliveryAddress']}  postalCode  ${postal code}


Заповнити streetAddress для item
    ${street}  get_some_uuid
    tender_tab.Заповнити "Вулиця"  ${street}
    Set To Dictionary  ${data['items'][0]['deliveryAddress']}  streetAddress  ${street}


Заповнити locality для item
    ${city}  tender_tab.Заповнити "Місто"  Мюнхен
    Set To Dictionary  ${data['items'][0]['deliveryAddress']}  locality  ${city}


Заповнити startDate для item
    ${date}  get_time_now_with_deviation  1  days
    ${prod date}  service.get_only_numbers  ${date}
    tender_tab.Заповнити "Строк поставки з"  ${date}  ${prod date}
    Set To Dictionary  ${data['items'][0]['deliveryDate']}  startDate  ${date}


Заповнити endDate для item
    ${date}  get_time_now_with_deviation  2  days
    ${prod date}  service.get_only_numbers  ${date}
    tender_tab.Заповнити "Строк поставки по"  ${date}  ${prod date}
    Set To Dictionary  ${data['items'][0]['deliveryDate']}  endDate  ${date}


Отримати дані тендера та зберегти їх у файл
    [Tags]  create_tender
	Знайти тендер організатором по title  ${data['title']}
    ${tender_uaid}  Отримати tender_uaid вибраного тендера
    ${tender_href}  Отримати tender_href вибраного тендера
    Set To Dictionary  ${data}  tenderID  ${tender_uaid}
    Set To Dictionary  ${data}  tender_href  ${tender_href}
    Log  ${tender_href}  WARN
    Зберегти словник у файл  ${data}  data
