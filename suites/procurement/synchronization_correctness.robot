*** Settings ***
Resource  				../../src/src.robot

Suite Setup  			Run Keyword  Preconditions
Suite Teardown  		Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Page Screenshot


*** Test Cases ***
Створити тендер
    [Tags]  below
    below.Створити тендер
    below.Отримати дані тендера та зберегти їх у файл

Створити тендер
	[Tags]  open_eu
	test_open_eu.Створити тендер (Мультилот)
    test_open_eu.Отримати дані тендера та зберегти їх у файл


Отримати дані з cdb
    Go to  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл


Дочекатись синхронізації х2
    Run Keywords  synchronization.Дочекатись синхронізації  procurement  AND  synchronization.Дочекатись синхронізації  procurement


Перейти в особистий кабінет користувача
    header_old.Розгорнути меню користувача
    user-menu.Натиснути кнопку Особистий кабінет
    Дочекатись закінчення загрузки сторінки(weclient start)


Змінити назву тендера
    [Tags]  below
    desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    actions.Натиснути кнопку Змінити (F4)
    below.Заповнити title для tender
    actions.Натиснути кнопку "Зберегти"


Змінити назву тендера
    [Tags]  open_eu
    desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    actions.Натиснути кнопку Змінити (F4)
    actions.Натиснути кнопку "Коригувати
    below.Заповнити title для tender
    actions.Натиснути кнопку "Зберегти"


Отримати оновлену інформацію з цбд
    Go to  ${data['tender_href']}
    Set Global Variable  ${cdb old}  ${cdb}
    Отримати дані з cdb та зберегти їх у файл  cdb_edit
    Перевірити що в ЦБД було змінено тільки назву та дату модифікації


*** Keywords ***
Preconditions
    ${site}  Set Variable If  '${where}' == 'test'  test  prod
    ${user}  Run Keyword If  'prod' in '${site}'  Set Variable  prod_owner
    ...  ELSE  Set Variable  Bened
   	Set Global Variable  ${user}  ${user}
	Open Browser In Grid  ${user}
	Авторизуватися  ${user}


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
    Remove From Dictionary  ${cdb old}  title  dateModified
    Remove From Dictionary  ${cdb}  title  dateModified  auctionPeriod