*** Settings ***
Resource   ../../src/src.robot
Variables  src/pages/procurement_tender_detail_page/procurement_variables.py
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot


#  robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None -e get_tender suites/qulification_files/qulification_files.robot
*** Test Cases ***
Підготувати користувачів
    Додати першого користувача  PPR_OR          tender_owner
    #Додати користувача          Bened           tender_owner2
    Додати користувача          user1           provider1
    #Додати користувача          user2           provider2
    #Додати користувача          user3           provider3



Створити тендер
	[Tags]  create_tender
	${data}  create_dict_below
	Завантажити сесію для  tender_owner
	debug
	test_below.Створити тендер
	test_below.Отримати дані тендера та зберегти їх у файл


Перевірити коректність даних
    [Tags]  create_tender
    Перевірка відображення даних тендера на сторінці


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


Перевірка відображення даних тендера на сторінці
    [Arguments]  ${role}
    Завантажити сесію для  ${role}
    Go to  ${data['tender_href']}
    Перевірити коректність даних на сторінці  ['title']
    Перевірити коректність даних на сторінці  ['description']
    Перевірити коректність даних на сторінці  ['tender_uaid']
    Перевірити коректність даних на сторінці  ['item']['title']
    Перевірити коректність даних на сторінці  ['item']['city']
    Перевірити коректність даних на сторінці  ['item']['streetAddress']
    Перевірити коректність даних на сторінці  ['item']['postal code']
    Перевірити коректність даних на сторінці  ['item']['id']
    Перевірити коректність даних на сторінці  ['item']['id title']
    #Перевірити коректність даних на сторінці  ['item']['unit']
    Перевірити коректність даних на сторінці  ['item']['quantity']
    Перевірити коректність даних на сторінці  ['tenderPeriod']['startDate']
    Перевірити коректність даних на сторінці  ['tenderPeriod']['endDate']
    Перевірити коректність даних на сторінці  ['enquiryPeriod']['endDate']
    Перевірити коректність даних на сторінці  ['value']['amount']
    Перевірити коректність даних на сторінці  ['value']['minimalStep']['percent']
