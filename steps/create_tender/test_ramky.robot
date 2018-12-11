*** Keywords ***
Створити тендер
    Switch Browser  tender_owner
	Перейти у розділ (webclient)  Рамочные соглашения(тестовые)
	Натиснути додати(F7)  Додавання. Тендери
  	create_tender.Вибрати тип процедури  Укладання рамкової угоди
    test_ramky.Заповнити кількість учасників для укладання РУ
    test_ramky.Заповнити "Срок рамкової угоди"
  	test_ramky.Заповнити endDate періоду пропозицій
  	test_ramky.Заповнити amount для lot
  	test_ramky.Заповнити minimalStep для lot
  	test_ramky.Заповнити title для tender
  	test_ramky.Заповнити description для tender
  	test_ramky.Заповнити title_eng для tender
  	test_ramky.Додати предмет в тендер
    Додати документ до тендара власником (webclient)
    Зберегти чернетку
    Оголосити закупівлю


#########################################################
#	                  Keywords							#
#########################################################
Заповнити кількість учасників для укладання РУ
    ${maxAwardsCount}  Set Variable  3
    Заповнити "Кількість переможців"  ${maxAwardsCount}
    ${data['maxAwardsCount']}  Set Variable  ${maxAwardsCount}


Заповнити "Срок рамкової угоди"
    ${agreementDuration}  Set Variable  6
    Заповнити "Срок рамкової угоди" місяців  ${agreementDuration}
    ${data['agreementDuration']}  Set Variable  ${agreementDuration}


Заповнити endDate періоду пропозицій
    ${date}  get_time_now_with_deviation  100  minutes
    Заповнити "Прийом пропозицій по"  ${date}
    ${data['tenderPeriod'][endDate]}  Set Variable  ${date}


Заповнити amount для lot
    ${amount}  random_number  100000  100000000
    Заповнити "Очікувана вартість закупівлі" для лоту  ${amount}
    ${data['value']['amount']}  Set Variable  ${amount}


Заповнити minimalStep для lot
    ${minimal_step_percent}  random_number  1  5
    ${amount}  Заповнити "Мінімальний крок аукціону" для лоту   ${minimal_step_percent}
    ${data['minimalStep']['amount']}  Set Variable  ${amount}


Заповнити title для tender
    ${text}  create_sentence  5
    ${title}  Set Variable  [ТЕСТУВАННЯ] ${text}
    Заповнити "Узагальнена назва закупівлі"   ${title}
    ${data['title']}  Set Variable  ${title}


Заповнити description для tender
    ${description}  create_sentence  15
    Заповнити "Примітки до закупівлі"  ${description}
    ${data['description']}  Set Variable  ${description}


Заповнити title_eng для tender
    ${text_en}  create_sentence  5
    ${title_en}  Set Variable  [ТЕСТУВАННЯ] ${text_en}
    Заповнити "Узагальнена назва закупівлі ENG"  ${title_en}
    ${data['title_en']}  Set Variable  ${title_en}


Додати предмет в тендер
    webclient_elements.Натиснути додати (додавання предмету)
    test_ramky.Заповнити description для item
    test_ramky.Заповнити description_eng для item
    test_ramky.Заповнити quantity для item
    test_ramky.Заповнити id для item
    test_ramky.Заповнити unit.name для item
    test_ramky.Заповнити postalCode для item
    test_ramky.Заповнити streetAddress для item
    test_ramky.Заповнити locality для item
    test_ramky.Заповнити endDate для item
    test_ramky.Заповнити startDate для item


Заповнити description для item
    ${description}  create_sentence  5
    Заповнити "Назва предмета закупівлі"  ${description}
    ${data['items']['description']}  Set Variable  ${description}


Заповнити description_eng для item
    ${description_en}  create_sentence  5
    Заповнити "Назва предмета закупівлі ENG"  ${description_en}
    ${data['items']['description_en']}  Set Variable  ${description_en}


Заповнити quantity для item
    ${quantity}  random_number  1  1000
    Заповнити "Об'єм постачання"  ${quantity}
    ${data['items']['quantity ']}  Set Variable  ${quantity}


Заповнити id для item
    ${value}    Заповнити "Класифікація"
    ${id}       Evaluate  re.search(r'(?P<id>\\d.+)', u'${value}').group('id')  re
    ${description}  Evaluate  re.search(r'(?P<description>\\D.+) ', u'${value}').group('description')  re
    ${data['items']['classification']['id']}  Set Variable  ${id}
    ${data['items']['classification']['description']}  Set Variable  ${description}


Заповнити unit.name для item
    ${unit name}  Заповнити "Одиниця виміру"
    ${data['items']['unit']['name']}  Set Variable  ${unit name}


Заповнити postalCode для item
    ${postal code}  random_number  10000  99999
    Заповнити "Індекс"  ${postal code}
    ${data['items']['deliveryAddress']['postalCode']}  Set Variable  ${postal code}


Заповнити streetAddress для item
    ${street}  get_some_uuid
    Заповнити "Вулиця"  ${street}
    ${data['items']['deliveryAddress']['streetAddress']}  Set Variable  ${street}


Заповнити locality для item
    ${city}  Заповнити "Місто"  Мюнхен
    ${data['items']['deliveryAddress']['locality']}  Set Variable  ${city}


Заповнити startDate для item
    ${value}  get_time_now_with_deviation  1  days
    Заповнити "Строк поставки з"  ${value}
    ${data['items']['deliveryDate']['startDate']}  Set Variable  ${value}

Заповнити endDate для item
    ${value}  get_time_now_with_deviation  2  days
    Заповнити "Строк поставки по"  ${value}
    ${data['items']['deliveryDate']['endDate']}  Set Variable  ${value}
