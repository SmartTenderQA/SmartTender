*** Settings ***
Resource  ../../src/src.robot
Suite Setup     Створити словник  data
Suite Teardown  Close All Browsers
#Test Setup      Stop The Whole Test Execution If Previous Test Failed
Test Teardown   Run Keyword If Test Failed  Capture Page Screenshot  ${OUTPUTDIR}/my_screen{index}.png


#  robot --consolecolors on -L TRACE:INFO -d test_output -e get_tender suites/get_auction_href/test_open_eu_get_auction_href.robot
*** Test Cases ***
Створити тендер
	[Tags]  create_tender
	Авторизуватися організатором
	test_open_eu.Створити тендер


Отримати дані тендера та зберегти їх у файл
    [Tags]  create_tender
	Пошук об'єкта у webclient по полю  Узагальнена назва закупівлі  ${data['title']}
    ${tender_uaid}  Отримати tender_uaid вибраного тендера
    ${tender_href}  Отримати tender_href вибраного тендера
    Set To Dictionary  ${data}  tender_uaid  ${tender_uaid}
    Set To Dictionary  ${data}  tender_href  ${tender_href}
    Log  ${tender_href}  WARN
    Зберегти словник у файл  ${data}  data
    Close All Browsers


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Підготувати учасників до участі в тендері
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Close All Browsers
    Start  user1  provider1
    Start  user2  provider2


Перевірка відображення даних створеного тендера на сторінці
    [Tags]  view
    Перевірка відображення даних тендера на сторінці  provider1


Подати заявку на участь в тендері двома учасниками
	Прийняти участь у тендері учасником  provider1
	Прийняти участь у тендері учасником  provider2
	Close All Browsers


Підготувати користувача та дочекатись початку періоду перкваліфікації
    Start  user1  provider1
    Go to  ${data['tender_href']}
    Дочекатись початку періоду перкваліфікації


Відкрити браузер під роллю організатора та знайти тендер
    Close All Browsers
    Start  Bened  tender_owner
	Перейти у розділ (webclient)  Конкурентний діалог(тестові)
    Пошук об'єкта у webclient по полю  Узагальнена назва закупівлі  ${data['title']}


Підтвердити прекваліфікацію всіх учасників
    Підтвердити прекваліфікацію учасників


Підготувати учасників для отримання посилання на аукціон
    Close All Browsers
    Start  user1  provider1
    Go to  ${data['tender_href']}


Отримати поcилання на участь в аукціоні для учасників
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Дочекатись закінчення прийому пропозицій
	Дочекатися статусу тендера  Аукціон
    Перевірити отримання ссилки на участь в аукціоні  provider1


Підготувати користувачів для отримання ссилки на аукціон
    Close All Browsers
    Start  test_viewer  viewer
    Start  Bened  tender_owner
    Start  user3  provider3


Неможливість отримати поcилання на участь в аукціоні
	[Template]  Перевірити можливість отримати посилання на аукціон користувачем
	viewer
	tender_owner
	provider3



*** Keywords ***
Авторизуватися організатором
    Start  Bened  tender_owner


Перевірка відображення даних тендера на сторінці
    [Arguments]  ${role}
    Switch Browser  ${role}
    Go to  ${data['tender_href']}
    Перевірити коректність даних на сторінці  ['title']
    Перевірити коректність даних на сторінці  ['description']
    Перевірити коректність даних на сторінці  ['tender_uaid']
    Перевірити коректність даних на сторінці  ['item']['title']
    Перевірити коректність даних на сторінці  ['item']['city']
    Перевірити коректність даних на сторінці  ['item']['streetAddress']
    Перевірити коректність даних на сторінці  ['item']['postal code']
    Перевірити коректність даних на сторінці  ['item']['id']
    Перевірити коректність даних на сторінці  ['item']['id title']
    Перевірити коректність даних на сторінці  ['item']['unit']
    Перевірити коректність даних на сторінці  ['item']['quantity']
    Перевірити коректність даних на сторінці  ['tenderPeriod']['endDate']
    Перевірити коректність даних на сторінці  ['value']['amount']
    Перевірити коректність даних на сторінці  ['value']['minimalStep']['percent']


Прийняти участь у тендері учасником
    [Arguments]  ${role}
    Switch Browser  ${role}
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Прийом пропозицій
    Run Keyword If  '${role}' == 'provider1'  Sleep  3m
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
	${auction_participate_href}  Wait Until Keyword Succeeds  60  3  Отримати URL для участі в аукціоні
	Wait Until Keyword Succeeds  60  3  Перейти та перевірити сторінку участі в аукціоні  ${auction_participate_href}


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Location Should Contain  bidder_id=
	Підтвердити повідомлення про умови проведення аукціону
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  30
	Sleep  2
	Element Should Contain  //*[@class="page-header"]//h2  ${data['tender_uaid']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['title']}
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
