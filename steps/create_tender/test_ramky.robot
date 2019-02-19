*** Keywords ***
Створити тендер
    desktop.Змінити мову (webclient)  Українська
	desktop.Перейти у розділ (webclient)  Рамкові угоди(тестові)
	actions.Натиснути додати(F7)  Додавання. Тендери
  	create_tender.Вибрати тип процедури  Укладання рамкової угоди
    test_ramky.Заповнити кількість учасників для укладання РУ
    test_ramky.Заповнити "Срок рамкової угоди"
  	#Run Keyword And Ignore Error  test_ramky.Заповнити contact для tender
  	Run Keyword And Ignore Error  test_ramky.Заповнити ПІБ організації
  	test_ramky.Заповнити amount для lot
  	test_ramky.Заповнити minimalStep для lot
  	test_ramky.Заповнити title для tender
  	test_ramky.Заповнити description для tender
  	test_ramky.Заповнити title_eng для tender
  	test_ramky.Додати предмет в тендер
  	test_ramky.Заповнити endDate періоду пропозицій
    docs_tab.Додати документ до тендара власником (webclient)
    create_tender.Зберегти чернетку
    Оголосити закупівлю


#########################################################
#	                  Keywords							#
#########################################################
Заповнити кількість учасників для укладання РУ
    ${maxAwardsCount}  Set Variable  3
    tender_tab.Заповнити "Кількість переможців"  ${maxAwardsCount}
    Set To Dictionary  ${data}  maxAwardsCount  ${maxAwardsCount}


Заповнити "Срок рамкової угоди"
    ${agreementDuration}  Set Variable  6
    tender_tab.Заповнити "Срок рамкової угоди" місяців  ${agreementDuration}
    Set To Dictionary  ${data}  agreementDuration  ${agreementDuration}


Заповнити contact для tender
    ${selector}  set variable  //*[@data-name="N_KDK_M"]//input[not(contains(@type,'hidden'))]
    Заповнити текстове поле  ${selector}  Дудник


Заповнити ПІБ організації
    tender_tab.Заповнити "Призвіще"     Petrov
    tender_tab.Заповнити "Імя"          Petro
    tender_tab.Заповнити "По батькові"  Petrovych


Заповнити endDate періоду пропозицій
    ${date}  get_time_now_with_deviation  37  minutes
    tender_tab.Заповнити "Прийом пропозицій по"  ${date}
    Set To Dictionary  ${data['tenderPeriod']}  endDate  ${date}


Заповнити amount для lot
    ${amount}  random_number  100000  100000000
    ${amount}  tender_tab.Заповнити "Очікувана вартість закупівлі" для лоту  ${amount}
    Set To Dictionary  ${data['value']}  amount  ${amount}


Заповнити minimalStep для lot
    ${minimal_step_percent}  random_number  1  5
    ${amount}  tender_tab.Заповнити "Мінімальний крок аукціону" для лоту   ${minimal_step_percent}
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


Заповнити title_eng для tender
    ${text_en}  create_sentence  5
    ${title_en}  Set Variable  [ТЕСТУВАННЯ] ${text_en}
    tender_tab.Заповнити "Узагальнена назва закупівлі ENG"  ${title_en}
    Set To Dictionary  ${data}  title_en  ${title_en}


Додати предмет в тендер
    actions.Натиснути додати (додавання предмету)
    test_ramky.Заповнити description для item
    test_ramky.Заповнити description_eng для item
    test_ramky.Заповнити quantity для item
    test_ramky.Заповнити id для item
    test_ramky.Заповнити unit.name для item
    test_ramky.Заповнити postalCode для item
    test_ramky.Заповнити startDate для item
    test_ramky.Заповнити endDate для item
    test_ramky.Заповнити streetAddress для item
    test_ramky.Заповнити locality для item


Заповнити description для item
    ${description}  create_sentence  5
    tender_tab.Заповнити "Назва предмета закупівлі"  ${description}
    Set To Dictionary  ${data['items'][0]}  description  ${description}


Заповнити description_eng для item
    ${description_en}  create_sentence  5
    tender_tab.Заповнити "Назва предмета закупівлі ENG"  ${description_en}
    Set To Dictionary  ${data['items'][0]}  description_en  ${description_en}


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
