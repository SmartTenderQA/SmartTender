*** Keywords ***
Створити тендер
	Перейти у розділ (webclient)  Открытые закупки энергосервиса (ESCO) (тестовые)
	Натиснути додати(F7)  Додавання. Тендери
	test_esco.Заповнити endDate періоду пропозицій
	test_esco.Заповнити minimalStep для tender
	test_esco.Заповнити title для tender
  	test_esco.Заповнити title_eng для tender
    test_esco.Додати предмет в тендер
    Додати документ до тендара власником (webclient)
    Зберегти чернетку
    Оголосити закупівлю


#########################################################
#	                  Keywords							#
#########################################################
Заповнити endDate періоду пропозицій
    ${date}  get_time_now_with_deviation  40  minutes
    ${selector}  set variable  //*[@data-name="D_SROK"]//input
    Заповнити текстове поле  ${selector}  ${date}
    Set To Dictionary  ${data['tenderPeriod']}  endDate  ${date}


Заповнити minimalStep для tender
    ${minimal_step_percent}  random_number  1  3
    ${amount}  Заповнити "Мінімальний крок аукціону"   ${minimal_step_percent}
    Set To Dictionary  ${data['minimalStep']}  amount  ${amount}


Заповнити title для tender
    ${text}  create_sentence  5
    ${title}  Set Variable  [ТЕСТУВАННЯ] ${text}
    Заповнити "Узагальнена назва закупівлі"   ${title}
    Set To Dictionary  ${data}  title  ${title}


Заповнити title_eng для tender
    ${text_en}  create_sentence  5
    ${title_en}  Set Variable  [ТЕСТУВАННЯ] ${text_en}
    Set To Dictionary  ${data}  title_en  ${title_en}
    Заповнити "Узагальнена назва закупівлі ENG"  ${title_en}


Додати предмет в тендер
    test_esco.Заповнити description для item
    test_esco.Заповнити description_eng для item
    test_esco.Заповнити postalCode для item
    test_esco.Заповнити streetAddress для item
    test_esco.Заповнити locality для item


Заповнити description для item
    ${description}  create_sentence  5
    Заповнити "Назва предмета закупівлі"  ${description}
    Set To Dictionary  ${data['items'][0]}  description  ${description}


Заповнити description_eng для item
    ${description_en}  create_sentence  5
    Set To Dictionary  ${data['items'][0]}  description_en  ${description_en}
    Заповнити "Назва предмета закупівлі ENG"  ${description_en}


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


Отримати дані тендера та зберегти їх у файл
    [Tags]  create_tender
	Знайти тендер організатором по title  ${data['title']}
    ${tender_uaid}  Отримати tender_uaid вибраного тендера
    ${tender_href}  Отримати tender_href вибраного тендера
    Set To Dictionary  ${data}  tenderID  ${tender_uaid}
    Set To Dictionary  ${data}  tender_href  ${tender_href}
    Log  ${tender_href}  WARN
    Зберегти словник у файл  ${data}  data
