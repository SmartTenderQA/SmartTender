*** Settings ***
Resource  ../../src/src.robot

Suite Teardown  Close All Browsers
Test Setup      Stop The Whole Test Execution If Previous Test Failed
Test Teardown   Run Keyword If Test Failed  Run Keywords
...                                         Log Location  AND
...                                         Capture Page Screenshot

#  robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None suites/complaints/procurement_complaints.robot
*** Test Cases ***
Підготувати користувачів
    Додати першого користувача  user1           provider1
    Додати користувача          test_viewer     viewer


Знайти випадковий тендер з потрібним статусом (Період уточнень)
    Завантажити сесію для  provider1
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


Перейти на сторінку вимог та порахувати їх кількість
    procurement_complaints.Активувати вкладку "Вимоги/скарги на умови закупівлі"
    ${tender title}  procurement_tender_detail.Отритами дані зі сторінки  ['title']
    Set To Dictionary  ${data}  title  ${tender title}
    procurement_complaints.Обрати у фільтрі предмет вимоги  ${data['title']}
    ${n}  procurement_complaints.Порахувати кількісь вимог на сторінці
    Set Global Variable  ${n}
    Run Keyword If  ${n} > 0  Підготувати словник data для збереження вимоги  ${n}


Створити довільну вимогу та зберегти її у словник
    ${title}         create_sentence  3
    ${description}   create_sentence  8
    Set To Dictionary  ${data['complaints'][${n}]}  title        ${title}
    Set To Dictionary  ${data['complaints'][${n}]}  description  ${description}


Заповнити необхідні поля та подати вимогу
    procurement_complaints.Натиснути кнопку Подати вимогу "Замовнику"
    procurement_complaints.Заповнити тему вимоги   ${data['complaints'][${n}]['title']}
    procurement_complaints.Заповнити текст вимоги  ${data['complaints'][${n}]['description']}
    Додати файл до вимоги
    procurement_complaints.Натиснути кнопку "Подати" вимогу


Перевірити публікацію вимоги в ЦБД
    Отримати дані з cdb та зберегти їх у файл
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['description']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['documents'][0]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['complaints'][${n}]['documents'][0]['hash']


Перевірити публікацію вимоги на сторінці користувачами
    :FOR  ${i}  IN  provider1  viewer
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
	\  procurement_complaints.Активувати вкладку "Вимоги/скарги на умови закупівлі"
	\  procurement_complaints.Обрати у фільтрі предмет вимоги  ${data['title']}
	\  procurement_complaints.Розгорнути всі експандери вимог
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['complaints'][${n}]['title']
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['complaints'][${n}]['description']
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['complaints'][${n}]['documents'][0]['title']




*** Keywords ***
Отримати дані з cdb та зберегти їх у файл
    [Tags]  create_tender
    procurement_tender_detail.Активувати вкладку "Тендер"
    ${id}  procurement_tender_detail.Отритами дані зі сторінки  ['id']
    ${cdb}  Отримати дані тендеру з cdb по id  ${id}
    Set Global Variable  ${cdb}
    actions.Зберегти словник у файл  ${cdb}  cdb


Підготувати словник data для збереження вимоги
    [Arguments]  ${n}
    :FOR  ${i}  IN RANGE  ${n}
    \  ${new dict}  Evaluate  ${data['complaints'][0]}.copy()
    \  Append to list  ${data['complaints']}  ${new dict}


Додати файл до вимоги
    ${file name}  actions.Додати doc файл
    ${file md5}   get_checksum_md5   ${OUTPUTDIR}/${file name}
    Set To Dictionary  ${data['complaints'][${n}]['documents'][0]}  title  ${file name}
    Set To Dictionary  ${data['complaints'][${n}]['documents'][0]}  hash   ${file md5}