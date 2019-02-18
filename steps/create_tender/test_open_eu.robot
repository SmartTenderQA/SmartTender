*** Keywords ***
Створити тендер
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
	actions.Натиснути додати(F7)  Додавання. Тендери
  	create_tender.Вибрати тип процедури  Відкриті торги з публікацією англійською мовою
  	Run Keyword If  '${site}' == 'prod'  Run Keywords
  	...  test_open_eu.Заповнити contact для tender  AND
  	...  test_open_eu.Заповнити ПІБ організації  AND
    ...  tender_tab.Заповнити "Вид предмету закупівлі"  Товари
  	test_open_eu.Заповнити amount для tender
  	test_open_eu.Заповнити minimalStep для tender
  	test_open_eu.Заповнити title для tender
  	test_open_eu.Заповнити title_eng для tender
  	test_open_eu.Заповнити description для tender
  	test_open_eu.Додати предмет в тендер
  	test_open_eu.Заповнити endDate періоду пропозицій
    docs_tab.Додати документ до тендара власником (webclient)
    create_tender.Зберегти чернетку
    Оголосити закупівлю


Створити тендер (Мультилот)
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
	actions.Натиснути додати(F7)  Додавання. Тендери
  	create_tender.Вибрати тип процедури  Відкриті торги з публікацією англійською мовою
    tender_tab.Встановити чекбокс "Мультилоти"
   	Run Keyword If  '${site}' == 'prod'  Run Keywords
  	...  test_open_eu.Заповнити contact для tender  AND
  	...  test_open_eu.Заповнити ПІБ організації  AND
  	...  tender_tab.Заповнити "Вид предмету закупівлі"  Товари
  	test_open_eu.Заповнити amount для lot
  	test_open_eu.Заповнити minimalStep для lot
  	test_open_eu.Заповнити title для tender
  	test_open_eu.Заповнити title_eng для tender
  	test_open_eu.Заповнити description для tender
  	actions.Натиснути додати (додавання предмету)
  	test_open_eu.Додати предмет в тендер
  	# Додаєм ще один лот
  	actions.Натиснути додати (додавання предмету)
  	tender_tab.Змінити тип елементу на  Лот
  	test_open_eu.Заповнити amount для lot
  	test_open_eu.Заповнити minimalStep для lot
  	actions.Натиснути додати (додавання предмету)

  	test_open_eu.Заповнити description для item
    test_open_eu.Заповнити description_eng для item
    test_open_eu.Заповнити quantity для item
    test_open_eu.Заповнити id для item (другий лот)
    test_open_eu.Заповнити unit.name для item (другий лот)
    test_open_eu.Заповнити postalCode для item
    test_open_eu.Заповнити startDate для item
    test_open_eu.Заповнити endDate для item
    test_open_eu.Заповнити streetAddress для item
    test_open_eu.Заповнити locality для item

    test_open_eu.Заповнити endDate періоду пропозицій
  	docs_tab.Додати документ до тендара власником (webclient)
    create_tender.Зберегти чернетку
    Оголосити закупівлю


#########################################################
#	                  Keywords							#
#########################################################
Заповнити endDate періоду пропозицій
    ${date}  get_time_now_with_deviation  37  minutes
    ${prod date 1}  get_time_now_with_deviation  35  days
    ${prod date}  service.get_only_numbers   ${prod date 1}
    ${date}  Set Variable If  '${site}' == 'prod'  ${prod date 1}  ${date}
    tender_tab.Заповнити "Прийом пропозицій по"  ${date}  ${prod date}
    Set To Dictionary  ${data['tenderPeriod']}  endDate  ${date}

Заповнити contact для tender
    ${name}  Set Variable  Прохоров
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


Заповнити amount для lot
    ${amount}  random_number  100000  100000000
    ${amount}  tender_tab.Заповнити "Очікувана вартість закупівлі" для лоту  ${amount}
    Set To Dictionary  ${data['value']}  amount  ${amount}


Заповнити minimalStep для lot
    ${minimal_step_percent}  random_number  1  5
    ${amount}  tender_tab.Заповнити "Мінімальний крок аукціону" для лоту   ${minimal_step_percent}
    ${amount}  Evaluate  (${data['value']['amount']} * ${minimal_step_percent})/100
    Set To Dictionary  ${data['minimalStep']}  amount  ${amount}


Заповнити ПІБ організації
    tender_tab.Заповнити "Призвіще"     Petrov
    tender_tab.Заповнити "Імя"          Petro
    tender_tab.Заповнити "По батькові"  Petrovych


Заповнити title для tender
    ${text}  create_sentence  5
    ${title}  Set Variable  [ТЕСТУВАННЯ] ${text}
    tender_tab.Заповнити "Узагальнена назва закупівлі"   ${title}
    Set To Dictionary  ${data}  title  ${title}


Заповнити title_eng для tender
    ${text_en}  create_sentence  5
    ${title_en}  Set Variable  [ТЕСТУВАННЯ] ${text_en}
    Set To Dictionary  ${data}  title_en  ${title_en}
    tender_tab.Заповнити "Узагальнена назва закупівлі ENG"  ${title_en}


Заповнити description для tender
    ${description}  create_sentence  15
    tender_tab.Заповнити "Примітки до закупівлі"  ${description}
    Set To Dictionary  ${data}  description  ${description}


Додати предмет в тендер
    test_open_eu.Заповнити description для item
    test_open_eu.Заповнити description_eng для item
    test_open_eu.Заповнити quantity для item
    test_open_eu.Заповнити id для item
    test_open_eu.Заповнити unit.name для item
    test_open_eu.Заповнити postalCode для item
    test_open_eu.Заповнити startDate для item
    test_open_eu.Заповнити endDate для item
    test_open_eu.Заповнити streetAddress для item
    test_open_eu.Заповнити locality для item


Заповнити description для item
    ${description}  create_sentence  5
    tender_tab.Заповнити "Назва предмета закупівлі"  ${description}
    Set To Dictionary  ${data['items'][0]}  description  ${description}


Заповнити description_eng для item
    ${description_en}  create_sentence  5
    Set To Dictionary  ${data['items'][0]}  description_en  ${description_en}
    tender_tab.Заповнити "Назва предмета закупівлі ENG"  ${description_en}


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


Заповнити id для item (другий лот)
    ${input field}  Set Variable  //*[@data-name="MAINCLASSIFICATION"]//input[not(contains(@type,'hidden'))]
    Input Text  ${input field}  ${data['items'][0]['classification']['id']}
    Press Key  ${input field}  \\13
    Sleep  1
    Press Key  ${input field}  \\13


Заповнити unit.name для item (другий лот)
    ${input field}  Set Variable  //*[@data-name='EDI']//input[not(contains(@type,'hidden'))]
    Input Text  ${input field}  ${data['items'][0]['unit']['name']}
    Press Key  ${input field}  \\13
    Sleep  1
    Press Key  ${input field}  \\13
    ${get}  Get Element Attribute  ${input field}  value
    ${status}  Run Keyword And Return Status  Should Be Equal As Strings  ${get}  ${data['items'][0]['unit']['name']}
    Run Keyword If  '${status}' == 'False'  Заповнити unit.name для item (другий лот)


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
