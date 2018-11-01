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
	Sleep  2
	Відкрити сторінку для створення аукціону на продаж
	Відкрити вікно створення тендеру
	Wait Until Keyword Succeeds  30  3  Вибрати тип процедури  Голландський аукціон
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
	Заповнити procuringEntity.contactPoint.name
	Зберегти чернетку
	Оголосити тендер
	Отримати та зберегти auctionID
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
	viewer
	provider1
	provider2


Подати заявку на участь в тендері першим учасником
	[Tags]  create_tender  get_tender
	Switch Browser  provider1
	Пройти кваліфікацію для подачі пропозиції


Підтвердити заявки на участь
	[Tags]  create_tender  get_tender
	Switch Browser  tender_owner
	Підтвердити заявку  ${data['auctionID']}


Отримати поcилання на участь в аукціоні першим учасником
	[Tags]  create_tender  get_tender
	Switch Browser  provider1
	${auction_href}  Отримати посилання на участь в аукціоні
	Перейти та перевірити сторінку участі в аукціоні  ${auction_href}
	Go Back


Неможливість отримати поcилання на участь в аукціоні
	[Tags]  create_tender1  get_tender
	[Template]  Неможливість отримати поcилання на участь в аукціоні(keyword)
	viewer
	tender_owner
	provider2


*** Keywords ***
Відкрити вікна для всіх користувачів
	Start  fgv_prod_owner  tender_owner
	Go Back
	Start  viewer_prod  viewer
	Start  prod_provider1  provider1
	Start  prod_provider2  provider2
	${data}  Create Dictionary
	Set Global Variable  ${data}


Отримати та зберегти auctionID
	${auctionID}  Get Element Attribute  xpath=(//a[@href])[2]  text
	Set To Dictionary  ${data}  auctionID=${auctionID}


Знайти тендер користувачем
	[Arguments]  ${role}
	Switch Browser  ${role}
	Sleep  2
	Відкрити сторінку тестових торгів
	Знайти тендер по ID  ${data['auctionID']}


Пройти кваліфікацію для подачі пропозиції
	Відкрити бланк подачі заявки
	Додати файл для подачі заявки
	Ввести ім'я для подачі заявки
	Підтвердити відповідність для подачі заявки
	Відправити заявку для подачі пропозиції та закрити валідаційне вікно


Неможливість отримати поcилання на участь в аукціоні(keyword)
	[Arguments]  ${user}
	Switch Browser  ${user}
	Reload Page
	Run Keyword And Expect Error
	...  Element '//button[@type="button" and contains(., "До аукціону")]' did not appear in 5 seconds.
	...  Отримати посилання на участь в аукціоні


Отримати посилання на участь в аукціоні
	Reload Page
	Натиснути кнопку  До аукціону
	Натиснути кнопку  Взяти участь в аукціоні
	${auction_href}  Отримати посилання
	[Return]  ${auction_href}


Натиснути кнопку
	[Arguments]  ${text}
	${selector}  Set Variable  //button[@type="button" and contains(., "${text}")]
	Wait Until Page Contains Element  ${selector}
	Click Element  ${selector}


Отримати посилання
	${selector}  Set Variable  //a[@href and contains(., "До аукціону")]
	Wait Until Page Contains Element  ${selector}  120
	${auction_href}  Get Element Attribute  ${selector}  href
	[Return]  ${auction_href}


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  120
	Location Should Contain  bidder_id=
	Sleep  2
	Element Should Contain  //*[@class="page-header"]//h2  ${data['auctionID']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['description']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['quantity']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['items']['unit']['name']}
	Element Should Contain  //h4  Вхід на даний момент закритий.


Заповнити auctionPeriod.startDate
	${startDate}  smart_get_time  5
	Wait Until Keyword Succeeds  120  3  Заповнити та перевірити дату старту електронного аукціону  ${startDate}
	${auctionPeriods}  Create Dictionary  startDate=${startDate}
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
	Set To Dictionary  ${data.value}  minimalStep=${value}users_variables
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
	Set To Dictionary  ${data.value}  guarantee_percent=${guarantee_amount_percent}


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
	Set To Dictionary  ${data.items}  quantity=${quantity}


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
