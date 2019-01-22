*** Settings ***
Resource   ../../src/src.robot

Suite Setup     Підготувати користувачів
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot

#  robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None -e get_tender suites/qulification_files/qulification_files.robot
*** Test Cases ***
Створити тендер
    [Setup]  Set Window Size  1440  900
	[Tags]  create_tender
	Завантажити сесію для  ${tender_owner}
	below.Створити тендер
	below.Отримати дані тендера та зберегти їх у файл


Отримати дані з cdb
    [Tags]  create_tender
    Завантажити сесію для  ${provider1}
    Go to  ${data['tender_href']}
    Wait Until Keyword Succeeds  1m  5  Отримати дані з cdb та зберегти їх у файл


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact_data.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Подати заявку на участь в тендері учасниками
	:FOR  ${i}  IN  ${provider1}  ${provider2}  ${provider3}
	\  Прийняти участь у тендері учасником  ${i}
	procurement_page_keywords.Дочекатись закінчення прийому пропозицій
	procurement_tender_detail.Дочекатися статусу тендера  Кваліфікація


Відхилити організатором пропозицію першого учасника
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Завантажити сесію для  ${tender_owner}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    ${negative result file name}  Відхилити пропозицію учасника  1
    Set To Dictionary  ${data['awards'][0]['documents'][0]}  title  ${negative result file name}


Завантажити другим учасником кваліфікаційний документ
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Завантажити сесію для  ${provider2}
    Go to  ${data['tender_href']}
    ${provider file name}  Додати кваліфікаційний документ
    ${new dict}  Evaluate  ${data['bids'][0]}.copy()
    Append to list   ${data['bids']}  ${new dict}
    ${new dict}  Evaluate  ${data['bids'][1]['documents'][0]}.copy()
    Append to list   ${data['bids'][1]['documents']}  ${new dict}
    Set To Dictionary  ${data['bids'][1]['documents'][1]}  title  ${provider file name}


Визнати переможцем другого учасника
    Завантажити сесію для  ${tender_owner}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    ${positive result file name}  Визначити учасника переможцем  2
    ${new dict}  Evaluate  ${data['awards'][0]}.copy()
    Append to list   ${data['awards']}  ${new dict}
    Set To Dictionary  ${data['awards'][1]['documents'][0]}  title  ${positive result file name}


Организатор Прикріпити договір
    Вибрати переможця на номером else  2
    actions.Натиснути кнопку "Прикріпити договір"
    Заповнити номер договору
    ${dogovir name}  Вкласти договірній документ
    actions.Натиснути OkButton
    validation.Підтвердити повідомлення про перевірку публікації документу за необхідністю
    Set To Dictionary  ${data['contracts'][0]['documents'][0]}  title  ${dogovir name}


Підготуватися до перевірки відображення документів на сторінці
    Go to  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл
    actions.Зберегти словник у файл  ${data}  data
    Log  ${data}


Перевірити відображення кваліфікаційних файлів організаторами
    :FOR  ${user}  in  ${tender_owner}  ${tender_owner2}
    \  Завантажити сесію для  ${user}
    \  Go to  ${data['tender_href']}
    \  procurement_tender_detail.Розгорнути всі експандери
    \  procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['awards'][0]['documents'][0]['title']
    \  procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['bids'][1]['documents'][1]['title']
    \  procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['awards'][1]['documents'][0]['title']
    \  procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['contracts'][0]['documents'][0]['title']
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['awards'][0]['documents'][0]['title']
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['bids'][1]['documents'][1]['title']
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['awards'][1]['documents'][0]['title']
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['contracts'][0]['documents'][0]['title']


Завершити закупівлю організатором
    Завантажити сесію для  ${tender_owner}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    main_page.Дочекатись стадії закупівлі  Кваліфікація переможця
    actions.Натиснути надіслати вперед(Alt+Right)
    main_page.Дочекатись стадії закупівлі  Пропозиції розглянуті
    Вибрати переможця на номером else  2
    actions.Натиснути кнопку "Підписати договір"
    validation.Закрити валідаційне вікно (Так/Ні)  Ви дійсно хочете підписати договір?  Так
    validation.Підтвердити підписання договору


Переконатись що статус закупівлі "Завершено"
    Завантажити сесію для  ${provider1}
    Go to  ${data['tender_href']}
    procurement_tender_detail.Дочекатися статусу тендера  Завершено






*** Keywords ***
Підготувати користувачів
    Set Global Variable         ${tender_owner}   PPR_OR
    Set Global Variable         ${tender_owner2}  Bened
    Set Global Variable         ${provider1}      user1
    Set Global Variable         ${provider2}      user2
    Set Global Variable         ${provider3}      user3

    Додати першого користувача  ${tender_owner}
    Додати користувача          ${tender_owner2}
    Додати користувача          ${provider1}
    Додати користувача          ${provider2}
    Додати користувача          ${provider3}


Прийняти участь у тендері учасником
    [Arguments]  ${username}
    Завантажити сесію для  ${username}
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Прийом пропозицій
    Run Keyword If  '${username}' == '${provider1}'  Sleep  3m
    Подати пропозицію учасником


Подати пропозицію учасником
	Перевірити кнопку подачі пропозиції
	Заповнити поле з ціною  1  1
    actions.Додати doc файл
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
    Go Back


Отримати дані з cdb та зберегти їх у файл
    ${id}  procurement_tender_detail.Отритами дані зі сторінки  ['id']
    ${cdb}  Wait Until Keyword Succeeds  2m  5  Отримати дані тендеру з cdb по id  ${id}
    Set Global Variable  ${cdb}
    actions.Зберегти словник у файл  ${cdb}  cdb


Вибрати переможця на номером else
    [Arguments]  ${i}
    ${selector}  Set Variable  (${winners2})[${i}]
    Click Element  ${selector}


Заповнити номер договору
    ${selector}  Set Variable  //*[text()="Номер договору"]/following-sibling::table[1]//input
    ${n}  random_number  1000  10000
    Input Text  ${selector}  ${n}


Вкласти договірній документ
    ${add button}  Set Variable  //span[contains(text(), "Обзор")]
    Click Element  ${add button}
    Дочекатись закінчення загрузки сторінки(webclient)
    Wait Until Page Contains Element  xpath=//*[@type='file'][1]
    ${name}  actions.Додати doc файл
    Click Element  xpath=(//span[.='ОК'])[1]
    Дочекатись закінчення загрузки сторінки(webclient)
    Page Should Contain  ${name}
    [Return]  ${name}



