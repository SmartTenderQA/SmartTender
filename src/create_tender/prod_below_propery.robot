*** Keywords ***
Створити тендер
	Switch Browser  tender_owner
	Перейти у розділ (webclient)  Публічні закупівлі (тестові)
	Відкрити вікно створення тендеру
  	Вибрати тип процедури  Допорогові закупівлі
  	prod_below_propery.Заповнити startDate періоду пропозицій
  	prod_below_propery.Заповнити endDate періоду пропозицій
  	prod_below_propery.Заповнити endDate періоду обговорення
  	prod_below_propery.Заповнити amount для tender
  	prod_below_propery.Заповнити minimalStep для tender
  	prod_below_propery.Заповнити contact для tender
  	prod_below_propery.Заповнити title для tender
  	prod_below_propery.Заповнити description для tender
  	prod_below_propery.Додати предмет в тендер
    Додати документ до тендара власником (webclient)
    Зберегти чернетку
    Оголосити тендер
    Пошук тендеру по title (webclient)  ${data['title']}
    Отримати tender_uaid та tender_href щойно стореного тендера
    Звебегти дані в файл


#########################################################
#	                  Keywords							#
#########################################################
Заповнити endDate періоду обговорення
    ${value}  get_time_now_with_deviation  5  minutes
    ${new_date}  get_only_numbers  ${value}
    ${value}  Create Dictionary  endDate=${value}
    Set To Dictionary  ${data}  enquiryPeriod  ${value}
    Заповнити Поле  //*[@data-name="DDM"]//input  ${new_date}


Заповнити startDate періоду пропозицій
    ${value}  get_time_now_with_deviation  6  minutes
    ${new_date}  get_only_numbers  ${value}
    ${value}  Create Dictionary  startDate=${value}
    Set To Dictionary  ${data}  tenderPeriod  ${value}
    Заповнити Поле  //*[@data-name="D_SCH"]//input    ${new_date}


Заповнити endDate періоду пропозицій
    ${value}  get_time_now_with_deviation  22  minutes
    ${new_date}  get_only_numbers  ${value}
    Set To Dictionary  ${data['tenderPeriod']}  endDate  ${value}
    Заповнити Поле  //*[@data-name="D_SROK"]//input    ${new_date}


Заповнити contact для tender
    ${input}  Set Variable  //*[@data-name="N_KDK_M"]//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="Прізвище"]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    ${value}  Create Dictionary  name=${name}
    Set To Dictionary  ${data}  contactPerson  ${value}


Заповнити amount для tender
    ${amount}  random_number  100000  100000000
    ${value}  Create Dictionary  amount=${amount}
    Set To Dictionary  ${data}  value  ${value}
    Заповнити Поле  xpath=//*[@data-name="INITAMOUNT"]//input   ${amount}


Заповнити minimalStep для tender
    ${minimal_step_percent}  random_number  1  5
    ${value}  Create Dictionary  percent=${minimal_step_percent}
    Set To Dictionary  ${data.value}  minimalStep  ${value}
    Заповнити Поле  xpath=//*[@data-name="MINSTEP_PERCENT"]//input   ${minimal_step_percent}


Заповнити title для tender
    ${text}  create_sentence  5
    ${title}  Set Variable  [ТЕСТУВАННЯ] ${text}
    Set To Dictionary  ${data}  title  ${title}
    Заповнити Поле  xpath=//*[@data-name="TITLE"]//input   ${title}


Заповнити description для tender
    ${description}  create_sentence  15
    Set To Dictionary  ${data}  description  ${description}
    Заповнити Поле  xpath=//*[@data-name="DESCRIPT"]//textarea  ${description}


Додати предмет в тендер
    prod_below_propery.Заповнити description для item
    prod_below_propery.Заповнити quantity для item
    prod_below_propery.Заповнити id для item
    prod_below_propery.Заповнити unit.name для item
    prod_below_propery.Заповнити postalCode для item
    prod_below_propery.Заповнити streetAddress для item
    prod_below_propery.Заповнити locality для item
    prod_below_propery.Заповнити endDate для item
    prod_below_propery.Заповнити startDate для item


Заповнити description для item
    ${description}  create_sentence  5
    ${value}  Create Dictionary  description=${description}
    Set To Dictionary  ${data}  item  ${value}
    Заповнити Поле  xpath=(//*[@data-name='KMAT']//input)[1]  ${description}


Заповнити quantity для item
    ${quantity}  random_number  1  1000
    Set To Dictionary  ${data['item']}  quantity  ${quantity}
    Заповнити Поле  xpath=//*[@data-name='QUANTITY']//input  ${quantity}


Заповнити id для item
    ${input}  Set Variable  //*[@data-name='MAINCLASSIFICATION']//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="Код класифікації"]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
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
    Заповнити Поле  xpath=//*[@data-name='POSTALCODE']//input  ${postal code}
    Set To Dictionary  ${data['item']}  postal code  ${postal code}


Заповнити streetAddress для item
    ${address}  create_sentence  1
    ${address}  Set Variable  ${address[:-1]}
    Заповнити Поле  xpath=//*[@data-name='STREETADDR']//input  ${address}
    Set To Dictionary  ${data['item']}  streetAddress  ${address}


Заповнити locality для item
    ${input}  Set Variable  //*[@data-name='CITY_KOD']//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="Місто"]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    ${name}  Get Element Attribute  ${input}  value
    Set To Dictionary  ${data['item']}  city  ${name}


Заповнити endDate для item
    ${value}  get_time_now_with_deviation  2  days
    ${new_date}  get_only_numbers  ${value}
    Заповнити Поле  xpath=//*[@data-name="DDATETO"]//input  ${new_date}


Заповнити startDate для item
    ${value}  get_time_now_with_deviation  1  days
    ${new_date}  get_only_numbers  ${value}
    Заповнити Поле  xpath=//*[@data-name="DDATEFROM"]//input  ${new_date}