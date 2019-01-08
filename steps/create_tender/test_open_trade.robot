*** Keywords ***
Створити тендер
    [Arguments]  ${type}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
	webclient_elements.Натиснути додати(F7)  Додавання. Тендери
  	create_tender.Вибрати тип процедури  ${type}
  	test_open_trade.Заповнити endDate періоду пропозицій
  	test_open_trade.Заповнити amount для tender
  	test_open_trade.Заповнити minimalStep для tender
  	test_open_trade.Заповнити title для tender
  	test_open_trade.Заповнити description для tender
  	test_open_trade.Додати предмет в тендер
    docs_tab.Додати документ до тендара власником (webclient)
    create_tender.Зберегти чернетку
    Оголосити закупівлю


#########################################################
#	                  Keywords							#
#########################################################
Заповнити endDate періоду пропозицій
    ${date}  get_time_now_with_deviation  37  minutes
    tender_tab.Заповнити "Прийом пропозицій по"  ${date}
    Set To Dictionary  ${data['tenderPeriod']}  endDate  ${date}


Заповнити contact для tender
    ${person}  tender_tab.Вибрати "Контактна особа"
    Set To Dictionary  ${data['procuringEntity']['contactPoint']}  name  ${person}


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
    test_open_trade.Заповнити description для item
    test_open_trade.Заповнити quantity для item
    test_open_trade.Заповнити id для item
    test_open_trade.Заповнити unit.name для item
    test_open_trade.Заповнити postalCode для item
    test_open_trade.Заповнити startDate для item
    test_open_trade.Заповнити endDate для item
    test_open_trade.Заповнити streetAddress для item
    test_open_trade.Заповнити locality для item


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
    ${value}  get_time_now_with_deviation  1  days
    tender_tab.Заповнити "Строк поставки з"  ${value}
    Set To Dictionary  ${data['items'][0]['deliveryDate']}  startDate  ${value}


Заповнити endDate для item
    ${value}  get_time_now_with_deviation  2  days
    tender_tab.Заповнити "Строк поставки по"  ${value}
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
