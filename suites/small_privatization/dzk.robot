*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Close All Browsers
#Test Setup  Stop The Whole Test Execution If Previous Test Failed
Test Teardown  Run Keyword If Test Failed  Run Keywords  Capture Page Screenshot
...  AND  Log Location
...  AND  Log  ${dzk_data}
...  AND  debug


*** Variables ***

#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None suites/small_privatization/dzk.robot
*** Test Cases ***
Створити аукціон
	start_page.Натиснути На торговельний майданчик
	old_search.Активувати вкладку ФГИ
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	dzk_auction.Натиснути створити аукціон
	dzk_auction.Заповнити всі обов'язкові поля
	dzk_auction.Натиснути кнопку зберегти
	dzk_auction.Опублікувати аукціон у реєстрі
	debug
	dzk_auction.Отримати UAID та href для Аукціону
	dzk_auction.Отримати ID у цбд
	Зберегти словник у файл  ${dzk_data}  dzk_data


Отримати дані з цбд та перевірити їх відповідність
	${cdb_data}  Отримати дані Аукціону ДЗК з cdb по id  ${dzk_data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  cdb_data
	debug
	dzk_auction.Перевірити всі обов'язкові поля в цбд


#Перевірити відображення детальної інформації
#	dzk_auction.Перевірити відображення детальної інформації


Знайти аукціон учасниками
	[Tags]  -prod
#	debug
	Підготувати учасників
#	Знайти аукціон користувачем  provider1
	Switch Browser  provider1
	Go To  ${dzk_data['tender_href']}
	Switch Browser  provider2
	Go To  ${dzk_data['tender_href']}
	Switch Browser  provider3
	Go To  ${dzk_data['tender_href']}


Подати заявки на участь в тендері
	[Tags]  -prod
	:FOR  ${i}  IN  1  3
	\  Switch Browser  provider${i}
	\  Подати заявку для подачі пропозиції


Підтвердити заявки на участь
	[Tags]  -prod
	Підтвердити заявки на участь у тендері  ${dzk_data['auctionID']}


Подати пропозицію учасниками
	[Tags]  -prod
	:FOR  ${i}  IN  1  3
	\  Switch Browser  provider${i}
	\  Reload Page
	\  Дочекатись закінчення загрузки сторінки(skeleton)
	\  Натиснути на кнопку подачі пропозиції
	\  Заповнити поле з ціною  1  1
	\  Подати пропозицію
	\  Click Element  //button[contains(.,'Так')]
	\  Go Back


Дочекатися початку аукціону
	[Tags]  -prod
	Switch Browser  provider1
	small_privatization_auction.Дочекатися статусу лота  Аукціон  20 min


Отримати поcилання на участь учасниками
	[Tags]  -prod
    :FOR  ${i}  IN  1  3
	\  Switch Browser  provider${i}
	\  Натиснути кнопку "До аукціону"
	\  ${viewer_href}  Отримати URL на перегляд
    \  Set To Dictionary  ${dzk_data}  viewer_href  ${viewer_href}
	\  ${participate_href}  Wait Until Keyword Succeeds  60  3  Отримати URL для участі в аукціоні
	\  Set To Dictionary  ${dzk_data}  provider${i}_participate_href  ${participate_href}
	\  Перейти та перевірити сторінку участі в аукціоні  ${participate_href}
	\  Close Browser


Перевірити неможливість отримати поcилання на участь в аукціоні
	[Tags]  -prod
	[Setup]  Підготувати глядачів
	[Template]  Неможливість отримати поcилання на участь в аукціоні глядачем
	viewer
	tender_owner
	provider4


*** Keywords ***
Precondition
    Start  USER_DZK  tender_owner


Натиснути особистий кабінет
	Page Should Contain Element  ${personal account}
	Click Element  ${personal account}
	Дочекатись закінчення загрузки сторінки


Підготувати учасників
	Run Keyword If  '${site}' == 'test'  Run Keywords
	...       Start  user1  provider1
	...  AND  Start  user2  provider2
	...  AND  Start  user3  provider3
	...  ELSE IF  '${site}' == 'prod'  Run Keywords
	...       Start  prod_provider  provider1
	...  AND  Start  prod_provider1  provider2
	...  AND  Start  prod_provider2  provider3


Підготувати глядачів
	Run Keyword If  '${site}' == 'test'  Run Keywords
	...       Start  user3  provider4
	...  AND  Start  test_viewer  viewer
	...  AND  Start  Bened  tender_owner
	...  ELSE IF  '${site}' == 'prod'  Run Keywords
	...       Start  prod_provider  provider4
	...  AND  Start  prod_viewer  viewer
	...  AND  Start  prod_tender_owner  tender_owner


Знайти аукціон користувачем
	[Arguments]  ${role}
	Switch Browser  ${role}
	Sleep  2
	start_page.Натиснути На торговельний майданчик
	old_search.Активувати вкладку ФГИ
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	new_search.Очистити фільтр пошуку
	new_search.Очистити фільтр пошуку
	new_search.Ввести фразу для пошуку  ${dzk_data['auctionID']}
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
	Element Should Contain  //*[@class="page-header"]//h2  ${dzk_data['auctionID']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${dzk_data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['0']['description']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['0']['quantity']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['0']['unit']['name']}
	Element Should Contain  //h4  Вхід на даний момент закритий.


Неможливість отримати поcилання на участь в аукціоні глядачем
	[Arguments]  ${user}
	Switch Browser  ${user}
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
