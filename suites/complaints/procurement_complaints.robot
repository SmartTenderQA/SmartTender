*** Settings ***
Resource  ../../src/src.robot
Suite Setup     Precondition
Suite Teardown  Close All Browsers
Test Setup      Stop The Whole Test Execution If Previous Test Failed
Test Teardown   Run Keyword If Test Failed  Run Keywords
...                                         Log Location  AND
...                                         Capture Page Screenshot

#  robot --consolecolors on -L TRACE:INFO -d test_output -v type:claims -v site:test -v hub:none suites/complaints/procurement_complaints.robot
*** Variables ***
&{types}
...         claims=Подати вимогу "Замовнику"
...         complaints=скаргу до "АМКУ"


*** Test Cases ***
Знайти випадковий тендер з потрібним статусом (Період уточнень)
    Завантажити сесію для  ${provider}
    search.Відкрити сторінку тестових торгів
    old_search.Розгорнути розширений пошук
    old_search.Вибрати Тип Процедури  Відкриті торги з публікацією англійською мовою
    search.Відфільтрувати по статусу торгів  Прийом пропозицій
    ${date}  smart_get_time  1  d
    search.Відфільтрувати по даті кінця прийому пропозиції від  ${date}
    old_search.Виконати пошук тендера
    old_search.Перейти по результату пошуку за номером  1
    Run Keyword If  '${site}' == 'prod'  search.Додаткова перевірка на тестові торги для продуктива


Зберегти дані тендера
    ${tender_href}  Get Location
    Log  ${tender_href}  WARN
    Set To Dictionary  ${data}  tender_href  ${tender_href}
    ${tender title}  procurement_tender_detail.Отритами дані зі сторінки  ['title']
    Set To Dictionary  ${data}  title  ${tender title}


Перейти на вкладку "Вимоги/скарги на умови закупівлі"
    procurement_complaints.Активувати вкладку "Вимоги/скарги на умови закупівлі"


Порахувати кількість вимог(скарг)
    [Tags]  claims
    procurement_complaints.Обрати у фільтрі предмет вимоги(скарги)  ${data['title']}
    ${n}  procurement_complaints.Порахувати кількісь вимог(скарг) на сторінці
    Set Global Variable  ${n}
    Run Keyword If  ${n} > 0  Підготувати словник data для збереження вимоги(скарги)  ${n}


Створити довільну вимогу(скаргу) та зберегти її у словник
    [Tags]  claims
    ${title}         create_sentence  3
    ${description}   create_sentence  8
    Set To Dictionary  ${data['complaints'][${n}]}  title        ${title}
    Set To Dictionary  ${data['complaints'][${n}]}  description  ${description}


Заповнити необхідні поля та подати вимогу
    [Tags]  claims
    Run Keyword  procurement_complaints.Натиснути кнопку ${types['${type}']}
    procurement_complaints.Заповнити тему вимоги(скарги)   ${data['complaints'][${n}]['title']}
    procurement_complaints.Заповнити текст вимоги(скарги)  ${data['complaints'][${n}]['description']}
    Додати файл до вимоги(скарги)
    procurement_complaints.Натиснути кнопку "Подати" вимогу(скаргу)


Перевірити публікацію в ЦБД
    [Tags]  claims
    Отримати дані з cdb та зберегти їх у файл
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['description']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['documents'][0]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['documents'][0]['hash']


Перевірити публікацію на сторінці користувачами
    [Tags]  claims
    :FOR  ${i}  IN  ${provider}  ${viewer}
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
	\  procurement_complaints.Активувати вкладку "Вимоги/скарги на умови закупівлі"
	\  procurement_complaints.Обрати у фільтрі предмет вимоги(скарги)  ${data['title']}
	\  procurement_complaints.Розгорнути всі експандери вимог(скарг)
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['complaints'][${n}]['title']
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['complaints'][${n}]['description']
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['complaints'][${n}]['documents'][0]['title']




*** Keywords ***
Precondition
    Run Keyword  Підготувати користувачів ${site}


Підготувати користувачів test
    Set Global Variable         ${provider}  user1
    Set Global Variable         ${viewer}    test_viewer
    Додати першого користувача  ${provider}
    Додати користувача          ${viewer}


Підготувати користувачів prod
    Set Global Variable         ${provider}  prod_provider1
    Set Global Variable         ${viewer}    prod_viewer
    Додати першого користувача  ${provider}
    Додати користувача          ${viewer}
    
    
Отримати дані з cdb та зберегти їх у файл
    [Tags]  create_tender
    procurement_tender_detail.Активувати вкладку "Тендер"
    ${id}  procurement_tender_detail.Отритами дані зі сторінки  ['id']
    ${cdb}  Отримати дані тендеру з cdb по id  ${id}
    Set Global Variable  ${cdb}
    actions.Зберегти словник у файл  ${cdb}  cdb


Підготувати словник data для збереження вимоги(скарги)
    [Arguments]  ${n}
    :FOR  ${i}  IN RANGE  ${n}
    \  ${new dict}  Evaluate  ${data['complaints'][0]}.copy()
    \  Append to list  ${data['complaints']}  ${new dict}


Додати файл до вимоги(скарги)
    ${file name}  ${file md5}  actions.Додати doc файл
    Set To Dictionary  ${data['complaints'][${n}]['documents'][0]}  title  ${file name}
    Set To Dictionary  ${data['complaints'][${n}]['documents'][0]}  hash   ${file md5}