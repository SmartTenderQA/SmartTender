*** Settings ***
Resource  ../../src/src.robot
Suite Setup     Відкрити вікна для всіх користувачів
Suite Teardown  Suite Postcondition
Test Setup      Check Prev Test Status
Test Teardown   Run Keyword If Test Failed  Capture Page Screenshot


*** Test Cases ***
Створити тендер
	[Tags]  create_tender
	Switch Browser  tender_owner
	Перейти у розділ (webclient)  Публічні закупівлі (тестові)
	Відкрити вікно створення тендеру
  	Вибрати тип процедури  Допорогові закупівлі
  	Заповнити startDate періоду пропозицій
  	Заповнити endDate періоду пропозицій
  	Заповнити endDate періоду обговорення
  	Заповнити amount для tender
  	Заповнити minimalStep для tender
  	Заповнити title для tender
  	Заповнити description для tender
  	Додати предмет в тендер
    Додати документ до тендара власником (webclient)
    Зберегти чернетку
    Оголосити тендер
    Пошук тендеру по title (webclient)  ${data['title']}
    Отримати tender_uaid щойно стореного тендера
    Звебегти дані в файл


If skipped create tender
	[Tags]  get_tender_data
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Знайти тендер усіма користувачами
	[Tags]  create_tender  get_tender_data
	[Template]  Знайти тендер користувачем
	tender_owner
	viewer
	provider1
	provider2


Подати заявку на участь в тендері двома учасниками
	[Tags]  create_tender  get_tender_data
	[Template]  Подати пропозицію учасниками
	provider1
	provider2


Отримати поcилання на участь в аукціоні для учасників
	[Tags]  create_tender  get_tender_data
	[Template]  Отримати посилання на аукціон учасником
	provider1
	provider2


Неможливість отримати поcилання на участь в аукціоні
	[Tags]  create_tender  get_tender_data
	[Template]  Перевірити можливість отримати посилання на аукціон користувачем
	viewer
	tender_owner



*** Keywords ***
Відкрити вікна для всіх користувачів
    Start  Bened  tender_owner
    Set Window Size  1280  1024
    Start  viewer_test  viewer
    Set Window Size  1280  1024
    Start  user1  provider1
    Set Window Size  1280  1024
    Start  user2  provider2
    Set Window Size  1280  1024
    ${data}  Create Dictionary
    Set Global Variable  ${data}


Заповнити endDate періоду обговорення
    ${date}  get_time_now_with_deviation  5  minutes
    ${value}  Create Dictionary  endDate=${date}
    Set To Dictionary  ${data}  enquiryPeriod  ${value}
    Заповнити текстове поле  //*[@data-name="DDM"]//input  ${date}


Заповнити startDate періоду пропозицій
    ${date}  get_time_now_with_deviation  6  minutes
    ${value}  Create Dictionary  startDate=${date}
    Set To Dictionary  ${data}  tenderPeriod  ${value}
    Заповнити текстове поле  //*[@data-name="D_SCH"]//input    ${date}


Заповнити endDate періоду пропозицій
    ${date}  get_time_now_with_deviation  17  minutes
    Set To Dictionary  ${data['tenderPeriod']}  endDate  ${date}
    Заповнити текстове поле  //*[@data-name="D_SROK"]//input     ${date}


Заповнити contact для tender
    ${input}  Set Variable  //*[@data-name="N_KDK_M"]//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="Прізвище"]/ancestor::div[4]//div[@class="dhxcombo_option_text"]/div[1]/div[@class="dhxcombo_cell_text"]
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


Заповнити description для tender
    ${description}  create_sentence  15
    Set To Dictionary  ${data}  description  ${description}
    Заповнити текстове поле  xpath=//*[@data-name="DESCRIPT"]//textarea  ${description}


Додати предмет в тендер
    Заповнити description для item
    Заповнити quantity для item
    Заповнити id для item
    Заповнити unit.name для item
    Заповнити postalCode для item
    Заповнити streetAddress для item
    Заповнити locality для item
    Заповнити endDate для item
    Заповнити startDate для item


Заповнити description для item
    ${description}  create_sentence  5
    ${value}  Create Dictionary  description=${description}
    Set To Dictionary  ${data}  item  ${value}
    Заповнити текстове поле  xpath=(//*[@data-name='KMAT']//input)[1]  ${description}


Заповнити quantity для item
    ${quantity}  random_number  1  1000
    Set To Dictionary  ${data['item']}  quantity  ${quantity}
    Заповнити текстове поле  xpath=//*[@data-name='QUANTITY']//input  ${quantity}


Заповнити id для item
    ${input}  Set Variable  //*[@data-name='MAINCLASSIFICATION']//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="Код класифікації"]/ancestor::div[4]//div[@class="dhxcombo_option_text"]/div[1]/div[@class="dhxcombo_cell_text"]
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    Set To Dictionary  ${data['item']}  id  ${name}


Заповнити unit.name для item
    ${input}  Set Variable  //*[@data-name='EDI']//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="ОВ. Найменування"]/ancestor::div[4]//div[@class="dhxcombo_option_text"]/div[1]/div[@class="dhxcombo_cell_text"]
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    Set To Dictionary  ${data['item']}  unit  ${name}


Заповнити postalCode для item
    ${postal code}  random_number  10000  99999
    Заповнити текстове поле  xpath=//*[@data-name='POSTALCODE']//input  ${postal code}
    Set To Dictionary  ${data['item']}  postal code  ${postal code}


Заповнити streetAddress для item
    ${address}  create_sentence  1
    ${address}  Set Variable  ${address[:-1]}
    Заповнити текстове поле  xpath=//*[@data-name='STREETADDR']//input  ${address}
    Set To Dictionary  ${data['item']}  streetAddress  ${address}


Заповнити locality для item
    ${input}  Set Variable  //*[@data-name='CITY_KOD']//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="Місто"]/ancestor::div[4]//div[@class="dhxcombo_option_text"]/div[1]/div[@class="dhxcombo_cell_text"]
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    Set To Dictionary  ${data['item']}  city  ${name}


Заповнити endDate для item
    ${value}  get_time_now_with_deviation  2  days
    Заповнити текстове поле  xpath=//*[@data-name="DDATETO"]//input  ${value}


Заповнити startDate для item
    ${value}  get_time_now_with_deviation  1  days
    Заповнити текстове поле  xpath=//*[@data-name="DDATEFROM"]//input  ${value}


Отримати tender_uaid щойно стореного тендера
    ${find tender field}  Set Variable  xpath=(//tr[@class='evenRow rowselected'])[1]/td[count(//div[contains(text(), 'Номер тендеру')]/ancestor::td[@draggable]/preceding-sibling::*)+1]
    Scroll Page To Element XPATH  ${find tender field}
    ${uaid}  Get Text  ${find tender field}/a
    Set To Dictionary  ${data}  tender_uaid  ${uaid}


Дочекатись дати початку періоду прийому пропозицій
    Дочекатись дати  ${data['tenderPeriod']['startDate']}
    Дочекатися статусу тендера  Прийом пропозицій


Дочекатись дати закінчення періоду прийому пропозицій
    Дочекатись дати  ${data['tenderPeriod']['endDate']}
    Дочекатися статусу тендера  Аукціон




