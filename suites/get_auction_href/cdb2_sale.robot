*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Відкрити вікна для всіх користувачів
Suite Teardown  Suite Postcondition
Test Teardown  Run Keywords
...  Log Location
...  AND  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${where}							test
${tender}                           Простой однолотовый
${prepared_tender}                  xpath=//tr[@class='head']/td/a[contains(text(), '${tender}') and @href]
${make proposal link}               xpath=//div[@class='row']//a[contains(@class, 'button')]
${start_page}                       http://smarttender.biz
${webClient loading}                id=LoadingPanel
&{type_dict}
...  								rent=Оренда майна
...  								sale=Продаж майна


*** Test Cases ***
Створити тендер
	[Tags]  create_tender
	Switch Browser  tender_owner
	Run Keyword If  '${where}' == 'prod'  Змінити групу  Організатор. Реализация державного майна
	Відкрити сторінку Продаж/Оренда майна(тестові)
	Відкрити вікно створення тендеру

	Вибрати тип процедури  ${type_dict['${type}']}
	Заповнити auctionPeriod.startDate
	Заповнити value.amount
	Заповнити minimalStep.percent
	Заповнити title
	Заповнити dgfID
	Заповнити description
#	Заповнити procuringEntity.contactPoint.name

	Заповнити items.title
	Заповнити items.quantity
	Заповнити items.unit.name
	Заповнити items.classification.description
	Заповнити items.postalcode
	Заповнити items.strretaddress
	Заповнити items.locality

	Заповнити guarantee.amount

	Run Keyword If  '${type}' == 'rent'  Run Keywords
	...  Заповинити rent.duration
	...  AND  Заповнити tender.period
	...  AND  Змінити мінімальну кількусть учасників  1

	Зберегти чернетку
	Оголосити тендер
	Отримати та зберегти tender_id
	Звебегти дані в файл


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Знайти тендер усіма користувачами
	[Tags]  create_tender  get_tender
	[Template]  Знайти тендер користувачем
	tender_owner
	#viewer
	provider1
	provider2


Подати заявку на участь в тендері першим учасником
	[Tags]  create_tender  get_tender
	:FOR  ${i}  IN  1  2
	\  Switch Browser  provider${i}
	\  Пройти кваліфікацію для подачі пропозиції


Підтвердити заявки на участь
	[Tags]  create_tender  get_tender
	Switch Browser  tender_owner
	Підтвердити заявку  ${data['tender_id']}  Для ФГИ


Подати пропозицію
	[Tags]  create_tender  get_tender
	:FOR  ${i}  IN  1  2
	\  Switch Browser  provider${i}
	\  Перевірити кнопку подачі пропозиції  //*[contains(text(), 'Подача пропозиції')]
	\  Заповнити поле з ціною  1  1
	\  Подати пропозицію
	\  Go Back


Дочекатися початку аукціону
	[Tags]  create_tender  get_tender
	:FOR  ${i}  IN  1  2
	\  Switch Browser  provider${i}
	\  Дочекатись дати  ${data['auctionPeriods']['startDate']}
	\  Wait Until Keyword Succeeds  10m  30s  Перевірити статус тендера  Аукціон


Перевірити


*** Keywords ***
Відкрити вікна для всіх користувачів
	Run Keyword If  '${where}' == 'test'  Run Keywords
	...  Start  Bened  tender_owner
	...  AND  Go Back
#	...  AND  Start  viewer_test  viewer
	...  AND  Start  user1  provider1
	...  AND  Start  user2  provider2
#	...  AND  No Operation
	...  ELSE IF  '${where}' == 'prod'  Run Keywords
	...  Start  fgv_prod_owner  tender_owner
	...  AND  Go Back
#	...  AND  Start  viewer_prod  viewer
	...  AND  Start  prod_provider1  provider1
#	...  AND  Start  prod_provider2  provider2
	${data}  Create Dictionary
	Set Global Variable  ${data}


Заповнити auctionPeriod.startDate
	${startDate}  get_time_now_with_deviation  15  minutes
	Wait Until Keyword Succeeds  30  3  Заповнити та перевірити поле с датою  День старту  ${startDate}
	${auctionPeriods}  Create Dictionary  startDate=${startDate}
	Set To Dictionary  ${data}  auctionPeriods  ${auctionPeriods}


Заповнити tender.period
	${tender_period}  get_time_now_with_deviation  30  minutes
	Wait Until Keyword Succeeds  30  3  Заповнити та перевірити поле с датою  Прийом пропозицій по  ${tender_period}
	${tender_period}  Create Dictionary  tender_period  ${tender_period}
	Set To Dictionary  ${data}  tender_period  ${tender_period}


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
	${input}  Set Variable  //*[@id='pcModalMode_PW-1']//span[contains(text(), 'Місто')]/following-sibling::*//input
	${selector}  Set Variable  //*[contains(text(), 'Місто')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
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
	Should Not Be Equal  ${tender_id}  ${EMPTY}
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


Заповнити value.amount
	${amount}  random_number  100000  100000000
	${value}  Create Dictionary  amount=${amount}
	Set To Dictionary  ${data}  value=${value}
	${selector}  Set Variable  xpath=//*[contains(text(), 'Ціна')]/following-sibling::table//input
	Заповнити текстове поле  ${selector}  ${amount}


Заповнити minimalStep.percent
	${minimal_step_percent}  random_number  1  5
	${value}  Create Dictionary  percent=${minimal_step_percent}
	Set To Dictionary  ${data.value}  minimalStep=${value}users_variables
	Wait Until Keyword Succeeds  120  3  Заповнити та перевірити мінімальний крок аукціону  ${minimal_step_percent}


Заповнити title
	${text}  create_sentence  5
	${title}  Set Variable  [ТЕСТУВАННЯ] ${text}
	Set To Dictionary  ${data}  title=${title}
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Загальна назва')]/following-sibling::table//input
	Заповнити текстове поле  ${selector}  ${title}


Заповнити dgfID
	${first}  random_number  10000000  99999999
	${second}  random_number  10000  99999
	${dgfID}  Set Variable  F${first}-${second}
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Номер лоту')]/following-sibling::table//input
	Заповнити текстове поле  ${selector}  ${dgfID}


Заповнити description
	${description}  create_sentence  20
	Set To Dictionary  ${data}  description=${description}
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Детальний опис')]/following-sibling::table//textarea
	Заповнити текстове поле  ${selector}  ${description}


Заповнити guarantee.amount
	${guarantee_amount_percent}  random_number  1  5
	${value}  Create Dictionary  percent=${guarantee_amount_percent}
	Set To Dictionary  ${data.value}  guarantee=${value}
	Відкрити вкладку Гарантійний внесок
	Wait Until Keyword Succeeds  120  3  Заповнити та перевірити гарантійний внесок  ${guarantee_amount_percent}
	Відкрити вкладку Тестовий аукціон


Заповинити rent.duration
	Відкрити вкладку Умови договору оренди
	${rent_duration}  random_number  1  5
	${selector}  Set Variable  //*[@data-name="CONTRTERMSDURATION"]//input
	Wait Until Page Contains Element  ${selector}  10
	Input Text  ${selector}  ${rent_duration}
	Press Key  ${selector}  \\13
	Set To Dictionary  ${data}  rent_duration=${rent_duration}
	Відкрити вкладку Тестовий аукціон


Заповнити items.title
	[Arguments]  ${field_name}=Найменування позиції
	${title}  create_sentence  3
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), '${field_name}')]/following-sibling::*//input
	Заповнити текстове поле  ${selector}  ${title}
	${value}  Create Dictionary  title=${title}
	Set To Dictionary  ${data}  items  ${value}


Заповнити items.quantity
	${quantity}  random_number  1  1000
	${value}  Create Dictionary  quantity=${quantity}
	Set To Dictionary  ${data}  items=${value}
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Кількість активів')]/following-sibling::*//input
	Заповнити текстове поле  ${selector}  ${quantity}


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


Заповнити procuringEntity.contactPoint.name
	${input}  Set Variable  //*[@id='pcModalMode_PW-1']//span[contains(text(), 'Контактна особа')]/ancestor::*[@class='dxpnlControl_DevEx']/following-sibling::div//*[@class='dhxcombo_input_container ']/input
	${selector}  Set Variable  //*[contains(text(), 'Прізвище')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
	${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
	${dictionary}  Create Dictionary  name=${name}
	${contactPoint}  Create Dictionary  contactPoint  ${dictionary}
	Set To Dictionary  ${data}  procuringEntity  ${contactPoint}
