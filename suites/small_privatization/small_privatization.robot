*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Setup  Stop The Whole Test Execution If Previous Test Failed
Test Teardown  Run Keyword If Test Failed  Run Keywords  Capture Page Screenshot
...  AND  Log Location
...  AND  Log  ${data}


*** Variables ***

#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output -v user:ssp_tender_owner -v hub:None suites/small_privatization/small_privatization.robot
*** Test Cases ***
Створити об'єкт МП
	Завантажити сесію для  tender_owner
	start_page.Натиснути На торговельний майданчик
	old_search.Активувати вкладку ФГИ
	small_privatization_search.Активувати вкладку  Реєстр об'єктів приватизації
	small_privatization_search.Вибрати режим сторінки об'єктів приватизації  Кабінет
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	small_privatization_search.Натиснути створити  об'єкт
	small_privatization_object.Заповнити всі обов'язкові поля
	small_privatization_object.Прикріпити документ
	small_privatization_object.Натиснути кнопку зберегти
	small_privatization_object.Опублікувати об'єкт у реєстрі
	small_privatization_object.Отримати UAID для Об'єкту
	Log To Console  object-UAID=${data['object']['UAID']}


Створити інформаційне повідомлення МП
	[Setup]  Go To  ${start page}
	start_page.Натиснути На торговельний майданчик
	old_search.Активувати вкладку ФГИ
	small_privatization_search.Активувати вкладку  Реєстр об'єктів приватизації
	small_privatization_search.Вибрати режим сторінки об'єктів приватизації  Кабінет
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	small_privatization_search.Натиснути створити  інформаційне повідомлення
	small_privatization_informational_message.Заповнити всі обов'язкові поля 1 етап
	small_privatization_informational_message.Прикріпити документ
	small_privatization_informational_message.Зберегти чернетку інформаційного повідомлення
	small_privatization_informational_message.Опублікувати інформаційне повідомлення у реєстрі
	small_privatization_informational_message.Перейти до коригування інформації
	small_privatization_informational_message.Заповнити всі обов'язкові поля 2 етап
	small_privatization_informational_message.Зберегти чернетку інформаційного повідомлення
	small_privatization_informational_message.Передати на перевірку інформаційне повідомлення
	small_privatization_informational_message.Дочекатися статусу повідомлення  Опубліковано  5 min
	small_privatization_informational_message.Отримати UAID для Повідомлення
	Log To Console  message-UAID=${data['message']['UAID']}


Дочекатися початку прийому пропозицій
	[Tags]  -prod
	small_privatization_informational_message.Дочекатися статусу повідомлення  Аукціон  15 min
	small_privatization_informational_message.Дочекатися опублікування посилання на лот  15 min
	small_privatization_informational_message.Перейти до аукціону
	small_privatization_auction.Отримати UAID та href для Аукціону
	Log To Console  lot-id=${data['tender_id']}
	Log To Console  lot-href=${data['tender_href']}


Знайти аукціон учасниками
	[Tags]  -prod
	Знайти аукціон користувачем  provider1
	Завантажити сесію для  provider2
	Go To  ${data['tender_href']}


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
	\  Go Back


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
	${data}  Create Dictionary
	${object}  Create Dictionary
	${message}  Create Dictionary
	Set To Dictionary  ${data}  object  ${object}
	Set To Dictionary  ${data}  message  ${message}
	Set Global Variable  ${data}
	Додати першого користувача  ${user}  tender_owner
    Підготувати користувачів


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
