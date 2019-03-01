*** Settings ***
Resource  ../../src/src.robot

Suite Setup     Precondition
Suite Teardown  Close All Browsers
Test Setup      Stop The Whole Test Execution If Previous Test Failed
Test Teardown   Run Keyword If Test Failed  Run Keywords
...                                         Log Location  AND
...                                         Capture Element Screenshot  //body

Metadata  Команда запуска вимог
...       robot --consolecolors on -L TRACE:INFO -d test_output -v type:claims -i claims -v site:test suites/complaints/procurement_complaints.robot
Metadata  Команда запуска скарг
...       robot --consolecolors on -L TRACE:INFO -d test_output -v type:complaints -i complaints -v site:test suites/complaints/procurement_complaints.robot


*** Variables ***
&{types}
...         claims=вимогу "Замовнику"
...         complaints=скаргу до "АМКУ"

&{org}
...         prod=Astartia
...         test=Демо организатор


*** Test Cases ***
Знайти випадковий тендер з потрібним статусом (Прийом пропозицій)
    [Tags]  claims  complaints
    Завантажити сесію для  ${provider}
    search.Відкрити сторінку тестових торгів
    old_search.Розгорнути розширений пошук
    search.Відфільтрувати по організатору    ${org['${site}']}
    old_search.Вибрати Тип Процедури  Відкриті торги з публікацією англійською мовою
    search.Відфільтрувати по статусу торгів  Прийом пропозицій
    ${date}  smart_get_time  2  d
    search.Відфільтрувати по даті кінця прийому пропозиції від  ${date}
    old_search.Виконати пошук тендера
    ${n}  Set Variable If  '${site}' == 'prod'  last()  1
    old_search.Перейти по результату пошуку за номером  ${n}
    Run Keyword If  '${site}' == 'prod'  search.Додаткова перевірка на тестові торги для продуктива
    Зберегти дані тендера


Перейти на вкладку "Вимоги/скарги на умови закупівлі"
    [Tags]  claims  complaints
    procurement_complaints.Активувати вкладку "Вимоги/скарги на умови закупівлі"


Порахувати кількість вимог(скарг)
    [Tags]  claims  complaints
    procurement_complaints.Обрати у фільтрі предмет вимоги(скарги)  ${data['title']}
    ${n}  procurement_complaints.Порахувати кількісь вимог(скарг) на сторінці
    Set Global Variable  ${n}
    Run Keyword If  ${n} > 0  Підготувати словник data для збереження вимоги(скарги)  ${n}


Створити довільну вимогу(скаргу) та зберегти її у словник
    [Tags]  claims  complaints
    ${title}         create_sentence  3
    ${description}   create_sentence  8
    Set To Dictionary  ${data['complaints'][${n}]}  title        ${title}
    Set To Dictionary  ${data['complaints'][${n}]}  description  ${description}


Заповнити необхідні поля та подати вимогу(скаргу)
    [Tags]  claims  complaints
    Run Keyword  procurement_complaints.Натиснути кнопку подати ${types['${type}']}
    procurement_complaints.Заповнити тему вимоги(скарги)   ${data['complaints'][${n}]['title']}
    procurement_complaints.Заповнити текст вимоги(скарги)  ${data['complaints'][${n}]['description']}
    ${file name}  ${file md5}  actions.Додати doc файл
    Set To Dictionary  ${data['complaints'][${n}]['documents'][0]}  title  ${file name}
    Set To Dictionary  ${data['complaints'][${n}]['documents'][0]}  hash   ${file md5}
    procurement_complaints.Натиснути кнопку "Подати" вимогу(скаргу)


Відповісти організатором на вимогу
    [Tags]  claims
    Завантажити сесію для  ${tender_owner}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    actions.Активувати вкладку  Оскарження умов тендеру  /preceding-sibling::li[1]
    ${resolution}  ${type}  ${name}  ${hash}
    ...  complaints.Відповісти організатором на вимогу  ${data['complaints'][${n}]['title']}  Відхилено
    Log  Назва вимоги: ${data['complaints'][${n}]['title']}  WARN
    Log  Тип рішення вимоги: ${type}  WARN
    Підготувати словник data для збереження документа вимоги(скарги)
    Set To Dictionary  ${data['complaints'][${n}]}  resolution      ${resolution}
    Set To Dictionary  ${data['complaints'][${n}]}  resolutionType  ${type}
    Set To Dictionary  ${data['complaints'][${n}]['documents'][1]}  title  ${name}
    Set To Dictionary  ${data['complaints'][${n}]['documents'][1]}  hash   ${hash}


Перевірити публікацію вимоги в ЦБД
    [Tags]  claims
    Завантажити сесію для  ${provider}
    Go To Smart  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['description']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['resolution']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['resolutionType']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['documents'][0]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['documents'][0]['hash']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['documents'][1]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['documents'][1]['hash']


Перевірити публікацію скарги в ЦБД
    [Tags]  complaints
    Завантажити сесію для  ${provider}
    Go To Smart  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['description']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['documents'][0]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['documents'][0]['hash']


Перевірити публікацію вимоги(скарги) на сторінці користувачами
    [Tags]  claims
    :FOR  ${user}  IN  ${provider}  ${viewer}
	\  Завантажити сесію для  ${user}
	\  Go To Smart  ${data['tender_href']}
	\  procurement_complaints.Активувати вкладку "Вимоги/скарги на умови закупівлі"
	\  procurement_complaints.Обрати у фільтрі предмет вимоги(скарги)  ${data['title']}
	\  procurement_complaints.Розгорнути всі експандери вимог(скарг)
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['complaints'][${n}]['title']
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['complaints'][${n}]['description']
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['complaints'][${n}]['resolution']
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['complaints'][${n}]['resolutionType']
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['complaints'][${n}]['documents'][0]['title']
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['complaints'][${n}]['documents'][1]['title']


Перевірити публікацію вимоги(скарги) на сторінці користувачами
    [Tags]  complaints
    :FOR  ${user}  IN  ${provider}  ${viewer}
	\  Завантажити сесію для  ${user}
	\  Go To Smart  ${data['tender_href']}
	\  procurement_complaints.Активувати вкладку "Вимоги/скарги на умови закупівлі"
	\  procurement_complaints.Обрати у фільтрі предмет вимоги(скарги)  ${data['title']}
	\  procurement_complaints.Розгорнути всі експандери вимог(скарг)
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['complaints'][${n}]['title']
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['complaints'][${n}]['description']





*** Keywords ***
Precondition
    Run Keyword If  '${where}' == 'test'  Run Keywords
	...  Set Global Variable  ${tender_owner}  Bened  AND
	...  Set Global Variable  ${provider}      user1  AND
	...  Set Global Variable  ${viewer}        test_viewer
	Run Keyword If  'prod' in '${where}'  Run Keywords
	...  Set Global Variable  ${tender_owner}  prod_owner	   AND
	...  Set Global Variable  ${provider}      prod_provider1  AND
	...  Set Global Variable  ${viewer}        prod_viewer

    Додати першого користувача  ${tender_owner}
    Додати користувача          ${provider}
    Додати користувача          ${viewer}


Зберегти дані тендера
    ${tender_href}  Get Location
    Log  ${tender_href}  WARN
    Set To Dictionary  ${data}  tender_href  ${tender_href}
    ${tender title}  procurement_tender_detail.Отритами дані зі сторінки  ['title']
    Set To Dictionary  ${data}  title  ${tender title}


Отримати дані з cdb та зберегти їх у файл
    [Tags]  create_tender
    procurement_tender_detail.Активувати вкладку "Тендер"
    ${id}  procurement_tender_detail.Отритами дані зі сторінки  ['id']
    ${cdb}  Отримати дані тендеру з cdb по id  ${id}
    Set Global Variable  ${cdb}
    actions.Зберегти словник у файл  ${cdb}  cdb


Підготувати словник data для збереження вимоги(скарги)
    [Arguments]  ${n}
    :FOR  ${complaints}  IN RANGE  ${n}
    \  ${new dict}  Evaluate  ${data['complaints'][0]}.copy()
    \  Append to list  ${data['complaints']}  ${new dict}


Підготувати словник data для збереження документа вимоги(скарги)
    ${new dict}  Evaluate  ${data['complaints'][${n}]['documents'][0]}.copy()
    Append to list  ${data['complaints'][${n}]['documents']}  ${new dict}