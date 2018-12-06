*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Run Keywords  Capture Page Screenshot
...  AND  Log Location

*** Variables ***

#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None suites/small_privatization/suite.robot
*** Test Cases ***
Створити об'єкт МП
	small_privatization.Перейти на сторінку малої приватизації
	small_privatization.Перейти на сторінку реєстр об'єктів приватизації
	small_privatization.Увімкнути тестовий режим (за необхідністю)
    small_privatization.Перейти до створення об'єкта малої приватизації
	small_privatization_object.Заповнити всі обов'язкові поля
	small_privatization_object.Зберегти чернетку об'єкту
	small_privatization_object.Опублікувати об'єкт у реєстрі
	small_privatization_object.Отримати UAID для Об'єкту
	Log To Console  object-UAID=${data['object']['UAID']}


Створити інформаційне повідомлення МП
	small_privatization.Перейти на сторінку малої приватизації
	small_privatization.Перейти на сторінку реєстр об'єктів приватизації
	small_privatization.Перейти до створення інформаційного повідомлення
	small_privatization_informational_message.Заповнити всі обов'язкові поля 1 етап
	small_privatization_informational_message.Зберегти чернетку інформаційного повідомлення
	small_privatization_informational_message.Опублікувати інформаційне повідомлення у реєстрі
	small_privatization_informational_message.Перейти до коригування інформації
	small_privatization_informational_message.Заповнити всі обов'язкові поля 2 етап
	small_privatization_informational_message.Зберегти чернетку інформаційного повідомлення
	small_privatization_informational_message.Передати на перевірку інформаційне повідомлення
	Wait Until Keyword Succeeds  5 min  15 sec  small_privatization_informational_message.Дочекатися статусу повідомлення  Опубліковано
	small_privatization_informational_message.Отримати UAID для Повідомлення
	Log To Console  message-UAID=${data['message']['UAID']}


Дочекатися початку прийому пропозицій
	Wait Until Keyword Succeeds  15 min  30 sec  small_privatization_informational_message.Дочекатися статусу повідомлення  Аукціон
	Wait Until Keyword Succeeds  5 min  15 sec  small_privatization_informational_message.Перейти до аукціону
	small_privatization_auction.Отримати UAID та href для Аукціону
	Log To Console  lot-id=${data['tender_id']}
	Log To Console  lot-href=${data['tender_href']}
	Close Browser


Знайти аукціон учасниками
	Підготувати учасників
	small_privatization_auction.Знайти аукціон користувачем  provider1
	Switch Browser  provider2
	Go To  ${data['tender_href']}


Подати заявки на участь в тендері
	:FOR  ${i}  IN  1  2
	\  Switch Browser  provider${i}
	\  Подати заявку для подачі пропозиції


Підтвердити заявки на участь
	Підтвердити заявки на участь у тендері  ${data['tender_id']}


Подати пропозицію учасниками
	:FOR  ${i}  IN  1  2
	\  Switch Browser  provider${i}
	\  Reload Page
	\  Дочекатись закінчення загрузки сторінки(skeleton)
	\  Перевірити кнопку подачі пропозиції  //*[contains(text(), 'Подача пропозиції')]
	\  Заповнити поле з ціною  1  1
	\  Подати пропозицію
	\  Go Back


Дочекатися початку аукціону
	Switch Browser  provider1
	Wait Until Keyword Succeeds  20 min  30 sec  small_privatization_auction.Дочекатися початку аукціону


Отримати поcилання на участь учасниками
    :FOR  ${i}  IN  1  2
	\  Switch Browser  provider${i}
	\  Натиснути кнопку "До аукціону"
	\  ${viewer_href}  Отримати URL на перегляд
    \  Set To Dictionary  ${data}  viewer_href  ${viewer_href}
	\  ${participate_href}  Wait Until Keyword Succeeds  60  3  Отримати URL для участі в аукціоні
	\  Set To Dictionary  ${data}  provider${i}_participate_href  ${participate_href}
	\  Перейти та перевірити сторінку участі в аукціоні  ${participate_href}


Перевірити неможливість отримати поcилання на участь в аукціоні
	[Setup]  Підготувати глядачів
	[Template]  dutch.Неможливість отримати поcилання на участь в аукціоні(keyword)
	viewer
	tender_owner
	provider3


*** Keywords ***
Precondition
	${data}  Create Dictionary
	${object}  Create Dictionary
	${message}  Create Dictionary
	${auction}  Create Dictionary
	Set To Dictionary  ${data}  object  ${object}
	Set To Dictionary  ${data}  message  ${message}
	Set Global Variable  ${data}
    Start in grid  ssp_tender_owner  tender_owner
    #Go To  ${start_page}


Postcondition
    Log  ${data}
    Close All Browsers


Підготувати учасників
	Run Keyword If  '${site}' == 'test'  Run Keywords
	...       Start  user1  provider1
	...  AND  Start  user2  provider2
	...  ELSE IF  '${site}' == 'prod'  Run Keywords
	...       Start  prod_provider1  provider1
	...  AND  Start  prod_provider2  provider2


Підготувати глядачів
	Run Keyword If  '${site}' == 'test'  Run Keywords
	...       Start  user3  provider3
	...  AND  Start  test_viewer  viewer
	...  AND  Start  Bened  tender_owner
	...  ELSE IF  '${site}' == 'prod'  Run Keywords
	...       Start  prod_provider  provider3
	...  AND  Start  prod_viewer  viewer
	...  AND  Start  prod_tender_owner  tender_owner


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Location Should Contain  bidder_id=
	Підтвердити повідомлення про умови проведення аукціону
	${status}  Run Keyword And Return Status  Page Should Not Contain  Not Found
	Run Keyword If  ${status} != ${true}  Sleep  30
	Run Keyword If  ${status} != ${true}  Перейти та перевірити сторінку участі в аукціоні  ${auction_href}
#	:FOR  ${i}  IN RANGE  50
#	\  ${status}  Run Keyword And Return Status  Page Should Not Contain  Not Found
#	\  Exit For Loop If  ${status} == ${false}
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  20
	Sleep  2
	Element Should Contain  //*[@class="page-header"]//h2  ${data['tender_id']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['description']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['quantity']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['unit']['name']}
	Element Should Contain  //h4  Вхід на даний момент закритий.
