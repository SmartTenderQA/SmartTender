*** Settings ***
Resource  				../../src/src.robot

Suite Setup  			Run Keyword  Підготувати користувачів
Suite Teardown  		Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Element Screenshot  //body

#  robot --consolecolors on -L TRACE:INFO -d test_output -e below -v where:test -v hub:none -v headless suites/procurement/synchronization_correctness.robot
*** Test Cases ***
Створити тендер
    [Tags]  below
    below.Створити тендер
    below.Отримати дані тендера та зберегти їх у файл
    Зберегти сесію  ${tender_owner}

Створити тендер
	[Tags]  open_eu
	test_open_eu.Створити тендер (Мультилот)
    test_open_eu.Отримати дані тендера та зберегти їх у файл
    Зберегти сесію  ${tender_owner}


Отримати дані з cdb
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Go to  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл


Дочекатись синхронізації х2
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Run Keywords  synchronization.Дочекатись синхронізації  procurement  AND  synchronization.Дочекатись синхронізації  procurement


Змінити назву тендера
    [Tags]  below
    Завантажити сесію для  ${tender_owner}
    desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    actions.Натиснути кнопку Змінити (F4)
    below.Заповнити title для tender
    actions.Натиснути кнопку "Зберегти"


Змінити назву тендера
    [Tags]  open_eu
    Завантажити сесію для  ${tender_owner}
    desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    actions.Натиснути кнопку Змінити (F4)
    actions.Натиснути кнопку "Коригувати
    below.Заповнити title для tender
    actions.Натиснути кнопку "Зберегти"


Отримати оновлену інформацію з цбд
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Go to  ${data['tender_href']}
    Set Global Variable  ${cdb old}  ${cdb}
    Отримати дані з cdb та зберегти їх у файл  cdb_edit

Видалити зайві дані про мультилоти
    [Tags]  open_eu
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Видалити інформацію про аукціон в мультилотах  ${cdb['lots']}
    Видалити інформацію про аукціон в мультилотах  ${cdb old['lots']}


Перевірити дані в ЦБД
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Перевірити що в ЦБД було змінено тільки назву та дату модифікації


*** Keywords ***
Підготувати користувачів
    Run Keyword If  '${where}' == 'test'
	...  Set Global Variable  ${tender_owner}  Bened
	Run Keyword If  'prod' in '${where}'
	...  Set Global Variable  ${tender_owner}  prod_owner
    Додати першого користувача  ${tender_owner}


Отримати дані з cdb та зберегти їх у файл
    [Arguments]  ${filename}=cdb
    ${id}  procurement_tender_detail.Отритами дані зі сторінки  ['id']
    ${cdb}  Отримати дані тендеру з cdb по id  ${id}
    Set Global Variable  ${cdb}
    actions.Зберегти словник у файл  ${cdb}  ${filename}


Перевірити що в ЦБД було змінено тільки назву та дату модифікації
    Видалити змінені елементи зі словників
    Dictionaries Should Be Equal  ${cdb}  ${cdb old}


Видалити змінені елементи зі словників
    Remove From Dictionary  ${cdb['enquiryPeriod']}  invalidationDate
    Remove From Dictionary  ${cdb old['enquiryPeriod']}  invalidationDate
    Remove From Dictionary  ${cdb old}  title  dateModified  auctionPeriod
    Remove From Dictionary  ${cdb}  title  dateModified  auctionPeriod


Видалити інформацію про аукціон в мультилотах
    [Arguments]  ${tender json}
    ${list of lots}  Set Variable  ${tender json}
    :FOR  ${lot}  IN  @{list of lots}
    \  Remove From Dictionary  ${lot}  auctionPeriod
    Set Global Variable  ${tender json}  ${list of lots}