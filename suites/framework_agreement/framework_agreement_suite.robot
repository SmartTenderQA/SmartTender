*** Settings ***
Resource   ../../src/src.robot

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
    procurement_page_keywords.Дочекатись початку періоду перкваліфікації


Відкрити браузер під роллю організатора та знайти тендер
    Завантажити сесію для  tender_owner
	desktop.Перейти у розділ (webclient)  Рамочные соглашения(тестовые)
    main_page.Знайти тендер організатором по title  ${data['title']}


Підтвердити прекваліфікацію для доступу до аукціону організатором
    qualification.Провести прекваліфікацію учасників


Дочекатися учасником статусу тендера кваліфікація
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
    procurement_tender_detail.Дочекатися статусу тендера  Кваліфікація


Провести кваліфікацію та визначити переможців
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Завантажити сесію для  tender_owner
	desktop.Перейти у розділ (webclient)  Рамочные соглашения(тестовые)
    main_page.Знайти тендер організатором по title  ${data['title']}
    main_page.Дочекатись стадії закупівлі  Квалификация
    qualification.Визнати всіх учасників переможцями


Дочекатися учасником статусу тендера "Пропозиції розглянуті"
    Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
    procurement_tender_detail.Дочекатися статусу тендера  Пропозиції розглянуті


Заповнити ціни за одиницю номенклатури по кожному переможцю
    Завантажити сесію для  tender_owner
	desktop.Перейти у розділ (webclient)Перейти у розділ (webclient)  Рамочные соглашения(тестовые)
    main_page.Знайти тендер організатором по title  ${data['title']}
    qualification.Заповнити ціни за одиницю номенклатури для всіх переможців


Заповнити рамкову угоду та опублікувати її
    main_page.Вибрати тендер за номером (webclient)  1
    framework_agreement.Заповнити поля Рамкової угоди
    webclient_elements.Натиснути кнопку "Заключить рамочное соглашение"
    validation.Закрити валідаційне вікно (Так/Ні)  Ви впевнені  Так
    validation.Закрити валідаційне вікно (Так/Ні)  Накласти ЕЦП на угоду  Ні
    validation.Закрити валідаційне вікно (Так/Ні)  не накладено актуальний підпис ЕЦП  Так
    framework_agreement.Підтвердити активацію рамкової угоди


Переконатись що статус закупівлі "Завершено"
    Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
    procurement_tender_detail.Дочекатися статусу тендера  Завершено



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
