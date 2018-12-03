*** Keywords ***
Створити тендер
	Switch Browser  tender_owner
	Перейти у розділ (webclient)  Публічні закупівлі (тестові)
	Натиснути додати(F7)  Додавання. Тендери
  	create_tender.Вибрати тип процедури  Відкриті торги з публікацією англійською мовою
  	test_open_eu.Заповнити endDate періоду пропозицій
  	test_open_eu.Заповнити amount для tender
  	test_open_eu.Заповнити minimalStep для tender
  	test_open_eu.Заповнити title для tender
  	test_open_eu.Заповнити title_eng для tender
  	test_open_eu.Заповнити description для tender
  	test_open_eu.Додати предмет в тендер
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
    Заповнити текстове поле  //*[@data-name="D_SROK"]//input     ${date}


Заповнити contact для tender
    ${input}  Set Variable  //*[@data-name="N_KDK_M"]//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="Прізвище"]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    ${value}  Create Dictionary  name=${name}
    ${contactPoint}  Create Dictionary  contactPerson=${value}
    Set To Dictionary  ${data}  procuringEntity  ${contactPoint}


Заповнити amount для tender
    ${amount}  random_number  100000  100000000
    ${value}  Create Dictionary  amount=${amount}
    Set To Dictionary  ${data}  value  ${value}
    Заповнити текстове поле  xpath=//*[@data-name="INITAMOUNT"]//input   ${amount}


Заповнити minimalStep для tender
    ${minimal_step_percent}  random_number  1  5
    ${value}  Create Dictionary  percent=${minimal_step_percent}
    Set To Dictionary  ${data.value}  minimalStep  ${value}
    Заповнити текстове поле  xpath=//*[@data-name="MINSTEP_PERCENT"]//input   ${minimal_step_percent}


Заповнити title для tender
    ${text}  create_sentence  5
    ${title}  Set Variable  [ТЕСТУВАННЯ] ${text}
    Set To Dictionary  ${data}  title  ${title}
    Заповнити текстове поле  xpath=//*[@data-name="TITLE"]//input   ${title}


Заповнити title_eng для tender
    ${text_en}  create_sentence  5
    ${title_en}  Set Variable  [ТЕСТУВАННЯ] ${text_en}
    Set To Dictionary  ${data}  title_en  ${title_en}
    Заповнити текстове поле  xpath=//*[@data-name="TITLE_EN"]//input   ${title_en}


Заповнити description для tender
    ${description}  create_sentence  15
    Set To Dictionary  ${data}  description  ${description}
    Заповнити текстове поле  xpath=//*[@data-name="DESCRIPT"]//textarea  ${description}


Додати предмет в тендер
    test_open_eu.Заповнити title для item
    test_open_eu.Заповнити description_eng для item
    test_open_eu.Заповнити quantity для item
    test_open_eu.Заповнити id для item
    test_open_eu.Заповнити unit.name для item
    test_open_eu.Заповнити postalCode для item
    test_open_eu.Заповнити streetAddress для item
    test_open_eu.Заповнити locality для item
    test_open_eu.Заповнити endDate для item
    test_open_eu.Заповнити startDate для item


Заповнити title для item
    ${description}  create_sentence  5
    ${value}  Create Dictionary  description=${description}
    Set To Dictionary  ${data}  item  ${value}
    Заповнити текстове поле  xpath=(//*[@data-name='KMAT']//input)[1]  ${description}


Заповнити description_eng для item
    ${description_en}  create_sentence  5
    Set To Dictionary  ${data['item']}  description_en  ${description_en}
    Заповнити текстове поле  xpath=//*[@data-name="RESOURSENAME_EN"]//input[1]  ${description_en}


Заповнити quantity для item
    ${quantity}  random_number  1  1000
    Set To Dictionary  ${data['item']}  quantity  ${quantity}
    Заповнити текстове поле  xpath=//*[@data-name='QUANTITY']//input  ${quantity}


Заповнити id для item
    ${input}  Set Variable  //*[@data-name='MAINCLASSIFICATION']//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="Код класифікації"]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    Sleep  1
    ${name}  Get Element Attribute  ${input}  value
    ${id}       Evaluate  re.search(r'(?P<id>\\d.+)', u'${name}').group('id')  re
    ${id title}  Evaluate  re.search(r'(?P<title>\\D.+) ', u'${name}').group('title')  re
    Set To Dictionary  ${data['item']}  id  ${id}
    Set To Dictionary  ${data['item']}  id title  ${id title}


Заповнити unit.name для item
    ${input}  Set Variable  //*[@data-name='EDI']//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="ОВ. Найменування"]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    Set To Dictionary  ${data['item']}  unit  ${name}


Заповнити postalCode для item
    ${postal code}  random_number  10000  99999
    Заповнити текстове поле  xpath=//*[@data-name='POSTALCODE']//input  ${postal code}
    Set To Dictionary  ${data['item']}  postal code  ${postal code}


Заповнити streetAddress для item
    ${address}  get_some_uuid
    Заповнити текстове поле  xpath=//*[@data-name='STREETADDR']//input  ${address}
    Set To Dictionary  ${data['item']}  streetAddress  ${address}


Заповнити locality для item
    ${input}  Set Variable  //*[@data-name='CITY_KOD']//input[not(contains(@type,'hidden'))]
    ${name}  Set Variable  Мюнхен
    Заповнити текстове поле  ${input}  ${name}
    ${name}  Get Element Attribute  ${input}  value
    Set To Dictionary  ${data['item']}  city  ${name}


Заповнити endDate для item
    ${value}  get_time_now_with_deviation  2  days
    Заповнити текстове поле  xpath=//*[@data-name="DDATETO"]//input  ${value}


Заповнити startDate для item
    ${value}  get_time_now_with_deviation  1  days
    Заповнити текстове поле  xpath=//*[@data-name="DDATEFROM"]//input  ${value}