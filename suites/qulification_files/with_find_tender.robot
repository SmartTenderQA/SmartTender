*** Settings ***
Documentation
Metadata

Resource   ../../src/src.robot
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot

<<<<<<< HEAD
#  robot --consolecolors on -L TRACE:INFO -d test_output -v EDS:True -v hub:None -e get_tender suites/qulification_files/with_find_tender.robot
=======
#  robot --consolecolors on -L TRACE:INFO -d test_output -v EDS:True -v hub:None -v site:test suites/qulification_files/with_find_tender.robot
>>>>>>> 8f6927b3270fd29142c717a6198255a60a9fa28d
*** Variables ***
&{type}
...         test=Відкриті торги з публікацією англійською мовою
...         prod=Допорогові закупівлі
&{stage}
...         test=3. Квалификация
...         prod=4.Кваліфікація переможця


*** Test Cases ***
Підготувати користувачів
    Run Keyword  Підготувати користувачів для ${site}


Виконати пошук тендера на стадії Кваліфікація
    Завантажити сесію для  ${tender_owner}
    Set Window Size  1280  1024
    desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Відфільтрувати за типом процедури          ${type['${site}']}
    main_page.Пошук об'єкта у webclient по полю  Стадія  ${stage['${site}']}
<<<<<<< HEAD
=======
    Run Keyword If  '${site}' == 'prod'
    ...  main_page.Пошук об'єкта у webclient по полю  Кількість  2
>>>>>>> 8f6927b3270fd29142c717a6198255a60a9fa28d
    Зберегти дані тендера


Отримати тип процедури з cdb
    Go to  ${data['tender_href']}
    Run Keyword If  '${site}' == 'prod'  search.Додаткова перевірка на тестові торги для продуктива
    Отримати дані з cdb та зберегти їх у файл
    Log  ${cdb['procurementMethodType']}


<<<<<<< HEAD
Відхилити організатором пропозицію першого учасника
    Завантажити сесію для  tender_owner
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    ${negative result file name}  qualification.Відхилити пропозицію учасника  1  ${EDS}  ${cdb['procurementMethodType']}
    Set To Dictionary  ${data['awards'][0]['documents'][0]}  title  ${negative result file name}
=======
Підготувати словник data для збереження даних
    Адаптувати словник data для awards
    Адаптувати словник data для bids


Відхилити організатором пропозицію першого учасника
    Завантажити сесію для  ${tender_owner}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    ${negative result file name}  qualification.Відхилити пропозицію учасника  1  ${EDS}  ${cdb['procurementMethodType']}
    Set To Dictionary  ${data['awards'][0]['documents'][1]}  title  ${negative result file name}
>>>>>>> 8f6927b3270fd29142c717a6198255a60a9fa28d


Завантажити другим учасником кваліфікаційний документ
    Завантажити сесію для  ${provider2}
    Go to  ${data['tender_href']}
    ${provider file name}  procurement_tender_detail.Додати кваліфікаційний документ  ${EDS}
    Адаптувати словник data для bids
    Set To Dictionary  ${data['bids'][1]['documents'][1]}  title  ${provider file name}


Завантажити другим учасником додатковий кваліфікаційний документ
    ${provider file name 2}  procurement_tender_detail.Додати кваліфікаційний документ  ${EDS}
<<<<<<< HEAD
    Set To Dictionary  ${data['bids'][1]['documents'][2]}  title  ${provider file name 2}
=======
    Set To Dictionary  ${data['bids'][1]['documents'][3]}  title  ${provider file name 2}
>>>>>>> 8f6927b3270fd29142c717a6198255a60a9fa28d


#TODO  Замінити другим учасником останній кваліфікаційний документ


Визнати переможцем другого учасника
    Завантажити сесію для  ${tender_owner}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    ${positive result file name}  qualification.Визначити учасника переможцем  2  ${EDS}  ${cdb['procurementMethodType']}
    Адаптувати словник data для awards
    Set To Dictionary  ${data['awards'][1]['documents'][0]}  title  ${positive result file name}


Прикріпити договір до переможця
    [Tags]  test
    qualification_keywords.Вибрати переможця за номером  2
    ${dogovir name}  qualification.Додати договір до переможця
    Set To Dictionary  ${data['contracts'][0]['documents'][0]}  title  ${dogovir name}


Підготуватися до перевірки відображення документів на сторінці
    Go to  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл
    actions.Зберегти словник у файл  ${data}  data
    Log  ${data}


Перевірити публікацію кваліфікаційних файлів в ЦБД
    Run Keyword  Перевірити публікацію кваліфікаційних файлів в ЦБД ${site}


Перевірити публікацію кваліфікаційних файлів на сторінці користувачами
    Run Keyword  Перевірити публікацію кваліфікаційних файлів на сторінці користувачами ${site}
<<<<<<< HEAD
=======


>>>>>>> 8f6927b3270fd29142c717a6198255a60a9fa28d


*** Keywords ***
Підготувати користувачів для prod
    Set Global Variable         ${tender_owner}   prod_owner
    Set Global Variable         ${tender_owner2}  prod_ssp_owner
    Set Global Variable         ${provider2}      prod_provider2

    Додати першого користувача  ${tender_owner}
    Додати користувача          ${tender_owner2}
    Додати користувача          ${provider2}



Підготувати користувачів для test
    Set Global Variable         ${tender_owner}   PPR_OR
    Set Global Variable         ${tender_owner2}  Bened
    Set Global Variable         ${provider2}      user2

    Додати першого користувача  ${tender_owner}
    Додати користувача          ${tender_owner2}
    Додати користувача          ${provider2}


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
    ${cdb}  Отримати дані тендеру з cdb по id  ${id}
    Set Global Variable  ${cdb}
    actions.Зберегти словник у файл  ${cdb}  cdb


Адаптувати словник data для bids
    ${new dict}  Evaluate  ${data['bids'][0]}.copy()
    Append to list   ${data['bids']}  ${new dict}
    ${new dict}  Evaluate  ${data['bids'][1]['documents'][0]}.copy()
    Append to list   ${data['bids'][1]['documents']}  ${new dict}
    ${new dict}  Evaluate  ${data['bids'][1]['documents'][0]}.copy()
<<<<<<< HEAD
=======
    Append to list   ${data['bids'][1]['documents']}  ${new dict}
    ${new dict}  Evaluate  ${data['bids'][1]['documents'][0]}.copy()
>>>>>>> 8f6927b3270fd29142c717a6198255a60a9fa28d
    Append to list   ${data['bids'][1]['documents']}  ${new dict}


Адаптувати словник data для awards
    ${new dict}  Evaluate  ${data['awards'][0]}.copy()
    Append to list   ${data['awards']}  ${new dict}
    ${new dict}  Evaluate  ${data['awards'][0]['documents'][0]}.copy()
    Append to list  ${data['awards'][0]['documents']}  ${new dict}


Перевірити публікацію кваліфікаційних файлів в ЦБД test
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['awards'][0]['documents'][1]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['bids'][1]['documents'][1]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['bids'][1]['documents'][3]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['awards'][1]['documents'][0]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['contracts'][0]['documents'][0]['title']


<<<<<<< HEAD
Перевірити публікацію кваліфікаційних файлів в ЦБД test
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['awards'][0]['documents'][0]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['bids'][1]['documents'][1]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['bids'][1]['documents'][2]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['awards'][1]['documents'][0]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['contracts'][0]['documents'][0]['title']


Перевірити публікацію кваліфікаційних файлів в ЦБД prod
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['awards'][0]['documents'][0]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['bids'][1]['documents'][1]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['bids'][1]['documents'][2]['title']
=======
Перевірити публікацію кваліфікаційних файлів в ЦБД prod
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['awards'][0]['documents'][1]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['bids'][1]['documents'][1]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['bids'][1]['documents'][3]['title']
>>>>>>> 8f6927b3270fd29142c717a6198255a60a9fa28d
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['awards'][1]['documents'][0]['title']


Перевірити публікацію кваліфікаційних файлів на сторінці користувачами test
<<<<<<< HEAD
    :FOR  ${user}  in  tender_owner  tender_owner2
    \  Завантажити сесію для  ${user}
    \  Go to  ${data['tender_href']}
    \  procurement_tender_detail.Розгорнути всі експандери
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['awards'][0]['documents'][0]['title']
=======
    :FOR  ${user}  in  ${tender_owner}  ${tender_owner2}
    \  Завантажити сесію для  ${user}
    \  Go to  ${data['tender_href']}
    \  procurement_tender_detail.Розгорнути всі експандери
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['awards'][0]['documents'][1]['title']
>>>>>>> 8f6927b3270fd29142c717a6198255a60a9fa28d
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['bids'][1]['documents'][1]['title']
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['bids'][1]['documents'][3]['title']
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['awards'][1]['documents'][0]['title']
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['contracts'][0]['documents'][0]['title']


Перевірити публікацію кваліфікаційних файлів на сторінці користувачами prod
<<<<<<< HEAD
    :FOR  ${user}  in  tender_owner  tender_owner2
    \  Завантажити сесію для  ${user}
    \  Go to  ${data['tender_href']}
    \  procurement_tender_detail.Розгорнути всі експандери
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['awards'][0]['documents'][0]['title']
=======
    :FOR  ${user}  in  ${tender_owner}  ${tender_owner2}
    \  Завантажити сесію для  ${user}
    \  Go to  ${data['tender_href']}
    \  procurement_tender_detail.Розгорнути всі експандери
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['awards'][0]['documents'][1]['title']
>>>>>>> 8f6927b3270fd29142c717a6198255a60a9fa28d
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['bids'][1]['documents'][1]['title']
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['bids'][1]['documents'][3]['title']
    \  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['awards'][1]['documents'][0]['title']
