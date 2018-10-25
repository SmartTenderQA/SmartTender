*** Settings ***
Resource  ../../src/src.robot
Resource  ../../src/webclient_keywords.robot
Test Teardown  Test Postcondition
Suite Setup  Suite Precondition
Suite Teardown  Suite Postcondition


*** Variables ***
${button manage tenders}				//*[@title='Управління тендерами']
${button OK}							//*[@data-name="OkButton"]

${tab MAIN}  							//*[contains(@class, "dxtc-activeTab")]//*[@class="dx-vam" and contains(., "ГОЛОВНА")]


*** Test Cases ***
Створити тендер
	[Tags]  create_tende
	Натиснути додати(F7)  Додавання. Тендери
	Заповинити поле дата закінчення прийому пропозиції
	Заповнити поле категорія тендера
	Заповинити поле найменування тендера
	Вибрати вид тендера  Відкриті торги. Аукціон
	Натиснути "Додати"


Створити лоти
	[Tags]  create_tender
	${list}  Create List
	Set To Dictionary  ${data}  lots  ${list}
	${lot}  Create Dictionary
	Append To List  ${data.lots}  ${lot}
	Активувати вкладку  Лоти
	Натиснути додати(F7)  Додавання лотів
	Створити классифікатор ресурсів
	Закрити вікно додавання лотів
	Перевірити створений лот


Перевести тендер на другий єтап
	[Tags]  create_tender
	Активувати вкладку  Тендери
	Натиснути надіслати вперед(Alt+Right)
	Закрити вікно  Запит на комерційну пропозицію_
	Закрити валідаційне вікно  Зберегти документ?  Так
	Підтвердити адреси електронної пошти
	Перевірити стадію тендера  2. Підготовка запиту


Перевести тендер на третій єтап
	[Tags]  create_tender
	Активувати вкладку  Тендери
	Натиснути надіслати вперед(Alt+Right)
	Перевірити стадію тендера  3.Затвердження запиту


Перевести тендер на четвертий єтап
	[Tags]  create_tender
	Активувати вкладку  Тендери
	Натиснути надіслати вперед(Alt+Right)
	Перевірити стадію тендера  4.Прийом комерційних пропозицій (Web-тендер online)


Перевірити посилання до на тендер організатором
	[Tags]  create_tender
	Натиснути на планету потібного тендеру
	Log  ${data}


*** Keywords ***
Suite Precondition
	Start  ${user}
	Wait Until Page Contains Element  ${button manage tenders}
	Click Element  ${button manage tenders}
	Wait Until Page Contains Element  ${button OK}
	Click Element  ${button OK}
	Дочекатись закінчення загрузки сторінки(webclient)
	Wait Until Page Contains Element  ${tab MAIN}


Test Postcondition
	Log Location
	Run Keyword If Test Failed  Capture Page Screenshot
	Log  ${data}
	Set Global Variable  ${data}


##########################################################
Заповинити поле дата закінчення прийому пропозиції
	${date}  smart_get_time  1  d
	${no_weekend}  no_weekend  ${date}
	Wait Until Keyword Succeeds
	...  30
	...  2
	...  Ввести та перевірити введені дані в поле дати
	...  Дата закінч. прийому
	...  ${no_weekend}
	${data}  Create Dictionary  end_date  ${no_weekend}
	Set Global Variable  ${data}


Ввести та перевірити введені дані в поле дати
	[Arguments]  ${field_name}  ${date}
	${date input}  Set Variable
	...  //*[contains(text(), "${field_name}")]/following-sibling::*[@data-type="DateEdit"]//input
	Input Text  ${date input}  ${date}
	Click Element  //*[contains(text(), "${field_name}")]
	${get}  Get Element Attribute  ${date input}  value
	Should Be Equal  ${get}  ${date}


##########################################################
Заповнити поле категорія тендера
	Відкрити вікно(F10)  Категорія тендера  Класифікація
	${classification_name}  Вибрати довільну ЗЕЛЕНУ класифікацію
	Підтвердити вибір(F10)
	Перевірити вибір(F10)  Категорія тендера  ${classification_name}
	Set To Dictionary  ${data}  classification_name  ${classification_name}


Вибрати довільну ЗЕЛЕНУ класифікацію
	${row}  Set Variable  //*[@id="pcModalMode_PW-1"]//tbody//tr[@class]/td[@style="background-color: #D1FFA4"][last()]
	${count}  Get Element Count  ${row}
	${n}  random_number  1  ${count}
	Click Element  (${row})[${n}]
	${classification_name}  Get Text  (${row})[${n}]
	[Return]  ${classification_name}


############################################################
Заповинити поле найменування тендера
	${textarea}  Set Variable  //*[contains(text(), "Найм. тендера")]/following-sibling::table//textarea
	${text}  create_sentence  4
	Input Text  ${textarea}  ${text}
	Press Key  ${textarea}  \\09
	${get}  Get Element Attribute  ${textarea}  value
	Should Be Equal  ${get}  ${text}
	Set To Dictionary  ${data}  tender_name  ${text}


############################################################
Вибрати вид тендера
	[Arguments]  ${tender_type}
	Заповнити поле за допомогою(F10)
	...  Вид тендер
	...  Прості довідники
	...  ${tender_type}
	Set To Dictionary  ${data}  tender_type  ${tender_type}


Заповнити поле за допомогою(F10)
	[Arguments]  ${field_name}  ${window_title}  ${choise_text}
	Відкрити вікно(F10)  ${field_name}   ${window_title}
	Вибрати потрібний вид тендера  ${choise_text}
	Підтвердити вибір(F10)
	Перевірити вибір(F10)  ${field_name}  ${choise_text}


Вибрати потрібний вид тендера
	[Arguments]  ${text}
	Click Element  //td[contains(text(), "${text}")]


############################################################
Створити классифікатор ресурсів
	Відкрити вікно(F10)  Лот  Тендер. Классификатор ресурсов  //*[@id="pcModalMode_PW-1"]
	Натиснути додати(F7)  Додавання. Класифікатор ресурсів  //*[@id="pcModalMode_PW-1"]
	${lot_name}  Заповнити поле найменування для класифікатора
	Set To Dictionary  ${data.lots[0]}  lot_name  ${lot_name}
	Вибрати одиниці виміру для классифікатора ресурсів
	Натиснути "Додати"
	Підтвердити вибір(F10)
	Вказати кількість одиниць виміру для классифікатора ресурсів
	Run Keyword And Ignore Error  Натиснути "Додати"


Заповнити поле найменування для класифікатора
	${input}  Set Variable  //*[contains(text(), "Найменування")]/following-sibling::table//input
	${text}  create_sentence  4
	Input Text  ${input}  ${text}
	Press Key  ${input}  \\13
	${get}  Get Element Attribute  ${input}  value
	Should Be Equal  ${get}  ${text}
	[Return]  ${text}


Вибрати Одиниці виміру для классифікатора ресурсів
	Відкрити вікно(F10)  Облікова ОВ  Одиниці виміру
	${unit_name}  Вибрати довільну одиницю виміру
	Підтвердити вибір(F10)
	Перевірити вибір(F10)  Облікова ОВ  ${unit_name}
	Set To Dictionary  ${data.lots[0]}  unit_name  ${unit_name}


Вибрати довільну одиницю виміру
	${row}  Set Variable  //*[@id="pcModalMode_PW-1"]//table[contains(@class, "cellHorizontalBorders")]//tr[@class]
	${count}  Get Element Count  ${row}
	${n}  random_number  1  ${count}
	Click Element  (${row})[${n}]
	Sleep  2
	${unit_name}  Get Text  (${row})[${n}]//td[3]
	[Return]  ${unit_name}


Вказати кількість одиниць виміру для классифікатора ресурсів
	${input_field}  Set Variable  //*[contains(text(), "Загальний обсяг")]/following-sibling::table//input
	${amount}  random_number  1  1000
	Input Text  ${input_field}  ${amount}
	Press Key  ${input_field}  \\09
	${get}  Get Element Attribute  ${input_field}  value
	${str}  Evaluate  str(int(${get}))
	Should Be Equal  ${str}  ${amount}
	Set To Dictionary  ${data.lots[0]}  unit_amount  ${amount}


Закрити вікно додавання лотів
	${selector}  Set Variable  //*[@id="pcModalMode_PWH-1"]//*[@alt="Close"]
	Click Element  ${selector}
	Wait Until Element Is Not Visible  ${selector}  30


Перевірити створений лот
	Активувати вкладку  Лоти
	Первірити title створеного лоту
	Первірити unit_amount створеного лоту
	Первірити unit_name створеного лоту


Первірити title створеного лоту
	${get}  Get Text  (//*[@class="objbox selectable objbox-scrollable"])[2]//tr[1+1]//td[3]
	Should Be Equal  ${get}  ${data.lots[0].lot_name}


Первірити unit_amount створеного лоту
	${get}  Get Text  (//*[@class="objbox selectable objbox-scrollable"])[2]//tr[1+1]//td[4]
	${int}  Evaluate  str(int(${get}))
	Should Be Equal  ${int}  ${data.lots[0].unit_amount}


Первірити unit_name створеного лоту
	${get}  Get Text  (//*[@class="objbox selectable objbox-scrollable"])[2]//tr[1+1]//td[5]
	Should Be Equal  ${get}  ${data.lots[0].unit_name}


Натиснути на планету потібного тендеру
	Click Element  //tr[contains(@class, "rowselected")]//td[3]
	Wait Until Page Contains Element  //*[@id="pcCustomDialog_PW-1"]//a
	${value}  Get Element Attribute  //*[@id="pcCustomDialog_PW-1"]//a  onclick
	${href}  ${ticket}  get_tender_href_for_commercial_owner  ${value}
	Go To  ${href}${ticket}
	Location Should Contain  ?ticket=
	Set To Dictionary  ${data}  href  ${href}


Підтвердити адреси електронної пошти
	Wait Until Page Contains Element  //*[@data-name="OkButton"]
	Натиснути "Додати"