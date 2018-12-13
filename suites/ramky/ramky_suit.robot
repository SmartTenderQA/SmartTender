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
	debug
	${data}  create_dict_ramky
	Set Global Variable  ${data}
	test_ramky.Створити тендер
	test_ramky.Отримати дані тендера та зберегти їх у файл


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact_data.json
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
	Перейти у розділ (webclient)  Рамочные соглашения(тестовые)
    Пошук об'єкта у webclient по полю  Узагальнена назва закупівлі  ${data['title']}


Підтвердити прекваліфікацію для доступу до аукціону організатором
    Провести прекваліфікацію учасників


Підготувати учасників для отримання посилання на аукціон
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Close All Browsers
    Start  user1  provider1
    Go to  ${data['tender_href']}


Отримати поcилання на участь в аукціоні для учасників
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	#Дочекатись закінчення прийому пропозицій
	Дочекатися статусу тендера  Аукціон
    Wait Until Keyword Succeeds  180  3  Перевірити отримання ссилки на участь в аукціоні  provider1


Дочекатися закінчення аукціону та підготувати організатора до кваліфікації
    Дочекатися статусу тендера  Кваліфікація
    Close All Browsers
    Start  Bened  tender_owner
	Перейти у розділ (webclient)  Рамочные соглашения(тестовые)
    Пошук об'єкта у webclient по полю  Узагальнена назва закупівлі  ${data['title']}


Провести кваліфікацію та визначити переможців
    Визнати всіх учасників переможцями



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
	Розгорнути лот  1
	Заповнити поле з ціною  1  1
    Додати файл  1
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
    Go Back