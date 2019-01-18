*** Settings ***
Resource  ../../src/src.robot
Suite Setup     Підготувати користувачів
Suite Teardown  Close All Browsers
Test Setup      Stop The Whole Test Execution If Previous Test Failed
Test Teardown   Run Keyword If Test Failed  Run Keywords
...                                         Log Location  AND
...                                         Capture Page Screenshot

#  robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None suites/questions/procurement_questions.robot
*** Test Cases ***
Знайти випадковий тендер з потрібним статусом (Період уточнень)
    Завантажити сесію для  ${provider}
    search.Відкрити сторінку тестових торгів
    old_search.Розгорнути розширений пошук
    search.Відфільтрувати по статусу торгів  Період уточнень
    ${date}  smart_get_time  1  d
    search.Відфільтрувати по даті кінця прийому пропозиції від  ${date}
    old_search.Виконати пошук тендера
    old_search.Перейти по результату пошуку за номером  1
    ${tender_href}  Get Location
    Log  ${tender_href}  WARN
    Set To Dictionary  ${data}  tender_href  ${tender_href}

Перейти на сторінку запитань та порахувати їх кількість
    procurement_questions.Активувати вкладку "Запитання"
    ${n}  procurement_questions.Порахувати кількісь запитань на сторінці
    Set Global Variable  ${n}
    Run Keyword If  ${n} > 0  Підготувати словник data для збереження запитання  ${n}


Створити довільне запитання та зберегти його у словник
    ${theme}  create_sentence  3
    ${text}   create_sentence  8
    Set To Dictionary  ${data['questions'][${n}]}  title        ${theme}
    Set To Dictionary  ${data['questions'][${n}]}  description  ${text}


Заповнити необхідні поля та поставити запитання
    procurement_questions.Натиснути кнопку "Поставити запитання"
    procurement_questions.Заповнити тему запитання   ${data['questions'][${n}]['title']}
    procurement_questions.Заповнити текст запитання  ${data['questions'][${n}]['description']}
    procurement_questions.Натиснути кнопку "Подати" запитання


Перевірити публікацію запитання в ЦБД
    Отримати дані з cdb та зберегти їх у файл
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['questions'][${n}]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['questions'][${n}]['description']


Перевірити публікацію запитання на сторінці користувачами
    :FOR  ${i}  IN  ${provider}  ${viewer}
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
	\  procurement_questions.Активувати вкладку "Запитання"
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['questions'][${n}]['title']
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['questions'][${n}]['description']




*** Keywords ***
Підготувати користувачів
    Set Global Variable         ${provider}  user1
    Set Global Variable         ${viewer}    test_viewer
    Додати першого користувача  ${provider}
    Додати користувача          ${viewer}
    
    
Отримати дані з cdb та зберегти їх у файл
    [Tags]  create_tender
    procurement_tender_detail.Активувати вкладку "Тендер"
    ${id}  procurement_tender_detail.Отритами дані зі сторінки  ['id']
    ${cdb}  Отримати дані тендеру з cdb по id  ${id}
    Set Global Variable  ${cdb}
    actions.Зберегти словник у файл  ${cdb}  cdb


Підготувати словник data для збереження запитання
    [Arguments]  ${n}
    :FOR  ${i}  IN RANGE  ${n}
    \  ${new dict}  Evaluate  ${data['questions'][0]}.copy()
    \  Append to list  ${data['questions']}  ${new dict}