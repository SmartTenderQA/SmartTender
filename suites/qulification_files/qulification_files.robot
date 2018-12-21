*** Settings ***
Resource  ../../src/src.robot
Suite Setup     Створити словник  data
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot


#  robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None -e get_tender suites/qulification_files/qulification_files.robot
*** Test Cases ***
Підготувати користувачів
    Додати першого користувача  PPR_OR          tender_owner
    Додати користувача          user1           provider1
    Додати користувача          user2           provider2
    Додати користувача          user3           provider3
    Додати користувача          test_viewer     viewer


Створити тендер
	[Tags]  create_tender
	Завантажити сесію для  tender_owner
	test_below.Створити тендер


Отримати дані тендера та зберегти їх у файл
    [Tags]  create_tender
	Пошук об'єкта у webclient по полю  Узагальнена назва закупівлі  ${data['title']}
    ${tender_uaid}  Отримати tender_uaid вибраного тендера
    ${tender_href}  Отримати tender_href вибраного тендера
    Set To Dictionary  ${data}  tender_uaid  ${tender_uaid}
    Set To Dictionary  ${data}  tender_href  ${tender_href}
    Log  ${tender_href}  WARN
    Зберегти словник у файл  ${data}  data


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact.json
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
