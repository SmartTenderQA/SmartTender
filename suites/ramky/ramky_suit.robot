*** Settings ***
Resource  ../../src/src.robot
Suite Setup     Авторизуватися організатором
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot

#  robot --consolecolors on -L TRACE:INFO -d test_output -e get_tender suites/ramky/ramky_suit.robot

*** Test Cases ***
Створити тендер
	[Tags]  create_tender
	${data}  create_dict_ramky
	Set Global Variable  ${data}
	test_ramky.Створити тендер


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


Подати заявку на участь в тендері трьома учасниками
	Close All Browsers
	:FOR  ${i}  IN  1  2  3
	\  Start  user${i}  provider${i}
	\  Прийняти участь у тендері учасником  provider${i}
	\  Close All Browsers


Підготувати користувача та дочекатись початку періоду перкваліфікації
    Start  user1  provider1
    Go to  ${data['tender_href']}
    Дочекатись початку періоду перкваліфікації


Відкрити браузер під роллю організатора та знайти тендер
    Close All Browsers
    Start  Bened  tender_owner
	Перейти у розділ (webclient)  Конкурентний діалог(тестові)
    Пошук об'єкта у webclient по полю  Узагальнена назва закупівлі  ${data['title']}


Підтвердити прекваліфікацію для доступу до аукціону організатором
    Підтвердити прекваліфікацію учасників


Перейти до стадії аукціон
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Wait Until Keyword Succeeds  10m  10s  Перейти до стадії закупівлі (webclient)  Аукціон
    debug





*** Keywords ***
Авторизуватися організатором
    Start  Bened  tender_owner


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