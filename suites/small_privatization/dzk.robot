*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Close All Browsers
Test Setup  Stop The Whole Test Execution If Previous Test Failed
Test Teardown  Run Keyword If Test Failed  Run Keywords  Capture Page Screenshot
...  AND  Log Location
...  AND  Log  ${data}


*** Variables ***
${dzk_variables}			${CURDIR}/../../src/pages/dzk/dzk_variables.py


#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output -v user:USER_DZK -v hub:None -e -test suites/small_privatization/dzk.robot
*** Test Cases ***
Створити аукціон
	Завантажити сесію для  tender_owner
	dzk_step.Створити аукціон
	dzk_auction.Отримати UAID та href для Аукціону
	dzk_auction.Отримати ID у цбд
	Зберегти словник у файл  ${data}  data
	Log To Console  url=${data['tender_href']}


Отримати дані з цбд та перевірити їх відповідність
	${cdb_data}  Отримати дані Аукціону ДЗК з cdb по id  ${data['id']}
	Set Global Variable  ${cdb_data}
	Зберегти словник у файл  ${cdb_data}  cdb_data
	dzk_auction.Перевірити всі обов'язкові поля в цбд


Перевірити відображення детальної інформації
	Дочекатися довантаження даних з ЦБД
	dzk_auction.Розгорнути детальну інформацію по всіх полях (за необхідністю)
	dzk_auction.Перевірити відображення всіх обов'язкових полів на сторінці аукціону


Знайти аукціон учасниками
	[Tags]  -prod
	Знайти аукціон користувачем  provider1
	Зберегти сесію  provider1
	Завантажити сесію для  provider2
	Go To  ${data['tender_href']}
	Зберегти сесію  provider2
	Sleep  90


Подати заявки на участь в тендері
	[Tags]  -prod
	:FOR  ${i}  IN  1  2
	\  Завантажити сесію для  provider${i}
	\  Подати заявку для подачі пропозиції


Підтвердити заявки на участь
	[Tags]  -prod
	Підтвердити заявки на участь у тендері  ${data['auctionID']}


Подати пропозицію учасниками
	[Tags]  -prod  -test
	:FOR  ${i}  IN  1  2
	\  Завантажити сесію для  provider${i}
	\  Дочекатись закінчення загрузки сторінки(skeleton)
	\  Натиснути на кнопку подачі пропозиції
	\  Заповнити поле сума пропозиції  1  1
	\  Додати документ, що підтверджує кваліфікацію
	\  Натиснути Подати пропозицію


Дочекатися початку аукціону
	[Tags]  -prod  -test
	Завантажити сесію для  provider1
	small_privatization_auction.Дочекатися статусу лота  Аукціон  35 min


Отримати поcилання на участь учасниками
	[Tags]  -prod  -test
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
	[Tags]  -prod  -test
	[Template]  Неможливість отримати поcилання на участь в аукціоні глядачем
	viewer
	tender_owner2
	provider3


*** Keywords ***
Precondition
	Import Variables  ${dzk_variables}
    Додати першого користувача  ${user}  tender_owner
    Підготувати користувачів


Підготувати користувачів
    Run Keyword If  "${site}" == "prod"  Run Keywords
    ...  Додати користувача			 prod_tender_owner  tender_owner2 	AND
    ...  Додати користувача          prod_provider  	provider1     	AND
    ...  Додати користувача          prod_provider1  	provider2     	AND
    ...  Додати користувача          prod_provider2  	provider3     	AND
    ...  Додати користувача          prod_viewer     	viewer
    Run Keyword If  "${site}" == "test"  Run Keywords
    ...  Додати користувача			 test_tender_owner	tender_owner2 	AND
    ...  Додати користувача          user1           	provider1     	AND
    ...  Додати користувача          user2           	provider2     	AND
    ...  Додати користувача          user3           	provider3     	AND
    ...  Додати користувача          test_viewer     	viewer


Дочекатися довантаження даних з ЦБД
	Sleep  10
	Reload Page
	Дочекатись закінчення загрузки сторінки(skeleton)
	${title locator}  Set Variable  ${view_locators['title']}
	${title}  Get Text  ${title locator}
	${status}  Run Keyword And Return Status  Should Contain  ${title}  [ТЕСТУВАННЯ]
	Run Keyword If  ${status} == ${False}
	...  Дочекатися довантаження даних з ЦБД


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
	new_search.Ввести фразу для пошуку  ${data['id']}
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
	Element Should Contain  //*[@class="page-header"]//h2  ${data['auctionID']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['0']['description']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['0']['quantity']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['0']['unit']['name']}
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


Заповнити поле сума пропозиції
  [Documentation]  takes lot number and coefficient
  ...  fill bid field with max available price
  [Arguments]  ${lot number}  ${coefficient}
  ${block number}  Set Variable  ${lot number}+1
  ${a}=  Get Text  ${block}[${block number}]//div[@class='amount lead'][1]
  ${a}=  get_number  ${a}
  ${amount}=  Evaluate  int(${a}*${coefficient})
  ${field number}=  Evaluate  ${lot number}-1
  Input Text  xpath=//*[@id="lotAmount${field number}"]/input[1]  ${amount}


Додати документ, що підтверджує кваліфікацію
	${selector}  Set Variable  //*[@document-caption='Документ']
	Створити та додати файл  ${selector}//input
	Click Element  ${selector}//*[@class='dropdown']
	Click Element  ${selector}//*[contains(text(),'Документи, що підтверджують кваліфікацію')]


Натиснути Подати пропозицію
	Click Element  ${send offer button}
	${ok button}  Set Variable  //*[@class='ivu-poptip-inner' and contains(.,'Анулювати пропозицію буде неможливо, подати пропозицію?')]//button[contains(.,'Так')]
	Wait Until Element Is Visible  ${ok button}
	Click Element  ${ok button}