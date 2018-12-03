*** Keywords ***
Створити тендер
	Switch Browser  tender_owner
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
    ${value}  Create Dictionary  endDate=${date}
    Set To Dictionary  ${data}  tenderPeriod  ${value}
    Заповнити "Прийом пропозицій по"  ${date}


Заповнити minimalStep для tender
    ${minimal_step_percent}  random_number  1  3
    ${value}  Create Dictionary  percent=${minimal_step_percent}
    Set To Dictionary  ${data.value}  minimalStep  ${value}
    Заповнити "Мінімальний крок аукціону"   ${minimal_step_percent}


Заповнити title для tender
    ${text}  create_sentence  5
    ${title}  Set Variable  [ТЕСТУВАННЯ] ${text}
    Set To Dictionary  ${data}  title  ${title}
    Заповнити "Узагальнена назва закупівлі"  ${title}


Заповнити title_eng для tender
    ${text_en}  create_sentence  5
    ${title_en}  Set Variable  [ТЕСТУВАННЯ] ${text_en}
    Set To Dictionary  ${data}  title_en  ${title_en}
    Заповнити "Узагальнена назва закупівлі ENG"  ${title_en}


Додати предмет в тендер
    test_esco.Заповнити title для item
    test_esco.Заповнити description_eng для item
    test_esco.Заповнити postalCode для item
    test_esco.Заповнити streetAddress для item
    test_esco.Заповнити locality для item


Заповнити title для item
    ${title}  create_sentence  5
    ${value}  Create Dictionary  title=${title}
    Set To Dictionary  ${data}  item  ${value}
    Заповнити "Назва предмета закупівлі"  ${title}


Заповнити description_eng для item
    ${description_en}  create_sentence  5
    Set To Dictionary  ${data['item']}  description_en  ${description_en}
    Заповнити "Назва предмета закупівлі ENG"  ${description_en}


Заповнити postalCode для item
    ${postal code}  random_number  10000  99999
    Заповнити "Індекс"  ${postal code}
    Set To Dictionary  ${data['item']}  postal code  ${postal code}


Заповнити streetAddress для item
    ${address}  get_some_uuid
    Заповнити "Вулиця"  ${address}
    Set To Dictionary   ${data['item']}  streetAddress  ${address}


Заповнити locality для item
    ${city}  Заповнити "Місто"  Мюнхен
    Set To Dictionary  ${data['item']}  city  ${city}

