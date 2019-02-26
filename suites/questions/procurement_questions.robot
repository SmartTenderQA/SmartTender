*** Settings ***
Resource  ../../src/src.robot
Suite Setup     Precondition
Suite Teardown  Close All Browsers
Test Setup      Stop The Whole Test Execution If Previous Test Failed
Test Teardown   Run Keyword If Test Failed  Run Keywords
...                                         Log Location  AND
...                                         Capture Page Screenshot

#  robot --consolecolors on -L TRACE:INFO -d test_output -v site:prod -v hub:none suites/questions/procurement_questions.robot
*** Variables ***
&{org}
...         prod=Astartia
...         test=Демо организатор


*** Test Cases ***
Знайти випадковий тендер з потрібним статусом (Період уточнень)
    Завантажити сесію для  ${provider}
    search.Відкрити сторінку тестових торгів
    old_search.Розгорнути розширений пошук
    search.Відфільтрувати по організатору    ${org['${site}']}
    Wait Until Keyword Succeeds  40  1  search.Відфільтрувати по статусу торгів  Період уточнень
    ${date}  smart_get_time  2  d
    search.Відфільтрувати по даті кінця прийому пропозиції від  ${date}
    old_search.Виконати пошук тендера
    old_search.Перейти по результату пошуку за номером  1
    Run Keyword If  '${site}' == 'prod'  search.Додаткова перевірка на тестові торги для продуктива


Зберегти дані тендера у словник
    ${tender_href}  Get Location
    ${title}  procurement_tender_detail.Отритами дані зі сторінки  ['title']
    Set To Dictionary  ${data}  tender_href  ${tender_href}
    Set To Dictionary  ${data}  title        ${title}
    Log  ${tender_href}  WARN


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


Відповісти організатором на поставлене запитання
    Завантажити сесію для  ${tender_owner}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title'][13:]}
    actions.Активувати вкладку  Обговорення закупівлі  /preceding-sibling::li[1]
    ${answer}  Відповісти організатором на запитання  ${data['questions'][${n}]['title']}
    Set To Dictionary  ${data['questions'][${n}]}  answer  ${answer}


Перевірити публікацію запитання в ЦБД
    Завантажити сесію для  ${provider}
    Go To  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['questions'][${n}]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['questions'][${n}]['description']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['questions'][${n}]['answer']


Перевірити публікацію запитання на сторінці користувачами
    :FOR  ${i}  IN  ${provider}  ${viewer}
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
	\  procurement_questions.Активувати вкладку "Запитання"
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['questions'][${n}]['title']
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['questions'][${n}]['description']
	\  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['questions'][${n}]['answer']




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