*** Settings ***
Resource   ../../src/src.robot
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot

#  robot --consolecolors on -L TRACE:INFO -d test_output -v EDS:True -v hub:None -e get_tender suites/qulification_files/with_find_tender.robot
*** Test Cases ***
Підготувати користувачів
    Run Keyword  Підготувати користувачів для ${site}


Виконати пошук тендера на стадії Кваліфікація
    Завантажити сесію для  tender_owner
    desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Відфільтрувати за типом процедури  Відкриті торги з публікацією англійською мовою
    main_page.Пошук об'єкта у webclient по полю  Стадія  3. Квалификация
    Зберегти дані тендера


Відхилити організатором пропозицію першого учасника
    ${negative result file name}  qualification.Відхилити пропозицію учасника  1  ${EDS}
    Set To Dictionary  ${data['awards'][0]['documents'][0]}  title  ${negative result file name}


Завантажити другим учасником кваліфікаційний документ
    Завантажити сесію для  provider2
    Go to  ${data['tender_href']}
    ${provider file name}  procurement_tender_detail.Додати кваліфікаційний документ  #${EDS}
    Адаптувати словник data для bids
    Set To Dictionary  ${data['bids'][1]['documents'][1]}  title  ${provider file name}


Завантажити другим учасником додатковий кваліфікаційний документ
    ${provider file name 2}  procurement_tender_detail.Додати кваліфікаційний документ  #${EDS}
    Set To Dictionary  ${data['bids'][1]['documents'][2]}  title  ${provider file name 2}


#TODO  Замінити другим учасником останній кваліфікаційний документ


Визнати переможцем другого учасника
    Завантажити сесію для  tender_owner
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    ${positive result file name}  qualification.Визначити учасника переможцем  2  ${EDS}
    Адаптувати словник data для awards
    Set To Dictionary  ${data['awards'][1]['documents'][0]}  title  ${positive result file name}


Прикріпити договір до переможця
    qualification_keywords.Вибрати переможця за номером  2
    ${dogovir name}  qualification.Додати договір до переможця
    Set To Dictionary  ${data['contracts'][0]['documents'][0]}  title  ${dogovir name}


Підготуватися до перевірки відображення документів на сторінці
    Go to  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл
    actions.Зберегти словник у файл  ${data}  data
    Log  ${data}


Перевірити публікацію кваліфікаційних файлів в ЦБД
    [Template]  procurement_tender_detail.Порівняти введені дані з даними в ЦБД
    \['awards'][0]['documents'][0]['title']
    \['bids'][1]['documents'][1]['title']
    \['bids'][1]['documents'][2]['title']
    \['awards'][1]['documents'][0]['title']
    \['contracts'][0]['documents'][0]['title']


Перевірити публікацію кваліфікаційних файлів на сторінці користувачами
    debug
    :FOR  ${user}  in  tender_owner  tender_owner2
    \  Завантажити сесію для  ${user}
    \  Go to  ${data['tender_href']}
    \  procurement_tender_detail.Розгорнути всі експандери
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['awards'][0]['documents'][0]['title']
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['bids'][1]['documents'][1]['title']
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['bids'][1]['documents'][2]['title']
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['awards'][1]['documents'][0]['title']
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['contracts'][0]['documents'][0]['title']



*** Keywords ***
Підготувати користувачів для prod
    Додати першого користувача  prod_owner      tender_owner
    Додати користувача          prod_ssp_owner  tender_owner2
    #Додати користувача          prod_provider1  provider1
    Додати користувача          prod_provider2  provider2
    #Додати користувача          prod_provider   provider3


Підготувати користувачів для test
    Додати першого користувача  PPR_OR          tender_owner
    Додати користувача          Bened           tender_owner2
    #Додати користувача          user1           provider1
    Додати користувача          user2           provider2
    #Додати користувача          user3           provider3


Зберегти дані тендера
    ${tender_uaid}   Отримати tender_uaid вибраного тендера
    ${tender_href}   Отримати tender_href вибраного тендера
    ${tender_title}  Отримати tender_title вибраного тендера
    Set To Dictionary  ${data}  tenderID     ${tender_uaid}
    Set To Dictionary  ${data}  tender_href  ${tender_href}
    Set To Dictionary  ${data}  title        ${tender_title}
    Log  ${tender_href}  WARN
    Зберегти словник у файл  ${data}  data


Отримати дані з cdb та зберегти їх у файл
    ${id}  procurement_tender_detail.Отритами дані зі сторінки  ['id']
    ${cdb}  Wait Until Keyword Succeeds  2m  5  Отримати дані тендеру з cdb по id  ${id}
    Set Global Variable  ${cdb}
    actions.Зберегти словник у файл  ${cdb}  cdb


Адаптувати словник data для bids
    ${new dict}  Evaluate  ${data['bids'][0]}.copy()
    Append to list   ${data['bids']}  ${new dict}
    ${new dict}  Evaluate  ${data['bids'][1]['documents'][0]}.copy()
    Append to list   ${data['bids'][1]['documents']}  ${new dict}
    Append to list   ${data['bids'][1]['documents']}  ${new dict}


Адаптувати словник data для awards
    ${new dict}  Evaluate  ${data['awards'][0]}.copy()
    Append to list   ${data['awards']}  ${new dict}


