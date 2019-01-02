*** Settings ***
Resource   ../../src/src.robot
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot

#  robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None -e get_tender suites/qulification_files/qulification_files.robot
*** Test Cases ***
Підготувати користувачів
    Додати першого користувача  PPR_OR          tender_owner
    Додати користувача          Bened           tender_owner2
    Додати користувача          user1           provider1
    Додати користувача          user2           provider2
    Додати користувача          user3           provider3


Створити тендер
	[Tags]  create_tender
	Завантажити сесію для  tender_owner
	test_below.Створити тендер
	test_below.Отримати дані тендера та зберегти їх у файл


Отримати дані з cdb
    [Tags]  create_tender
    Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл


Валідфція введених даних з даними в ЦБД
    [Tags]  view
    [Template]  procurement_tender_detail.Порівняти введені дані з даними в ЦБД
    \['title']
    \['description']
    \['tenderID']
    \['items'][0]['description']
    \['items'][0]['deliveryAddress']['locality']
    \['items'][0]['deliveryAddress']['streetAddress']
    \['items'][0]['deliveryAddress']['postalCode']
    \['items'][0]['classification']['id']
    \['items'][0]['classification']['description']
    \['items'][0]['unit']
    \['items'][0]['quantity']
    \['tenderPeriod']['startDate']
    \['tenderPeriod']['endDate']
    \['enquiryPeriod']['endDate']
    \['value']['amount']
    \['minimalStep']['amount']


Валідфція даних на сторінці з даними в ЦБД
    [Tags]  view
    [Template]  procurement_tender_detail.Порівняти відображені дані з даними в ЦБД
    \['title']
    \['description']
    \['tenderID']
    \['items'][0]['description']
    \['items'][0]['deliveryAddress']['locality']
    \['items'][0]['deliveryAddress']['streetAddress']
    \['items'][0]['deliveryAddress']['postalCode']
    \['items'][0]['classification']['id']
    \['items'][0]['classification']['description']
    \['items'][0]['unit']
    \['items'][0]['quantity']
    \['tenderPeriod']['startDate']
    \['tenderPeriod']['endDate']
    \['enquiryPeriod']['endDate']
    \['value']['amount']
    \['minimalStep']['amount']


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact_data.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Подати заявку на участь в тендері учасниками
	:FOR  ${i}  IN  1  2  3
	\  Прийняти участь у тендері учасником  provider${i}
	Дочекатись закінчення прийому пропозицій
	Дочекатися статусу тендера  Кваліфікація


Відхилити організатором пропозицію першого учасника
    Завантажити сесію для  tender_owner
	Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    Знайти тендер організатором по title  ${data['title']}
    ${negative result file name}  Не визнати учасника переможцем  1
    Set To Dictionary  ${data['awards'][0]['documents'][0]}  title  ${negative result file name}


Завантажити другим учасником кваліфікаційний документ
    Завантажити сесію для  provider2
    Go to  ${data['tender_href']}
    ${provider file name}  Додати кваліфікаційний документ
    ${new dict}  Evaluate  ${data['bids'][0]}.copy()
    Append to list   ${data['bids']}  ${new dict}
    ${new dict}  Evaluate  ${data['awards'][0]['documents'][0]}.copy()
    Append to list   ${data['awards'][0]['documents']}  ${new dict}
    Set To Dictionary  ${data['bids'][1]['documents'][1]}  title  ${provider file name}


Визнати переможцем другого учасника учасника
    Завантажити сесію для  tender_owner
	Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    Знайти тендер організатором по title  ${data['title']}
    ${positive result file name}  Визначити учасника переможцем else  2
    ${new dict}  Evaluate  ${data['awards'][0]}.copy()
    Append to list   ${data['awards']}  ${new dict}
    Set To Dictionary  ${data['awards'][1]['documents'][0]}  title  ${positive result file name}


Перевірити відображення кваліфікаційних файлів організатором
    Go to  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл
    Зберегти словник у файл  ${data}  data
    Розгорнути всі експандери
    debug
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['awards'][0]['documents'][0]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['bids'][1]['documents'][1]['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['awards'][1]['documents'][0]['title']

    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['awards'][0]['documents'][0]['title']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['bids'][1]['documents'][1]['title']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['awards'][1]['documents'][0]['title']



*** Keywords ***
Прийняти участь у тендері учасником
    [Arguments]  ${role}
    Завантажити сесію для  ${role}
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Прийом пропозицій
    Run Keyword If  '${role}' == 'provider1'  Sleep  3m
    Подати пропозицію учасником


Подати пропозицію учасником
	Перевірити кнопку подачі пропозиції
	Заповнити поле з ціною  1  1
    Додати файл  1
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
    Go Back


Розгорнути всі експандери
    ${selector down}  Set Variable  //*[contains(@class,"expander")]/i[contains(@class,"down")]
    ${count}  Get Element Count  ${selector down}
    Run Keyword If  ${count} != 0  Run Keywords
    ...  Repeat Keyword  ${count} times  Click Element  ${selector down}  AND
    ...  Розгорнути всі експандери


Отримати дані з cdb та зберегти їх у файл
    ${id}  procurement_tender_detail.Отритами дані зі сторінки  ['id']
    ${cdb}  Отримати дані тендеру з cdb по id  ${id}
    Set Global Variable  ${cdb}
    Зберегти словник у файл  ${cdb}  cdb