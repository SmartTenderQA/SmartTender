*** Keywords ***
Вибрати довільну ЗЕЛЕНУ класифікацію
	${row}  Set Variable  //*[@id="pcModalMode_PW-1"]//tbody//tr[@class]/td[@style="background-color: #D1FFA4"][last()]
	Wait Until Element Is Visible  ${row}  10
	${count}  Get Element Count  ${row}
	${n}  random_number  1  ${count}
	Click Element  (${row})[${n}]
	Sleep  3
	${classification_name}  Get Text  (${row})[${n}]
	[Return]  ${classification_name}


Заповнити поле найменування для класифікатора
	${input}  Set Variable  //*[contains(text(), "Найменування")]/following-sibling::table//input
	${text}  create_sentence  4
	Input Text  ${input}  ${text}
	Sleep  .5
	Click Element  ${input}
	Sleep  .5
	${get}  Get Element Attribute  ${input}  value
	Should Be Equal  ${get}  ${text}
	[Return]  ${text}


Вибрати одиниці виміру для классифікатора ресурсів
	Відкрити вікно(F10)  Облікова ОВ  Одиниці виміру
	${unit_name}  Вибрати довільну одиницю виміру
	Підтвердити вибір(F10)
	Перевірити вибір(F10)  Облікова ОВ  ${unit_name}
	[Return]  ${unit_name}


Вибрати довільну одиницю виміру
	${row}  Set Variable  //*[@id="pcModalMode_PW-1"]//table[contains(@class, "cellHorizontalBorders")]//tr[@class]
	${count}  Get Element Count  ${row}
	#${n}  random_number  1  ${count}
	${n}  random_number  1  15
	${unit_name}  Вибрати довільну одиницю виміру Click  (${row})[${n}]
	Дочекатись закінчення загрузки сторінки(webclient)
	[Return]  ${unit_name}


Вибрати довільну одиницю виміру Click
	[Arguments]  ${selector}
	${unit_name}  Get Text  ${selector}//td[3]
	Click Element At Coordinates  ${selector}  -30  0
	[Return]  ${unit_name}


Вказати кількість одиниць виміру для классифікатора ресурсів
	${input_field}  Set Variable  //*[contains(text(), "Загальний обсяг")]/following-sibling::table//input
	${amount}  random_number  1  1000
	Input Text  ${input_field}  ${amount}
	Press Key  ${input_field}  \\09
	${get}  Get Element Attribute  ${input_field}  value
	${str}  Evaluate  str(int(${get}))
	Should Be Equal  ${str}  ${amount}
	[Return]  ${amount}