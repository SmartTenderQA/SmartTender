*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Відкрити вікна для всіх користувачів
Suite Teardown  Suite Postcondition
Test Teardown  Run Keywords
...  Log Location
...  AND  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${tender}                           Простой однолотовый
${prepared_tender}                  xpath=//tr[@class='head']/td/a[contains(text(), '${tender}') and @href]
${make proposal link}               xpath=//div[@class='row']//a[contains(@class, 'button')]
${start_page}                       http://smarttender.biz
${webClient loading}                id=LoadingPanel


*** Test Cases ***
Створити тендер
	[Tags]  create_tender
	Switch Browser  tender_owner
	Змінити групу  Організатор. Реализация державного майна
	Відкрити сторінку Продаж/Оренда майна(тестові)
	Відкрити вікно створення тендеру

	Вибрати тип процедури  Оренда майна
	Заповнити auctionPeriod.startDate
	Заповнити value.amount
	Заповнити minimalStep.percent
	Змінити мінімальну кількусть учасників  1
	Заповнити title
	Заповнити dgfID
	Заповнити description
	Заповнити procuringEntity.contactPoint.name

	Заповнити items.title
	Заповнити items.quantity
	Заповнити items.unit.name
	Заповнити items.classification.description
	Заповнити items.postalcode
	Заповнити items.strretaddress
	Заповнити items.locality

	Заповнити guarantee.amount

	Зберегти чернетку
	Оголосити тендер
	Отримати та зберегти tender_id
	Звебегти дані в файл


If skipped create tender
	[Tags]  get_tender_data
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Знайти тендер усіма користувачами
	[Tags]  create_tender  get_tender_data
	[Template]  Знайти тендер користувачем
	tender_owner
	#viewer
	provider1
	#provider2


Подати заявку на участь в тендері першим учасником
	[Tags]  create_tender  get_tender_data
	Switch Browser  provider1
	Пройти кваліфікацію для подачі пропозиції


Підтвердити заявки на участь
	[Tags]  create_tender  get_tender_data
	Switch Browser  tender_owner
	Підтвердити заявку  ${data['tender_id']}  spf


Подати пропозицію
	[Tags]  create_tender  get_tender_data
	debug


*** Keywords ***
Відкрити вікна для всіх користувачів
	Start  fgv_prod_owner  tender_owner
	Go Back
	#Start  viewer_prod  viewer
	Start  prod_provider1  provider1
	#Start  prod_provider2  provider2
	${data}  Create Dictionary
	Set Global Variable  ${data}


Заповнити auctionPeriod.startDate
	${startDate}  get_time_now_with_deviation  20  minutes
	Wait Until Keyword Succeeds  120  3  Заповнити та перевірити дату старту електронного аукціону  ${startDate}
	${value}  Create Dictionary  startDate=${startDate}
	${auctionPeriod}  Create Dictionary  auctionPeriod=${value}
	Set To Dictionary  ${data}  auctionPeriod  ${auctionPeriod}


Заповнити items.postalcode
	${postalcode}  random_number  10000  99999
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Індекс')]/following-sibling::table//input
	Заповнити текстове поле  ${selector}  ${postalcode}
	${dict}  Create Dictionary
	Set To Dictionary  ${data}  items  ${dict}
	Set To Dictionary  ${data['items']}  postalcode  ${postalcode}


Заповнити items.strretaddress
	${text}  create_sentence  1
	${strretaddress}  Set Variable  ${text[:-1]}
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Вулиця')]/following-sibling::table//input
	Заповнити текстове поле  ${selector}  ${strretaddress}
	Set To Dictionary  ${data['items']}  strretaddress  ${strretaddress}


Заповнити items.locality
	${input}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Місто')]/following-sibling::*//input
	${selector}  Set Variable  xpath=//*[contains(text(), 'Місто')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
	${locality}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
	Set To Dictionary  ${data['items']}  locality  ${locality}


Вибрати довільне місто
	${row}  Set Variable  //*[@id="pcModalMode_PW-1"]//table[contains(@class, "cellHorizontalBorders")]//tr[@class]
	${count}  Get Element Count  ${row}
	${n}  random_number  1  ${count}
	${unit_name}  Вибрати довільне місто Click  (${row})[${n}]
	[Return]  ${locality}


Вибрати довільне місто Click
	[Arguments]  ${selector}
	Click Element At Coordinates  ${selector}  -30  0
	Sleep  2
	${unit_name}  Get Text  ${selector}//td[2]
	${status}  Run Keyword And Return Status  Page Should Contain Element   ${selector}[contains(@class, 'selected')]
	Run Keyword If  ${status} != ${True}  Вибрати довільне місто Click  ${selector}
	[Return]  ${locality}


Отримати та зберегти tender_id
	${tender_id}  Get Element Attribute  xpath=(//a[@href])[2]  text
	Set To Dictionary  ${data}  tender_id=${tender_id}


Знайти тендер користувачем
	[Arguments]  ${role}
	Switch Browser  ${role}
	Sleep  2
	Відкрити сторінку тестових торгів
	Знайти тендер по ID  ${data['tender_id']}


Пройти кваліфікацію для подачі пропозиції
	Відкрити бланк подачі заявки
	Додати файл для подачі заявки
	Ввести ім'я для подачі заявки
	Підтвердити відповідність для подачі заявки
	Відправити заявку для подачі пропозиції та закрити валідаційне вікно