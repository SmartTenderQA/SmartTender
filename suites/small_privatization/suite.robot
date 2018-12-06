*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***

#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output -v user:ssp_tender_owner -v hub:None suites/small_privatization/suite.robot
*** Test Cases ***
Створити об'єкт МП
	small_privatization.Перейти на сторінку малої приватизації
	small_privatization.Перейти на сторінку реєстр об'єктів приватизації
    small_privatization.Перейти до створення об'єкта малої приватизації
	small_privatization_object.Заповнити необхідні поля
	small_privatization_object.Зберегти чернетку об'єкту
	small_privatization_object.Опублікувати об'єкт у реєстрі
	small_privatization_object.Отримати UAID для Об'єкту
	Зберегти словник у файл  ${data}  data


Створити інформаційне повідомлення МП
	Go To  ${start page}
	small_privatization.Перейти на сторінку малої приватизації
	small_privatization.Перейти на сторінку реєстр об'єктів приватизації
	small_privatization.Перейти до створення інформаційного повідомлення
	small_privatization_informational_message.Заповнити необхідні поля 1 етап
	small_privatization_informational_message.Зберегти чернетку повідомлення
	small_privatization_informational_message.Опублікувати інформаційне повідомлення у реєстрі
	small_privatization_informational_message.Перейти до коригування інформації
	small_privatization_informational_message.Заповнити необхідні поля 2 етап
	small_privatization_informational_message.Зберегти чернетку повідомлення
	small_privatization_informational_message.Натиснути передати на перевірку
	Wait Until Keyword Succeeds  5 min  5 sec  small_privatization_informational_message.Дочекатися статусу повідомлення Опубліковано
	small_privatization_informational_message.Отримати UAID для Повідомлення
	Зберегти словник у файл  ${data}  data


Дочекатися початку аукціону
	Wait Until Keyword Succeeds  15 min  10 sec  small_privatization_auction.Дочекатися статусу повідомлення Аукціон
	small_privatization_informational_message.Перейти до аукціону
	small_privatization_auction.Отримати UAID для Аукціону
	Зберегти словник у файл  ${data}  data

	########
	debug


Знайти тендер учасниками
	### case1 ###
	Підготувати учасників
	Знайти аукціон користувачем  provider1
	Зберегти пряме посилання на тендер
	Switch Browser  provider2
	Go To  ${data['tender_href']}


Подати заявки на участь в тендері
	### case2 ###
	:FOR  ${i}  IN  1  2
	\  Switch Browser  provider${i}
	\  Подати заявку для подачі пропозиції


Підтвердити заявки на участь
	Підтвердити заявки на участь у тендері  ${data['tender_id']}


Подати пропозицію
	### case3 ###
	:FOR  ${i}  IN  1  2
	\  Switch Browser  provider${i}
	\  Reload Page
	\  Дочекатись закінчення загрузки сторінки(skeleton)
	\  Перевірити кнопку подачі пропозиції  //*[contains(text(), 'Подача пропозиції')]
	\  Заповнити поле з ціною  1  1
	\  Подати пропозицію
	\  Go Back


Дочекатися початку аукціону першим учасником
	### case4 ###
	Close Browser
	Switch Browser  provider1
	#Дочекатись дати  ${data['auctionPeriods']['startDate']}
	Дочекатися статусу тендера  Аукціон  10m


Отримати поcилання на участь та перегляд аукціону першим учасником
	### case5 ###
	Натиснути кнопку "До аукціону"
	${auction_participate_href}  Wait Until Keyword Succeeds  60  3  Отримати URL для участі в аукціоні
	${auction_href}  			Отримати URL на перегляд
	Set Global Variable  		${auction_href}
	Перевірити сторінку участі в аукціоні  ${auction_participate_href}
	Close Browser


*** Keywords ***
########### kostil #############
case1
	Підготувати учасників
	Знайти аукціон користувачем  provider1
	Зберегти пряме посилання на тендер
	Switch Browser  provider2
	Go To  ${data['tender_href']}


case2
	:FOR  ${i}  IN  1  2
	\  Switch Browser  provider${i}
	\  Подати заявку для подачі пропозиції


case3
	:FOR  ${i}  IN  1  2
	\  Switch Browser  provider${i}
	\  Reload Page
	\  Дочекатись закінчення загрузки сторінки(skeleton)
	\  Перевірити кнопку подачі пропозиції  //*[contains(text(), 'Подача пропозиції')]
	\  Заповнити поле з ціною  1  1
	\  Подати пропозицію
	\  Go Back


case4
	Close Browser
	Switch Browser  provider1
	#Дочекатись дати  ${data['auctionPeriods']['startDate']}
	Дочекатися статусу тендера  Аукціон  10m


case5
	Натиснути кнопку "До аукціону"
	${auction_participate_href}  Wait Until Keyword Succeeds  60  3  Отримати URL для участі в аукціоні
	${auction_href}  			Отримати URL на перегляд
	Set Global Variable  		${auction_href}
	Перевірити сторінку участі в аукціоні  ${auction_participate_href}
	Close Browser
### End kostil ###


Precondition
	${data}  Create Dictionary
	${object}  Create Dictionary
	${message}  Create Dictionary
	${auction}  Create Dictionary
	Set To Dictionary  ${data}  object  ${object}
	Set To Dictionary  ${data}  message  ${message}
	Set To Dictionary  ${data}  auction  ${auction}
	Set Global Variable  ${data}
    Start in grid  ssp_tender_owner  tender_owner
    Go To  ${start_page}


Postcondition
    Log  ${data}
    Close All Browsers


Підготувати організатора
	Run Keyword If  '${site}' == 'test'  Run Keywords
	...  Start  bened  tender_owner1
	...  AND  Go Back
	...  ELSE IF  '${site}' == 'prod'  Run Keywords
	...  Start  prod_tender_owner  tender_owner1
	...  AND  Go Back


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
	...  ELSE IF  '${site}' == 'prod'  Run Keywords
	...       Start  prod_provider  provider3
	...  AND  Start  prod_viewer  viewer


Зберегти пряме посилання на тендер
	${tender_href}  Get Location
	Set To Dictionary  ${data}  tender_href  ${tender_href}


Знайти аукціон користувачем
	[Arguments]  ${role}
	Switch Browser  ${role}
	Sleep  2
	small_privatization.Перейти на сторінку малої приватизації
	Input Text  //input[@placeholder='Введіть фразу для пошуку']  ${data['tender_id']}
	Click Element  //div[@class='ivu-input-group-append']//button[@type='button']
	Дочекатись закінчення загрузки сторінки(skeleton)
	Click Element  //*[@class='panel-body']//*[contains(@class,'xs-7')]
	Дочекатись закінчення загрузки сторінки(skeleton)

