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


Перевірити коректність даних
    [Tags]  view
    Валідація введених даних з ЦБД та на сайті  provider1


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
    Не визнати учасника переможцем  1

Завантажити другим учасником кваліфікаційний документ
    Завантажити сесію для  provider2
    Go to  ${data['tender_href']}
    Додати кваліфікаційний документ


Визнати переможцем другого учасника учасника
    Завантажити сесію для  tender_owner
	Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    Знайти тендер організатором по title  ${data['title']}
    Визначити учасника переможцем else  2


Перевірити відображення кваліфікаційних файлів організатором
    Go to  ${data['tender_href']}
    debug








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


Валідація введених даних з ЦБД та на сайті
    [Arguments]  ${role}
    Завантажити сесію для  ${role}
    Go to  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл

    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['title']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['description']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['tenderID']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['description']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['deliveryAddress']['locality']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['deliveryAddress']['streetAddress']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['deliveryAddress']['postalCode']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['classification']['id']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['classification']['description']
    #procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['unit']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['items'][0]['quantity']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['tenderPeriod']['startDate']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['tenderPeriod']['endDate']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['enquiryPeriod']['endDate']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['value']['amount']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['minimalStep']['amount']

    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['title']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['description']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['tenderID']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['description']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['deliveryAddress']['locality']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['deliveryAddress']['streetAddress']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['deliveryAddress']['postalCode']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['classification']['id']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['classification']['description']
    #procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['unit']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['items'][0]['quantity']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['tenderPeriod']['startDate']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['tenderPeriod']['endDate']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['enquiryPeriod']['endDate']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['value']['amount']
    procurement_tender_detail.Порівняти відображені дані з даними в ЦБД  ['minimalStep']['amount']
