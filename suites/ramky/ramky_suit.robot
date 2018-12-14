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
    Підтвердити організатором формування протоколу розгляду пропозицій


Підготувати учасників для отримання посилання на аукціон
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Close All Browsers
    Start  user1  provider1
    Go to  ${data['tender_href']}


Отримати поcилання на участь в аукціоні для учасників
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
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


Дочекатися учасником статусу тендера "Пропозиції розглянуті"
    Close All Browsers
    Start  user1  provider1
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Пропозиції розглянуті


Заповнити ціни за одиницю номенклатури по кожному переможцю
    Close All Browsers
    Start  Bened  tender_owner
	Перейти у розділ (webclient)  Рамочные соглашения(тестовые)
    Пошук об'єкта у webclient по полю  Узагальнена назва закупівлі  ${data['title']}
    Заповнити ціни за одиницю номенклатури для всіх переможців


Заключити рамкову угоду
    Вибрати перший тендер
    Натиснути кнопку "Коригувати рамкову угоду"
    Заповнити поля Рамкової угоди
    Натиснути OkButton
    Закрити валідаційне вікно (Так/Ні)  Ви впевнені  Так
    Закрити валідаційне вікно (Так/Ні)  Накласти ЕЦП на угоду  Ні
    Закрити валідаційне вікно (Так/Ні)  не накладено актуальний підпис ЕЦП  Так
    Wait Until Page Contains  Рамкову угоду успішно активовано  10



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


Перевірити отримання ссилки на участь в аукціоні
    [Arguments]  ${role}
    Завантажити сесію для  ${role}
    Go To  ${data['tender_href']}
    Натиснути кнопку "До аукціону"
	${auction_participate_href}  Отримати URL для участі в аукціоні
	Wait Until Keyword Succeeds  60  3  Перейти та перевірити сторінку участі в аукціоні  ${auction_participate_href}


Заповнити поля Рамкової угоди
    ${id}  random number  100000  999999
    Заповнити текстове поле  (//*[@data-type="TextBox"])[1]//input  ${id}
    ${signDate}  get_time_now_with_deviation  0  days
    Заповнити текстове поле  (//*[@data-type="DateEdit"])[1]//input  ${signDate}
    ${startDate}  get_time_now_with_deviation  2  days
    Заповнити текстове поле  (//*[@data-type="DateEdit"])[2]//input  ${startDate}
    ${endDate}  get_time_now_with_deviation  60  days
    Заповнити текстове поле  (//*[@data-type="DateEdit"])[3]//input  ${endDate}