*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Створити словник  data
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot

#  robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None -e get_tender -v site:prod suites/get_auction_href/dutch.robot
*** Test Cases ***
Підготувати користувачів
    Run Keyword If  "${site}" == "prod"  Run Keywords  
    ...  Додати першого користувача  fgv_prod_owner  tender_owner  AND
    ...  Додати користувача          prod_provider1  provider1     AND
    ...  Додати користувача          prod_provider2  provider2     AND
    ...  Додати користувача          prod_viewer     viewer
    Run Keyword If  "${site}" == "test"  Run Keywords
    ...  Додати першого користувача  Bened           tender_owner  AND
    ...  Додати користувача          user1           provider1     AND
    ...  Додати користувача          user2           provider2     AND
    ...  Додати користувача          test_viewer     viewer 


Створити тендер
	[Tags]  create_tender
	Завантажити сесію для  tender_owner
	Run Keyword  Відкрити сторінку Аукціони ФГВ(${site})
	Відкрити вікно створення тендеру
	Wait Until Keyword Succeeds  30  3  create_tender.Вибрати тип процедури  Голландський аукціон
	Заповнити auctionPeriod.startDate
	Заповнити value.amount
	Заповнити minimalStep.percent
	Заповнити dgfDecisionID
	Заповнити dgfDecisionDate
	Заповнити title
	Заповнити dgfID
	Заповнити description
	Заповнити guarantee.amount
	Заповнити items.description
	Заповнити items.quantity
	Заповнити items.unit.name
	Заповнити items.classification.description
	Run Keyword  Заповнити procuringEntity.contactPoint.name.${site}
	Зберегти чернетку
	Оголосити тендер
	Run Keyword  Отримати та зберегти tender_id.${site}
	actions.Зберегти словник у файл  ${data}  data


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Знайти тендер учасником
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  provider1
	Знайти тендер користувачем	provider1
	Зберегти пряме посилання на тендер


Подати заявку на участь в тендері першим учасником
	Подати заявку для подачі пропозиції


Підтвердити заявки на участь
	Завантажити сесію для  tender_owner
	Підтвердити заявки на участь у тендері  ${data['tender_id']}


Отримати поcилання на участь в аукціоні першим учасником
	Завантажити сесію для  provider1
	Go to  ${data['tender_href']}
	Run Keyword If  "${site}" == "test"  Натиснути кнопку "Додати документи"
	Run Keyword If  "${site}" == "test"  Натиснути кнопку "Підтвердити пропозицію"
	${auction_participate_href}  ${auction_href}  Wait Until Keyword Succeeds  10m  5
	...  get_auction_href.Отримати посилання на участь та прегляд аукціону для учасника
	Wait Until Keyword Succeeds  10m  3  Перейти та перевірити сторінку участі в аукціоні  ${auction_participate_href}




*** Keywords ***
Зберегти пряме посилання на тендер
	${tender_href}  Get Location
	Set To Dictionary  ${data}  tender_href  ${tender_href}


Знайти тендер користувачем
	[Arguments]  ${role}
	Завантажити сесію для  ${role}
	Sleep  2
	Відкрити сторінку тестових торгів
	Знайти тендер по ID  ${data['tender_id']}


Отримати та зберегти tender_id.prod
	${tender_id}  Get Element Attribute  xpath=(//a[@href])[2]  text
	Set To Dictionary  ${data}  tender_id=${tender_id}


Отримати та зберегти tender_id.test
	${tender_id}  Get Element Attribute  xpath=(//a[@href])[1]  text
	Set To Dictionary  ${data}  tender_id=${tender_id}


Натиснути кнопку "Додати документи"
    Reload Page
    ${selector}  Set Variable  //a[contains(@class, "btn-success") and contains(text(), "Додати документи")]
    Wait Until Element Is Visible  ${selector}
    Click Element  ${selector}


Натиснути кнопку "Підтвердити пропозицію"
    Wait Until Element Is Visible  //span[contains(text(), "Підтвердити пропозицію")]
    Click Element  //span[contains(text(), "Підтвердити пропозицію")]
    Дочекатись закінчення загрузки сторінки
    Wait Until Element Is Visible  //span[contains(text(), "Так")]
    Click Element  //span[contains(text(), "Так")]
    Дочекатись закінчення загрузки сторінки
    Wait Until Element Is Visible  //a[contains(text(), "Перейти")]
    Open Button  //a[contains(text(), "Перейти")]


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Location Should Contain  bidder_id=
	Підтвердити повідомлення про умови проведення аукціону
	#${status}  Run Keyword And Return Status  Page Should Not Contain  Not Found
	#Run Keyword If  ${status} != ${true}  Sleep  30
	#Run Keyword If  ${status} != ${true}  Перейти та перевірити сторінку участі в аукціоні  ${auction_href}
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
    Go Back


Заповнити auctionPeriod.startDate
	${startDate}  smart_get_time  5
	Wait Until Keyword Succeeds  120  3  Заповнити та перевірити поле с датою  День старту  ${startDate}
	${auctionPeriods}  Create Dictionary  startDate  ${startDate}
	Set To Dictionary  ${data}  auctionPeriods=${auctionPeriods}


Заповнити value.amount
	${amount}  random_number  100000  100000000
	${value}  Create Dictionary  amount=${amount}
	Set To Dictionary  ${data}  value=${value}
	${selector}  Set Variable  xpath=//*[contains(text(), 'Ціна')]/following-sibling::table//input
	Заповнити текстове поле  ${selector}  ${amount}


Заповнити minimalStep.percent
	${minimal_step_percent}  random_number  1  5
	${value}  Create Dictionary  percent=${minimal_step_percent}
	Set To Dictionary  ${data['value']}  minimalStep=${value}users_variables
	Wait Until Keyword Succeeds  120  3  Заповнити та перевірити мінімальний крок аукціону  ${minimal_step_percent}


Заповнити dgfDecisionID
	${id_f}  random_number  1000  9999
	${id_l}  random_number  0  9
	${id}  Set Variable  ${id_f}/${id_l}
	${selector}  Set Variable  xpath=//*[contains(text(), 'Номер')]/following-sibling::table//input
	Заповнити текстове поле  ${selector}  ${id}
	Set To Dictionary  ${data}  dgfDecisionID=${id}


Заповнити dgfDecisionDate
	${time}  smart_get_time  0  d
	Wait Until Keyword Succeeds  120  3  Заповнити та перевірити дату Рішення Дирекції  ${time}
	Set To Dictionary  ${data}  dgfDecisionDate=${time}


Заповнити title
	${text}  create_sentence  5
	${title}  Set Variable  [ТЕСТУВАННЯ] ${text}
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Загальна назва')]/following-sibling::table//input
	Заповнити текстове поле  ${selector}  ${title}
	Set To Dictionary  ${data}  title=${title}


Заповнити dgfID
	${first}  random_number  10000000  99999999
	${second}  random_number  10000  99999
	${dgfID}  Set Variable  F${first}-${second}
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Номер лоту')]/following-sibling::table//input
	Заповнити текстове поле  ${selector}  ${dgfID}
	Set To Dictionary  ${data}  dgfID=${dgfID}


Заповнити description
	${description}  create_sentence  20
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Детальний опис')]/following-sibling::table//textarea
	Заповнити текстове поле  ${selector}  ${description}
	Set To Dictionary  ${data}  description=${description}


Заповнити guarantee.amount
	${guarantee_amount_percent}  random_number  1  5
	Відкрити вкладку Гарантійний внесок
	Wait Until Keyword Succeeds  120  3  Заповнити та перевірити гарантійний внесок  ${guarantee_amount_percent}
	Відкрити вкладку Тестовий аукціон
	Set To Dictionary  ${data['value']}  guarantee_percent=${guarantee_amount_percent}


Заповнити items.description
	[Arguments]  ${field_name}=Опис активу
	${description}  create_sentence  10
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), '${field_name}')]/following-sibling::*//input
	Заповнити текстове поле  ${selector}  ${description}
	${dict}  Create Dictionary  description=${description}
	Set To Dictionary  ${data}  items=${dict}


Заповнити items.quantity
	${quantity}  random_number  1  1000
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Кількість активів')]/following-sibling::*//input
	Заповнити текстове поле  ${selector}  ${quantity}
	Set To Dictionary  ${data['items']}  quantity=${quantity}


Заповнити items.unit.name
	${input}  Set Variable  //*[@id='pcModalMode_PW-1']//span[contains(text(), 'Од. вим.')]/following-sibling::*//input
	${selector}  Set Variable  //*[contains(text(), 'ОВ. Найменування')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
	${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
	${value}  Create Dictionary  name=${name}
	Set To Dictionary  ${data['items']}  unit  ${value}


Заповнити items.classification.description
	${input}  Set Variable  (//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Класифікація')]/following-sibling::div)[2]//input
	${selector}  Set Variable  //*[contains(text(), 'Код класифікації')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
	${description}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
	${value}  Create Dictionary  description=${description}
	Set To Dictionary  ${data['items']}  classification  ${value}


Заповнити procuringEntity.contactPoint.name.prod
	${input}  Set Variable  //*[@id='pcModalMode_PW-1']//span[contains(text(), 'Контактна особа')]/ancestor::*[@class='dxpnlControl_DevEx']/following-sibling::div//*[@class='dhxcombo_input_container ']/input
	${selector}  Set Variable  //*[contains(text(), 'Прізвище')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
	# get from Вибрати та повернути елемент у випадаючому списку
	Click Element  ${input}
	Sleep  .5
	:FOR  ${i}  IN RANGE  10
	\  Wait Until Keyword Succeeds  20  2  Click Element  ${input}
	\  Sleep  .5
	\  ${status}  Run Keyword And Return Status  Element Should Be Visible  ${input}/../following-sibling::*
	\  Exit For Loop If  ${status} == ${true}
	Click Element  ${input}/../following-sibling::*
	Sleep  .5
	Wait Until Page Contains Element  ${selector}  15
	Click Element  (${selector})[1]
	${name}  Get Element Attribute  ${input}  value
	#####################
	${dictionary}  Create Dictionary  name=${name}
	${contactPoint}  Create Dictionary  contactPoint  ${dictionary}
	Set To Dictionary  ${data}  procuringEntity  ${contactPoint}


Заповнити procuringEntity.contactPoint.name.test
	${input}  Set Variable  //*[@id='pcModalMode_PW-1']//span[contains(text(), 'Контактна особа')]/ancestor::*[@class='dxpnlControl_DevEx']/following-sibling::div//*[@class='dhxcombo_input_container ']/input
	${name}  Get Element Attribute  ${input}  value
	Should Not Be Empty  ${name}
	#####################
	${dictionary}  Create Dictionary  name=${name}
	${contactPoint}  Create Dictionary  contactPoint  ${dictionary}
	Set To Dictionary  ${data}  procuringEntity  ${contactPoint}
