*** Settings ***
Resource  ../../src/src.robot
#Variables  ../../src/pages/procurement_tender_detail_page/procurement_variables.py

Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot

#  robot --consolecolors on -L TRACE:INFO -d test_output -e get_tender suites/get_auction_href/test_dialog_get_auction_href.robot
*** Test Cases ***
Підготувати користувачів
    Додати першого користувача  Bened           tender_owner
    Додати користувача          user1           provider1
    Додати користувача          user2           provider2
    Додати користувача          user3           provider3
    Додати користувача          user4           provider4
    Додати користувача          test_viewer     viewer


Створити тендер
	[Tags]  create_tender
	Завантажити сесію для  tender_owner
	test_dialog.Створити тендер
    test_dialog.Отримати дані тендера та зберегти їх у файл


Отримати дані з cdb
    [Tags]  create_tender
    Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact_data.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


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


Подати заявку на участь в тендері трьома учасниками на 1-му етапі
	:FOR  ${i}  IN  1  2  3
	\  Завантажити сесію для  provider${i}
	\  Прийняти участь у тендері учасником на 1-му етапі  provider${i}


Підготувати користувача та дочекатись початку періоду перкваліфікації
    Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
    Дочекатись початку періоду перкваліфікації


Відкрити браузер під роллю організатора та знайти тендер
    Завантажити сесію для  tender_owner
	Перейти у розділ (webclient)  Конкурентний діалог(тестові)
    Знайти тендер організатором по title  ${data['title']}


Підтвердити прекваліфікацію всіх учасників
    Провести прекваліфікацію учасників
    Підтвердити організатором формування протоколу розгляду пропозицій


Підготувати користувача та дочекатись очікування рішення організатора
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
    Wait Until Keyword Succeeds  20m  10  Дочекатись закінчення періоду прекваліфікації
    Дочекатися статусу тендера  Очікування рішення організатора


Виконати дії для переведення тендера на 2-ий етап
    Завантажити сесію для  tender_owner
    Перейти у розділ (webclient)  Конкурентний діалог(тестові)
    Знайти тендер організатором по title  ${data['title']}
    Wait Until Keyword Succeeds  3m  3  Перейти до другої фази
    Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Завершено
    Завантажити сесію для  tender_owner
    Перейти у розділ (webclient)  Конкурентний діалог(тестові)
    Знайти тендер організатором по title  ${data['title']}
    Вибрати тендер за номером (webclient)  2
    Wait Until Keyword Succeeds  3m  3  Перейти до другого етапу
    Опублікувати процедуру


Отримати дані тендера та зберегти їх у файл
    [Tags]  create_tender
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
	Знайти тендер організатором по title  ${data['title']}
    ${tenderID}  Отримати tender_uaid вибраного тендера
    ${tender_href}  Отримати tender_href вибраного тендера
    Set To Dictionary  ${data}  tenderID  ${tenderID}
    Set To Dictionary  ${data}  tender_href  ${tender_href}
    Log  ${tender_href}  WARN
    Зберегти словник у файл  ${data}  data


Подати заявку на участь в тендері трьома учасниками на 2-му етапі
	:FOR  ${user}  IN  provider1  provider2  provider3
	\  Прийняти участь у тендері учасником  ${user}


Отримати поcилання на участь в аукціоні для учасників
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
    Дочекатись закінчення прийому пропозицій
	Дочекатися статусу тендера  Аукціон
    Wait Until Keyword Succeeds  180  3  Перевірити отримання ссилки на участь в аукціоні  provider1


Неможливість отримати поcилання на участь в аукціоні
	[Template]  Перевірити можливість отримати посилання на аукціон користувачем
	viewer
	tender_owner
	provider4



*** Keywords ***
Отримати дані з cdb та зберегти їх у файл
    [Tags]  create_tender
    ${id}  procurement_tender_detail.Отритами дані зі сторінки  ['id']
    ${cdb}  Отримати дані тендеру з cdb по id  ${id}
    Set Global Variable  ${cdb}
    Зберегти словник у файл  ${cdb}  cdb


Прийняти участь у тендері учасником
    [Arguments]  ${role}
    Завантажити сесію для  ${role}
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Прийом пропозицій
    Run Keyword If  '${role}' == 'provider1'  Sleep  3m
    Подати пропозицію учасником


Прийняти участь у тендері учасником на 1-му етапі
    [Arguments]  ${role}
    Завантажити сесію для  ${role}
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Прийом пропозицій
    Run Keyword If  '${role}' == 'provider1'  Sleep  3m
    Подати пропозицію учасником на 1-му етапі


Подати пропозицію учасником
	Перевірити кнопку подачі пропозиції
	Заповнити поле з ціною  1  1
    Додати файл  1
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
    Go Back


Подати пропозицію учасником на 1-му етапі
	Перевірити кнопку подачі пропозиції
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
    Go Back


Перевірити отримання ссилки на участь в аукціоні
    [Arguments]  ${role}
    Завантажити сесію для  ${role}
    Go To  ${data['tender_href']}
    Натиснути кнопку "До аукціону"
	${auction_participate_href}  Отримати URL для участі в аукціоні
	Wait Until Keyword Succeeds  60  3  Перейти та перевірити сторінку участі в аукціоні  ${auction_participate_href}


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Location Should Contain  bidder_id=
	Підтвердити повідомлення про умови проведення аукціону
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  30
	Sleep  2
	Element Should Contain  //*[@class="page-header"]//h2  ${data['tenderID']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items'][0]['description']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items'][0]['quantity']}
	#Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items'][0]['unit']}
	Element Should Contain  //h4  Вхід на даний момент закритий.
    Go Back


Перевірити можливість отримати посилання на аукціон користувачем
	[Arguments]  ${role}
	Завантажити сесію для  ${role}
	Go to  ${data['tender_href']}
	${auction_participate_href}  Run Keyword And Expect Error  *  Run Keywords
	...  Натиснути кнопку "До аукціону"
	...  AND  Отримати URL для участі в аукціоні