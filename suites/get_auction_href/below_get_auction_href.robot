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
	Перейти у розділ публічні закупівлі (тестові)
	Відкрити вікно створення тендеру
  	Вибрати тип процедури  Допорогові закупівлі
  	Заповнити startDate періоду пропозицій
  	Заповнити endDate періоду пропозицій
  	Заповнити endDate періоду обговорення
  	Заповнити amount для tender
  	Заповнити minimalStep для tender
  	Заповнити contact для tender
  	Заповнити title для tender
  	Заповнити description для tender
  	Додати предмет в тендер
    Додати документ до тендара власником (webclient)
    Зберегти чернетку
    Оголосити тендер
    Підтвердити повідомлення про перевірку публікації документу за необхідністю
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
    Start  prod_owner  tender_owner
    Set Window Size  1280  1024
    Start  viewer_prod  viewer
    Set Window Size  1280  1024
    Start  prod_provider1  provider1
    Set Window Size  1280  1024
    Start  prod_provider2  provider2
    Set Window Size  1280  1024
    ${data}  Create Dictionary
    Set Global Variable  ${data}


Знайти тендер користувачем
	[Arguments]  ${role}
	Switch Browser  ${role}
	Sleep  2
	Відкрити сторінку тестових торгів
	Знайти тендер по ID  ${data['tender_uaid']}


Звебегти дані в файл
	${json}  conver dict to json  ${data}
	Create File  ${OUTPUTDIR}/artifact.json  ${json}


Заповнити Поле
    [Arguments]  ${selector}  ${text}
    Wait Until Page Contains Element  ${selector}
    Click Element  ${selector}
    Sleep  .5
    Input Text  ${selector}  ${text}
    Sleep  .5
    Press Key  ${selector}  \\09
    Sleep  1


Отримати посилання на аукціон учасником
    [Arguments]  ${role}
    Switch Browser  ${role}
	Дочекатись дати закінчення періоду прийому пропозицій
    ${auction_href}  Отримати посилання на участь в аукціоні
	Перейти та перевірити сторінку участі в аукціоні  ${auction_href}




Подати пропозицію учасниками
    [Arguments]  ${role}
    Switch Browser  ${role}
	Дочекатись дати початку періоду прийому пропозицій
    Перевірити кнопку подачі пропозиції
	Заповнити поле з ціною  1  1
	Подати пропозицію
    Go Back


Перейти у розділ публічні закупівлі (тестові)
    Click Element  xpath=(//*[@title="Публічні закупівлі (тестові)"])[1]
    Дочекатись закінчення загрузки сторінки(webclient)
    Wait Until Keyword Succeeds  120  3  Element Should Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору тендерів')]
    Wait Until Keyword Succeeds  20  2  Click Element  xpath=//*[contains(text(), 'OK')]
    Wait Until Keyword Succeeds  120  3  Element Should Not Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору тендерів')]


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
    ${value}  get_time_now_with_deviation  17  minutes
    ${new_date}  get_only_numbers  ${value}
    Set To Dictionary  ${data['tenderPeriod']}  endDate  ${value}
    Заповнити Поле  //*[@data-name="D_SROK"]//input    ${new_date}


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
    Заповнити Поле  xpath=(//*[@data-name='KMAT']//input)[1]  ${description}


Заповнити quantity для item
    ${quantity}  random_number  1  1000
    Set To Dictionary  ${data['item']}  quantity  ${quantity}
    Заповнити Поле  xpath=//*[@data-name='QUANTITY']//input  ${quantity}


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
    Заповнити Поле  xpath=//*[@data-name='POSTALCODE']//input  ${postal code}
    Set To Dictionary  ${data['item']}  postal code  ${postal code}


Заповнити streetAddress для item
    ${address}  create_sentence  1
    ${address}  Set Variable  ${address[:-1]}
    Заповнити Поле  xpath=//*[@data-name='STREETADDR']//input  ${address}
    Set To Dictionary  ${data['item']}  streetAddress  ${address}


Заповнити locality для item
    ${input}  Set Variable  //*[@data-name='CITY_KOD']//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="Місто"]/ancestor::div[4]//div[@class="dhxcombo_option_text"]/div[1]/div[@class="dhxcombo_cell_text"]
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    Set To Dictionary  ${data['item']}  city  ${name}


Заповнити endDate для item
    ${value}  get_time_now_with_deviation  2  days
    ${new_date}  get_only_numbers  ${value}
    Заповнити Поле  xpath=//*[@data-name="DDATETO"]//input  ${new_date}


Заповнити startDate для item
    ${value}  get_time_now_with_deviation  1  days
    ${new_date}  get_only_numbers  ${value}
    Заповнити Поле  xpath=//*[@data-name="DDATEFROM"]//input  ${new_date}


Отримати tender_uaid щойно стореного тендера
    ${find tender field}  Set Variable  xpath=(//tr[@class='evenRow rowselected'])[1]/td[count(//div[contains(text(), 'Номер тендеру')]/ancestor::td[@draggable]/preceding-sibling::*)+1]
    Scroll Page To Element XPATH  ${find tender field}
    ${uaid}  Get Text  ${find tender field}/a
    Set To Dictionary  ${data}  tender_uaid  ${uaid}


Дочекатись дати
    [Arguments]  ${date}
    ${sleep}=  wait_to_date  ${date}
    Sleep  ${sleep}


Дочекатись дати початку періоду прийому пропозицій
    Дочекатись дати  ${data['tenderPeriod']['startDate']}
    wait until keyword succeeds  20m  2m  Дочекатись статусу тендера  Прийом пропозицій


Дочекатись дати закінчення періоду прийому пропозицій
    Дочекатись дати  ${data['tenderPeriod']['endDate']}
    wait until keyword succeeds  20m  2m  Дочекатись статусу тендера  Аукціон


Дочекатись статусу тендера
    [Arguments]  ${tender status}
    Reload Page
    Wait Until Element Is Visible  //*[@data-qa="status"]  20
    ${status}  Get Text  //*[@data-qa="status"]
    Run Keyword If  '${status}' != '${tender status}'  Run Keywords
    ...  Sleep  1m
    ...  AND  Дочекатись статусу тендера  ${tender status}


Отримати посилання на участь в аукціоні
	Reload Page
	Натиснути кнопку  До аукціону
	Натиснути кнопку  Взяти участь в аукціоні
	${auction_href}  Отримати посилання
	[Return]  ${auction_href}


Натиснути кнопку
	[Arguments]  ${text}
	${selector}  Set Variable  //button[@type="button" and contains(., "${text}")]
	Wait Until Page Contains Element  ${selector}
	Click Element  ${selector}


Отримати посилання
	${selector}  Set Variable  //a[@href and contains(., "До аукціону")]
	Wait Until Page Contains Element  ${selector}  60
	${auction_href}  Get Element Attribute  ${selector}  href
	[Return]  ${auction_href}


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  120
	Location Should Contain  bidder_id=
	Sleep  2
	Element Should Contain  //*[@class="page-header"]//h2  ${data['tender_uaid']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['description']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['quantity']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['unit']}
	Element Should Contain  //h4  Вхід на даний момент закритий.


Перевірити можливість отримати посилання на аукціон користувачем
	[Arguments]  ${role}
	Switch Browser  ${role}
	Reload Page
	Run Keyword And Expect Error  *  Отримати посилання на участь в аукціоні
