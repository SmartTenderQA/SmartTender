*** Settings ***
Resource  ../../src/src.robot
Library  ../../src/pages/small_privatization/small_privatization_object/small_privatization_object_variables.py
Library  ../../src/pages/small_privatization/small_privatization_informational_message/small_privatization_informational_message_variables.py
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Run Keywords  Capture Page Screenshot
...  AND  Log Location
...  AND  Log  ${data}
...  AND  debug


*** Variables ***

#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output --noncritical compare -v user:ssp_tender_owner -v hub:None suites/small_privatization/small_privatization.robot
#robot --consolecolors on -L TRACE:INFO -d test_output --noncritical compare -e -prod -v user:prod_ssp_owner -v hub:None suites/small_privatization/small_privatization.robot
*** Test Cases ***
Створити об'єкт МП
	Завантажити сесію для  tender_owner
	Завантажити variables.py для об'єкта
	small_privatization_step.Створити об'єкт МП
	small_privatization_object.Отримати UAID для Об'єкту
	small_privatization_object.Отримати ID у цбд
	${location}  Get Location
	Log To Console  url=${location}
	Зберегти словник у файл  ${data}  asset


Перевірити дані про об'єкт в ЦБД
	[Tags]  compare
	${cdb_data}  Отримати дані об'єкту приватизації з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  asset_cdb_data
	small_privatization_object.Перевірити всі обов'язкові поля в цбд


Перевірити відображення детальної інформації про об'єкт
	[Tags]  compare
	dzk_auction.Розгорнути детальну інформацію по всіх полях (за необхідністю)
	small_privatization_object.Перевірити відображення всіх обов'язкових полів на сторінці об'єкту


Створити інформаційне повідомлення МП
	[Setup]  Go To  ${start page}
	Завантажити variables.py для інформаційного повідомлення
	small_privatization_step.Створити інформаційне повідомлення МП  ${cdb_data['assetID']}
	small_privatization_informational_message.Дочекатися статусу повідомлення  Опубліковано  5 min
	small_privatization_object.Отримати ID у цбд
	${location}  Get Location
	Log To Console  url=${location}
	Зберегти словник у файл  ${data}  message


Перевірити дані про інформаційне повідомлення в ЦБД
	[Tags]  compare
	${cdb_data}  Отримати дані інформаційного повідомлення приватизації з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  message_cdb_data
	small_privatization_informational_message.Перевірити всі обов'язкові поля в цбд


Перевірити відображення детальної інформації про інформаційне повідомлення
	[Tags]  compare
	dzk_auction.Розгорнути детальну інформацію по всіх полях (за необхідністю)
	small_privatization_informational_message.Перевірити відображення всіх обов'язкових полів на сторінці аукціону


Дочекатися початку прийому пропозицій
	[Tags]  -prod
	small_privatization_informational_message.Дочекатися статусу повідомлення  Аукціон  15 min
	small_privatization_informational_message.Дочекатися опублікування посилання на лот  15 min
	small_privatization_informational_message.Перейти до аукціону
	small_privatization_auction.Отримати UAID та href для Аукціону
	Log To Console  lot-id=${data['tender_id']}
	Log To Console  lot-href=${data['tender_href']}
	Зберегти сесію  tender_owner


Знайти аукціон учасниками
	[Tags]  -prod
	Знайти аукціон користувачем  provider1
	Зберегти сесію  provider1
	Завантажити сесію для  provider2
	Go To  ${data['tender_href']}
	Зберегти сесію  provider2


Подати заявки на участь в тендері
	[Tags]  -prod
	:FOR  ${i}  IN  1  2
	\  Завантажити сесію для  provider${i}
	\  Подати заявку для подачі пропозиції


Підтвердити заявки на участь
	[Tags]  -prod
	Підтвердити заявки на участь у тендері  ${data['tender_id']}


Подати пропозицію учасниками
	[Tags]  -prod
	:FOR  ${i}  IN  1  2
	\  Завантажити сесію для  provider${i}
	\  Reload Page
	\  Дочекатись закінчення загрузки сторінки(skeleton)
	\  Натиснути на кнопку подачі пропозиції
	\  Заповнити поле з ціною  1  1
	\  Подати пропозицію


Дочекатися початку аукціону
	[Tags]  -prod
	Завантажити сесію для  provider1
	small_privatization_auction.Дочекатися статусу лота  Аукціон  20 min


Отримати поcилання на участь учасниками
	[Tags]  -prod
    :FOR  ${i}  IN  1  2
	\  Завантажити сесію для  provider${i}
	\  Reload Page
	\  Дочекатись закінчення загрузки сторінки(skeleton)
	\  Натиснути кнопку "До аукціону"
	\  ${viewer_href}  Отримати URL на перегляд
    \  Set To Dictionary  ${data}  viewer_href  ${viewer_href}
	\  ${participate_href}  Wait Until Keyword Succeeds  60  3  Отримати URL для участі в аукціоні
	\  Set To Dictionary  ${data}  provider${i}_participate_href  ${participate_href}
	\  Перейти та перевірити сторінку участі в аукціоні  ${participate_href}
	\  Go Back


Перевірити неможливість отримати поcилання на участь в аукціоні
	[Tags]  -prod
	[Template]  Неможливість отримати поcилання на участь в аукціоні глядачем
	viewer
	tender_owner2
	provider3


*** Keywords ***
Precondition
	Додати першого користувача  ${user}  tender_owner
    Підготувати користувачів


Завантажити variables.py для об'єкта
	${edit_locators}  small_privatization_object_variables.get_edit_locators
	${view_locators}  small_privatization_object_variables.get_view_locators
	${data}  small_privatization_object_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}


Завантажити variables.py для інформаційного повідомлення
	${edit_locators}  small_privatization_informational_message_variables.get_edit_locators
	${view_locators}  small_privatization_informational_message_variables.get_view_locators
	${data}  small_privatization_informational_message_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}


Postcondition
    Log  ${data}
    Close All Browsers


Підготувати користувачів
    Run Keyword If  "${site}" == "prod"  Run Keywords
    ...  Додати користувача			 prod_tender_owner  tender_owner2 	AND
    ...  Додати користувача          prod_provider  	provider1     	AND
    ...  Додати користувача          prod_provider1  	provider2     	AND
    ...  Додати користувача          prod_provider2  	provider3     	AND
    ...  Додати користувача          prod_provider2  	provider3     	AND
    ...  Додати користувача          prod_viewer     	viewer
    Run Keyword If  "${site}" == "test"  Run Keywords
    ...  Додати користувача			 test_tender_owner	tender_owner2 	AND
    ...  Додати користувача          user1           	provider1     	AND
    ...  Додати користувача          user2           	provider2     	AND
    ...  Додати користувача          user3           	provider3     	AND
    ...  Додати користувача          test_viewer     	viewer


Знайти аукціон користувачем
	[Arguments]  ${role}
	Завантажити сесію для  ${role}
	Sleep  2
	start_page.Натиснути На торговельний майданчик
	old_search.Активувати вкладку ФГИ
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	new_search.Очистити фільтр пошуку
	new_search.Очистити фільтр пошуку
	new_search.Ввести фразу для пошуку  ${data['tender_id']}
	new_search.Натиснути кнопку пошуку
	Дочекатись закінчення загрузки сторінки(skeleton)
	new_search.Перейти по результату пошуку за номером  1
	Дочекатись закінчення загрузки сторінки(skeleton)


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Location Should Contain  bidder_id=
	Підтвердити повідомлення про умови проведення аукціону
	${status}  Run Keyword And Return Status  Page Should Not Contain  Not Found
	Run Keyword If  ${status} != ${true}  Sleep  30
	Run Keyword If  ${status} != ${true}  Перейти та перевірити сторінку участі в аукціоні  ${auction_href}
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  20
	Sleep  2
	Element Should Contain  //*[@class="page-header"]//h2  ${data['tender_id']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['object']['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['object']['item']['description']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['object']['item']['count']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['object']['item']['unit']}
	Element Should Contain  //h4  Вхід на даний момент закритий.


Неможливість отримати поcилання на участь в аукціоні глядачем
	[Arguments]  ${user}
	Завантажити сесію для  ${user}
	Go to  ${data['tender_href']}
	Дочекатись закінчення загрузки сторінки(skeleton)
	${auction_participate_href}  Run Keyword And Expect Error  *  Run Keywords
	...  Натиснути кнопку "До аукціону"
	...  AND  Отримати URL для участі в аукціоні


Натиснути на кнопку подачі пропозиції
    ${button}  Set Variable  //*[contains(text(), 'Подача пропозиції')]
    Page Should Contain Element  ${button}
    Open button  ${button}
    Location Should Contain  /edit/
    Wait Until Keyword Succeeds  5m  3  Run Keywords
    ...  Reload Page  AND
    ...  Element Should Not Be Visible  //*[@class='modal-dialog ']//h4
