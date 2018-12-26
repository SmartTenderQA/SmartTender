*** Keywords ***
Створити тендер
	Перейти у розділ (webclient)  Публічні закупівлі (тестові)
	Натиснути додати(F7)  Додавання. Тендери
  	create_tender.Вибрати тип процедури  Допорогові закупівлі
  	prod_below.Заповнити startDate періоду пропозицій
  	prod_below.Заповнити endDate періоду пропозицій
  	prod_below.Заповнити endDate періоду обговорення
  	prod_below.Заповнити amount для tender
  	prod_below.Заповнити minimalStep для tender
  	prod_below.Заповнити contact для tender
  	prod_below.Заповнити title для tender
  	prod_below.Заповнити description для tender
  	prod_below.Додати предмет в тендер
    Додати документ до тендара власником (webclient)
    Зберегти чернетку
    Оголосити тендер


#########################################################
#	                  Keywords							#`
#########################################################
Заповнити endDate періоду обговорення
    ${value}  get_time_now_with_deviation  5  minutes
    ${date}  get_only_numbers  ${value}
    Заповнити "Обговорення закупівлі до"  ${date}
    Set To Dictionary  ${data['enquiryPeriod']}  endDate  ${date}


Заповнити startDate періоду пропозицій
    ${value}  get_time_now_with_deviation  6  minutes
    ${date}  get_only_numbers  ${value}
    Заповнити "Прийом пропозицій з"  ${date}
    Set To Dictionary  ${data['tenderPeriod']}  startDate  ${date}


Заповнити endDate періоду пропозицій
    ${value}  get_time_now_with_deviation  22  minutes
    ${date}  get_only_numbers  ${value}
    Заповнити "Прийом пропозицій по"  ${date}
    Set To Dictionary  ${data['tenderPeriod']}  endDate  ${date}


Заповнити contact для tender
    ${name}  Вибрати "Контактна особа"
    Set To Dictionary  ${data['procuringEntity']['contactPoint']}  name  ${name}


Заповнити amount для tender
    ${amount}  random_number  100000  100000000
    Заповнити "Очікувана вартість закупівлі"  ${amount}
    Set To Dictionary  ${data['value']}  amount  ${amount}


Заповнити minimalStep для tender
    ${minimal_step_percent}  random_number  1  5
    ${amount}  Заповнити "Мінімальний крок аукціону"   ${minimal_step_percent}
    Set To Dictionary  ${data['minimalStep']}  amount  ${amount}


Заповнити title для tender
    ${text}  create_sentence  5
    ${title}  Set Variable  [ТЕСТУВАННЯ] ${text}
    Заповнити "Узагальнена назва закупівлі"   ${title}
    Set To Dictionary  ${data}  title  ${title}


Заповнити description для tender
    ${description}  create_sentence  15
    Заповнити "Примітки до закупівлі"  ${description}
    Set To Dictionary  ${data}  description  ${description}


Додати предмет в тендер
    prod_below.Заповнити description для item
    prod_below.Заповнити quantity для item
    prod_below.Заповнити id для item
    prod_below.Заповнити unit.name для item
    prod_below.Заповнити postalCode для item
    prod_below.Заповнити startDate для item
    prod_below.Заповнити endDate для item
    prod_below.Заповнити streetAddress для item
    prod_below.Заповнити locality для item


Заповнити description для item
    ${description}  create_sentence  5
    Заповнити "Назва предмета закупівлі"  ${description}
    Set To Dictionary  ${data['items'][0]}  description  ${description}


Заповнити quantity для item
    ${quantity}  random_number  1  1000
    Заповнити "Об'єм постачання"  ${quantity}
    Set To Dictionary  ${data['items'][0]}  quantity  ${quantity}


Заповнити id для item
    ${value}    Заповнити "Класифікація"
    ${id}       Evaluate  re.search(r'(?P<id>\\d.+)', u'${value}').group('id')  re
    ${description}  Evaluate  re.search(r'(?P<description>\\D.+) ', u'${value}').group('description')  re
    Set To Dictionary  ${data['items'][0]['classification']}  id  ${id}
    Set To Dictionary  ${data['items'][0]['classification']}  description  ${description}


Заповнити unit.name для item
    ${unit name}  tender_tab.Заповнити "Одиниця виміру"
    Set To Dictionary  ${data['items'][0]['unit']}  name  ${unit name}


Заповнити postalCode для item
    ${postal code}  random_number  10000  99999
    Заповнити "Індекс"  ${postal code}
    Set To Dictionary  ${data['items'][0]['deliveryAddress']}  postalCode  ${postal code}


Заповнити streetAddress для item
    ${street}  get_some_uuid
    Заповнити "Вулиця"  ${street}
    Set To Dictionary  ${data['items'][0]['deliveryAddress']}  streetAddress  ${street}


Заповнити locality для item
    ${city}  Заповнити "Місто"  Мюнхен
    Set To Dictionary  ${data['items'][0]['deliveryAddress']}  locality  ${city}


Заповнити startDate для item
    ${value}  get_time_now_with_deviation  1  days
    Заповнити "Строк поставки з"  ${value}
    Set To Dictionary  ${data['items'][0]['deliveryDate']}  startDate  ${value}


Заповнити endDate для item
    ${value}  get_time_now_with_deviation  2  days
    Заповнити "Строк поставки по"  ${value}
    Set To Dictionary  ${data['items'][0]['deliveryDate']}  endDate  ${value}


Отримати дані тендера та зберегти їх у файл
    [Tags]  create_tender
	Знайти тендер організатором по title  ${data['title']}
    ${tender_uaid}  Отримати tender_uaid вибраного тендера
    ${tender_href}  Отримати tender_href вибраного тендера
    Set To Dictionary  ${data}  tenderID  ${tender_uaid}
    Set To Dictionary  ${data}  tender_href  ${tender_href}
    Log  ${tender_href}  WARN
    Зберегти словник у файл  ${data}  data
