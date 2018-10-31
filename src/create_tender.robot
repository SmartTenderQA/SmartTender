*** Settings ***
Library     Collections
Library     service.py
Library     Faker/faker.py



*** Keywords ***
Відкрити сторінку для створення аукціону на продаж
  Click Element  xpath=//*[contains(text(), 'Аукціони на продаж')]
  Wait Until Keyword Succeeds  120  3  Element Should Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору торгів')]
  Wait Until Keyword Succeeds  20  2  Click Element  xpath=//*[contains(text(), 'OK')]
  Wait Until Keyword Succeeds  120  3  Element Should Not Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору торгів')]


Відкрити сторінку Продаж/Оренда майна(тестові)
  Wait Until Page Contains Element  xpath=//*[contains(text(), 'ProZorro.Продажі')]  15
  Click Element  xpath=//*[contains(text(), 'ProZorro.Продажі')]
  Wait Until Keyword Succeeds  120  3  Element Should Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору торгів')]
  Wait Until Keyword Succeeds  20  2  Click Element  xpath=//*[contains(text(), 'OK')]
  Wait Until Keyword Succeeds  120  3  Element Should Not Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору торгів')]


Відкрити сторінку для створення публічних закупівель
  Wait Until Page Contains Element  xpath=//*[contains(text(), 'Публичные закупки')]  120
  Wait Until Keyword Succeeds  120  3  Натиснути кнопку публічних закупівель
  Wait Until Keyword Succeeds  20  2  Click Element  xpath=//*[contains(text(), 'OK')]
  Wait Until Keyword Succeeds  120  3  Element Should Not Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору')]


Відкрити сторінку заявок на участь в аукціоні
  Wait Until Page Contains Element  //div[contains(@title, 'Заявки на участие в Аукционах')]  120
  Wait Until Keyword Succeeds  120  3  Click Element  //div[contains(@title, 'Заявки на участие в Аукционах')]
  Дочекатись закінчення загрузки сторінки(webclient)
  Element Should Not Be Visible  //div[contains(@title, 'Заявки на участие в Аукционах')]
  Element Should Be Visible  //td[contains(text(), "Заявки на участие в торгах ФГВ")]


Натиснути кнопку публічних закупівель
  Run Keyword And Ignore Error  Click Element  xpath=//*[contains(text(), 'Повторить попытку')]
  Run Keyword And Ignore Error  Click Element  xpath=//*[contains(text(), 'Публичные закупки')]
  Element Should Be Visible  xpath=//*[@style="position:relative;"]//*[contains(text(), 'Умова відбору')]


Пошук об'єкта у webclient по полю
  [Arguments]  ${UAID}  ${field}=Номер тендер
  ${count}  Set Variable  count(//div[@class="gridbox"]//div[@style]//div[contains(text(), '${field}')]/ancestor::td[@draggable]/preceding-sibling::*)
  ${find tender field}  Set Variable  xpath=(//div[contains(@id, 'MainSted2PageControl') and @style='']//tr[@class=' has-system-column'])[1]/td[${count}+1]//input
  Click Element  ${find tender field}
  Input Text  ${find tender field}  ${UAID}
  ${get}  Get Element Attribute  ${find tender field}  value
  ${status}  Run Keyword And Return Status  Should Be Equal  ${get}  ${UAID}
  Run Keyword If  '${status}' == 'False'  Пошук об'єкта у webclient по полю  ${UAID}
  Press Key  ${find tender field}  \\13
  Sleep  3


Відкрити вікно створення тендеру
  Wait Until Keyword Succeeds  30  3  Run Keywords
  ...  Click Element  xpath=//*[contains(text(), 'Додати')]
  ...  AND  Wait Until Element Is Not Visible  ${webClient loading}  120
  ...  AND  Wait Until Keyword Succeeds  120  3  Element Should Be Visible  xpath=//*[contains(text(), 'Процедура')]/following-sibling::table


Вибрати тип процедури
	[Arguments]  ${type}
	Click Element  xpath=//*[contains(text(), 'Процедура')]/following-sibling::table
	Click Element  xpath=//*[@class='dxeListBoxItemRow_DevEx']/td[contains(text(), '${type}')]
	${taken}  Get Element Attribute  xpath=//*[contains(text(), 'Процедура')]/following-sibling::table//td[2]//input  value
	${status}  Run Keyword And Return Status  Should Be Equal  ${taken}  ${type}
	Run Keyword If  '${status}' == 'False'  Вибрати тип процедури  ${type}


Змінити мінімальну кількусть учасників
	[Arguments]  ${quantity}
  	Click Element  xpath=//*[contains(text(), 'Мінімальна кількість')]/following-sibling::table
    Click Element  xpath=//*[@class='dxeListBoxItemRow_DevEx']/td[contains(text(), '1')]
  	${taken}  Get Element Attribute  xpath=//*[contains(text(), 'Мінімальна кількість')]/following-sibling::table//td[2]//input  value
  	Should Be Equal  ${taken}  ${quantity}
  	Set To Dictionary  ${data}  minimum_number_of_participants  ${quantity}


Заповнити auctionPeriod.startDate
  ${startDate}  smart_get_time  5
  Wait Until Keyword Succeeds  120  3  Заповнити та перевірити дату старту електронного аукціону  ${startDate}
  ${value}  Create Dictionary  startDate=${startDate}
  ${auctionPeriod}  Create Dictionary  auctionPeriod=${value}
  Set To Dictionary  ${data}  auctionPeriod=${auctionPeriod}


Заповнити та перевірити дату старту електронного аукціону
  [Arguments]  ${time}
  ${text}  convert_data_for_web_client  ${time}
  # очистити поле с датою
  Click Element  xpath=//*[contains(text(), 'День старту')]/following-sibling::table//input
  Click Element  xpath=//*[contains(text(), 'День старту')]/following-sibling::table//input/../following-sibling::*
  Click Element  xpath=(//*[contains(text(), 'Очистити')])[last()]
  # заповнити дату
  Input Text  xpath=//*[contains(text(), 'День старту')]/following-sibling::table//input    ${text}
  ${got}  Get Element Attribute  xpath=//*[contains(text(), 'День старту')]/following-sibling::table//input  value
  Should Be Equal  ${got}  ${time}


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


Заповнити та перевірити мінімальний крок аукціону
  [Arguments]  ${minimal_step_percent}
  ${selector}  Set Variable  xpath=(//*[contains(text(), 'Мінімальний крок аукціону')]/following-sibling::table)[2]//input
  Click Element  ${selector}
  Input Text  ${selector}  ${minimal_step_percent}
  Press Key  ${selector}  \\13
  ${got}  Get Element Attribute  ${selector}  value
  ${got}  Evaluate  str(int(${got}))
  Should Be Equal  ${got}  ${minimal_step_percent}


Заповнити dgfDecisionID
  ${id_f}  random_number  1000  9999
  ${id_l}  random_number  0  9
  ${id}  Set Variable  ${id_f}/${id_l}
  Set To Dictionary  ${data}  dgfDecisionID=${id}
  ${selector}  Set Variable  xpath=//*[contains(text(), 'Номер')]/following-sibling::table//input
  Заповнити текстове поле  ${selector}  ${id}


Заповнити dgfDecisionDate
  ${time}  smart_get_time  0  d
  Set To Dictionary  ${data}  dgfDecisionDate=${time}
  Wait Until Keyword Succeeds  120  3  Заповнити та перевірити дату Рішення Дирекції  ${time}


Заповнити та перевірити дату Рішення Дирекції
  [Arguments]  ${time}
  ${text}  convert_data_for_web_client  ${time}
  ${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Дата')]/following-sibling::table//input
  # очистити поле с датою
  Click Element  ${selector}
  Click Element  ${selector}/../following-sibling::*
  Click Element  xpath=(//*[contains(text(), 'Очистити')])[last()]
  # заповнити дату
  Input Text  ${selector}    ${text}
  ${got}  Get Element Attribute  ${selector}  value
  Should Be Equal  ${got}  ${time}


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


Заповнити та перевірити гарантійний внесок
  [Arguments]  ${percent}
  ${selector}  Set Variable  xpath=//*[@data-name="GUARANTEE_AMOUNT_PERCENT"]//input
  Input Text  ${selector}  ${percent}
  Press Key  ${selector}  \\13
  ${got}  Get Element Attribute  ${selector}  value
  ${got}  Evaluate  str(int(${got}))
  Should Be Equal  ${got}  ${percent}


Відкрити вкладку Гарантійний внесок
  ${selector}  Set Variable  xpath=//span[contains(text(), 'Гарантійний внесок')]
  Run Keyword And Ignore Error  Click Element  ${selector}
  ${status}  Run Keyword And Return Status  Element Should Not Be Visible  ${selector}
  Run Keyword If  '${status}' != 'True'  Відкрити вкладку Гарантійний внесок


Відкрити вкладку Тестовий аукціон
  ${selector}  Set Variable  xpath=//span[contains(text(), 'Тестовий аукціон')]
  Run Keyword And Ignore Error  Click Element  ${selector}
  ${status}  Run Keyword And Return Status  Element Should Not Be Visible  ${selector}
  Run Keyword If  '${status}' != 'True'  Відкрити вкладку Тестовий аукціон



Заповнити items.title
	[Arguments]  ${field_name}=Найменування позиції
	${title}  create_sentence  3
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), '${field_name}')]/following-sibling::*//input
	Заповнити текстове поле  ${selector}  ${title}
	${value}  Create Dictionary  title=${title}
	Set To Dictionary  ${data}  items  ${value}


Заповнити items.description
	[Arguments]  ${field_name}=Опис активу
	${description}  create_sentence  10
	${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), '${field_name}')]/following-sibling::*//input
	Заповнити текстове поле  ${selector}  ${description}
	${value}  Create Dictionary  description=${description}
	Set To Dictionary  ${data}  items  ${value}


Заповнити items.quantity
  ${quantity}  random_number  1  1000
  ${value}  Create Dictionary  quantity=${quantity}
  Set To Dictionary  ${data}  items=${value}
  ${selector}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Кількість активів')]/following-sibling::*//input
  Заповнити текстове поле  ${selector}  ${quantity}


Заповнити items.unit.name
  ${input}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Од. вим.')]/following-sibling::*//input
  ${selector}  Set Variable  xpath=//*[contains(text(), 'ОВ. Найменування')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
  ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
  ${value}  Create Dictionary  name=${name}
  Set To Dictionary  ${data['items']}  unit  ${value}


Заповнити items.classification.description
  ${input}  Set Variable  xpath=(//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Класифікація')]/following-sibling::div)[2]//input
  ${selector}  Set Variable  xpath=//*[contains(text(), 'Код класифікації')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
  ${description}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
  ${value}  Create Dictionary  description=${description}
  Set To Dictionary  ${data['items']}  classification  ${value}


Заповнити procuringEntity.contactPoint.name
  ${input}  Set Variable  xpath=//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Контактна особа')]/ancestor::*[@class='dxpnlControl_DevEx']/following-sibling::div//*[@class='dhxcombo_input_container ']/input
  ${selector}  Set Variable  xpath=//*[contains(text(), 'Прізвище')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
  ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
  ${dictionary}  Create Dictionary  name=${name}
  ${contactPoint}  Create Dictionary  contactPoint  ${dictionary}
  Set To Dictionary  ${data}  procuringEntity  ${contactPoint}


Зберегти чернетку
  Click Element  xpath=//*[@id='pcModalMode_PW-1']//*[contains(text(), 'Додати')]
  Sleep  3
  Wait Until Element Is Not Visible  ${webClient loading}  120
  Wait Until Element Is Not Visible  xpath=//*[@id='pcModalMode_PW-1']//*[contains(text(), 'Додати')]


Оголосити тендер
  Click Element  xpath=//*[@class='dxr-lblContent']/*[contains(text(), 'Надіслати вперед')]
  Sleep  3
  Wait Until Element Is Not Visible  ${webClient loading}  120
  Click Element  xpath=//*[@class='message-box']//*[contains(text(), 'Так')]
  Wait Until Element Is Not Visible  xpath=//*[@class='message-box']//*[contains(text(), 'Так')]
  Sleep  3
  Wait Until Element Is Not Visible  ${webClient loading}  120


################################################################
#                                                              #
#                     *** Keywords ***                         #
#                                                              #
################################################################
Заповнити текстове поле
  [Arguments]  ${selector}  ${text}
  Wait Until Keyword Succeeds  30  3  Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити та перевірити текстове поле
  [Arguments]  ${selector}  ${text}
  Click Element  ${selector}
  Sleep  .5
  Input Text  ${selector}  ${text}
  ${got}  Get Element Attribute  ${selector}  value
  Should Be Equal  ${got}  ${text}


Вибрати та повернути елемент у випадаючому списку
  [Arguments]  ${input}  ${selector}
  Click Element  ${input}
  Sleep  .5
  Run Keyword And Ignore Error  Click Element  ${input}/../following-sibling::*
  Sleep  .5
  ${count}  Get Element Count  ${selector}
  ${number}  random_number  1  ${count}
  Click Element  ${selector}[${number}]
  ${text}  Get Element Attribute  ${input}  value
  Should Not Be Empty  ${text}
  [Return]  ${text}


Звебегти дані в файл
	${json}  conver dict to json  ${data}
	Create File  ${OUTPUTDIR}/artifact.json  ${json}