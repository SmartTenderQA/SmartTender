*** Settings ***
Resource  ../../src/src.robot
Suite Setup     Авторизуватися організатором
Suite Teardown  Suite Postcondition
Test Setup      Check Prev Test Status
Test Teardown   Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
&{mode}
...         open_trade=Відкриті торги
...         defense=Переговорна процедура для потреб оборони


#  robot --consolecolors on -L TRACE:INFO -d test_output -v type:$type -i create_tender suites/get_auction_href/test_open_trade_get_auction_href.robot
*** Test Cases ***
Створити тендер
	[Tags]  create_tender
	Switch Browser  tender_owner
	Перейти у розділ (webclient)  Публічні закупівлі (тестові)
	Відкрити вікно створення тендеру
  	Вибрати тип процедури  ${mode.${type}}
  	Заповнити endDate періоду пропозицій
  	Заповнити amount для tender
  	Заповнити minimalStep для tender
  	Заповнити title для tender
  	Заповнити description для tender
  	Додати предмет в тендер
    Додати документ до тендара власником (webclient)
    Зберегти чернетку
    Оголосити закупівлю
    Пошук тендеру по title (webclient)  ${data['title']}
    Отримати tender_uaid та tender_href щойно стореного тендера
    Звебегти дані в файл


If skipped create tender
	[Tags]  get_tender_data
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Підготувати учасників до участі в тендері
    [Tags]  create_tender  get_tender_data
    Close All Browsers
    Start  user1  provider1
    Start  user2  provider2


Подати заявку на участь в тендері двома учасниками
	[Tags]  create_tender  get_tender_data
	Прийняти участь у тендері учасником  provider1
	Прийняти участь у тендері учасником  provider2


Отримати поcилання на участь в аукціоні для учасників
	[Tags]  create_tender  get_tender_data
	Дочекатись закінчення прийому пропозицій
	Дочекатися статусу тендера  Аукціон
    Перевірити отримання ссилки на участь в аукціоні  provider1


Підготувати користувачів для отримання ссилки на аукціон
    [Tags]  create_tender  get_tender_data
    Close All Browsers
    Start  viewer_test  viewer
    Start  Bened  tender_owner
    Start  user3  provider3


Неможливість отримати поcилання на участь в аукціоні
	[Tags]  create_tender  get_tender_data
	[Template]  Перевірити можливість отримати посилання на аукціон користувачем
	viewer
	tender_owner
	provider3



*** Keywords ***
Авторизуватися організатором
    Start  Bened  tender_owner
    ${data}  Create Dictionary
    Set Global Variable  ${data}


Заповнити endDate періоду пропозицій
    ${date}  get_time_now_with_deviation  22  minutes
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
    ${selector}  Set Variable  //*[text()="Код класифікації"]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    Set To Dictionary  ${data['item']}  id  ${name}


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
    ${address}  create_sentence  1
    ${address}  Set Variable  ${address[:-1]}
    Заповнити текстове поле  xpath=//*[@data-name='STREETADDR']//input  ${address}
    Set To Dictionary  ${data['item']}  streetAddress  ${address}


Заповнити locality для item
    ${input}  Set Variable  //*[@data-name='CITY_KOD']//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="Місто"]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    Set To Dictionary  ${data['item']}  city  ${name}


Заповнити endDate для item
    ${value}  get_time_now_with_deviation  2  days
    Заповнити текстове поле  xpath=//*[@data-name="DDATETO"]//input  ${value}


Заповнити startDate для item
    ${value}  get_time_now_with_deviation  1  days
    Заповнити текстове поле  xpath=//*[@data-name="DDATEFROM"]//input  ${value}


Прийняти участь у тендері учасником
    [Arguments]  ${role}
    Switch Browser  ${role}
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Прийом пропозицій
    Sleep  3m
    Подати пропозицію учасником


Подати пропозицію учасником
	Перевірити кнопку подачі пропозиції
	Заповнити поле з ціною  1  1
    Додати файл  1
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
    Go Back


Перевірити отримання ссилки на участь в аукціоні
    [Arguments]  ${role}
    Switch Browser  ${role}
    Натиснути кнопку "До аукціону"
	${auction_participate_href}  Отримати URL для участі в аукціоні
	Перейти та перевірити сторінку участі в аукціоні  ${auction_participate_href}


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Підтвердити повідомлення про умови проведення аукціону
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  30
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
	Go to  ${data['tender_href']}
	${auction_participate_href}  Run Keyword And Expect Error  *  Run Keywords
	...  Натиснути кнопку "До аукціону"
	...  AND  Отримати URL для участі в аукціоні