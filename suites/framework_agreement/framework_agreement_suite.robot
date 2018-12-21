*** Settings ***
Resource  ../../src/src.robot
#Suite Setup     Авторизуватися організатором
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot

#  robot --consolecolors on -L TRACE:INFO -v hub:None -d test_output -e get_tender suites/framework_agreement/framework_agreement_suite.robot

*** Test Cases ***
Підготувати користувачів
    Додати першого користувача  PPR_OR          tender_owner
    Додати користувача          user1           provider1
    Додати користувача          user2           provider2
    Додати користувача          user3           provider3
    Додати користувача          test_viewer     viewer


Створити тендер
	[Tags]  create_tender
	${data}  create_dict_ramky
	Set Global Variable  ${data}
	Завантажити сесію для  tender_owner
	test_ramky.Створити тендер
	test_ramky.Отримати дані тендера та зберегти їх у файл


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact_data.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Подати заявку на участь в тендері трьома учасниками
	:FOR  ${i}  IN  1  2  3
	\  Завантажити сесію для  provider${i}
	\  Прийняти участь у тендері учасником  provider${i}
    Дочекатись початку періоду перкваліфікації


Відкрити браузер під роллю організатора та знайти тендер
    Завантажити сесію для  tender_owner
	Перейти у розділ (webclient)  Рамочные соглашения(тестовые)
    Пошук об'єкта у webclient по полю  Узагальнена назва закупівлі  ${data['title']}


Підтвердити прекваліфікацію для доступу до аукціону організатором
    Провести прекваліфікацію учасників


Отримати поcилання на участь в аукціоні для учасників
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
	Дочекатися статусу тендера  Аукціон
    Wait Until Keyword Succeeds  5m  3  Перевірити отримання ссилки на участь в аукціоні  provider1


Дочекатися закінчення аукціону та підготувати організатора до кваліфікації
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Кваліфікація


Провести кваліфікацію та визначити переможців
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Завантажити сесію для  tender_owner
	Перейти у розділ (webclient)  Рамочные соглашения(тестовые)
    Пошук об'єкта у webclient по полю  Узагальнена назва закупівлі  ${data['title']}
    Визнати всіх учасників переможцями


Дочекатися учасником статусу тендера "Пропозиції розглянуті"
    Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Пропозиції розглянуті


Заповнити ціни за одиницю номенклатури по кожному переможцю
    Завантажити сесію для  tender_owner
	Перейти у розділ (webclient)  Рамочные соглашения(тестовые)
    Пошук об'єкта у webclient по полю  Узагальнена назва закупівлі  ${data['title']}
    Заповнити ціни за одиницю номенклатури для всіх переможців


Заповнити рамкову угоду та опублікувати її
    Вибрати перший тендер
    Заповнити поля Рамкової угоди
    Натиснути кнопку "Заключить рамочное соглашение"
    Закрити валідаційне вікно (Так/Ні)  Ви впевнені  Так
    Закрити валідаційне вікно (Так/Ні)  Накласти ЕЦП на угоду  Ні
    Закрити валідаційне вікно (Так/Ні)  не накладено актуальний підпис ЕЦП  Так
    Підтвердити активацію рамкової угоди


Переконатись що статус закупівлі "Завершено"
    Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Завершено



*** Keywords ***
Прийняти участь у тендері учасником
    [Arguments]  ${role}
    Завантажити сесію для  ${role}
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


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Location Should Contain  bidder_id=
	Підтвердити повідомлення про умови проведення аукціону
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  30
	Sleep  2
	Element Should Contain  //*[@class="page-header"]//h2  ${data['tender_uaid']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items'][0]['description']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items'][0]['quantity']}
	Element Should Contain  //h4  Вхід на даний момент закритий.
    Go Back
