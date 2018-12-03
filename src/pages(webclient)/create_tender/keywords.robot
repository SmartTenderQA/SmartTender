*** Keywords ***
Заповнити текстове поле
	[Arguments]  ${selector}  ${text}
	Run Keyword If  '${site}' == 'test'
	...  Wait Until Keyword Succeeds  10  2  Заповнити та перевірити текстове поле  ${selector}  ${text}
	...  ELSE IF  '${site}' == 'prod'
	...  Wait Until Keyword Succeeds  10  2  Заповнити Поле  ${selector}  ${text}


Заповнити та перевірити текстове поле
	[Arguments]  ${selector}  ${text}
	Click Element  ${selector}
	Sleep  .5
	Clear Element Text  ${selector}
	Input Text  ${selector}  ${text}
	${got}  Get Element Attribute  ${selector}  value
	Press Key  ${selector}  \\13
	Should Be Equal  ${got}  ${text}


Вибрати та повернути елемент у випадаючому списку
	[Arguments]  ${input}  ${selector}
	Click Element  ${input}
	Sleep  .5
	Run Keyword And Ignore Error  Click Element  ${input}/../following-sibling::*
	Sleep  .5
	Wait Until Page Contains Element  ${selector}  15
	${count}  Get Element Count  ${selector}
	${number}  random_number  1  ${count}
	Click Element  (${selector})[${number}]
	${text}  Get Element Attribute  ${input}  value
	Should Not Be Empty  ${text}
	[Return]  ${text}


Заповнити Поле
    [Arguments]  ${selector}  ${text}
    Wait Until Page Contains Element  ${selector}
    Click Element  ${selector}
    Sleep  .5
    Input Text  ${selector}  ${text}
    Sleep  .5
    Press Key  ${selector}  \\09
    Sleep  1


Вибрати довільну персону з довідника персоналу
	${row}  Set Variable  //*[@title="Прізвище"]/ancestor::div[@class="gridbox-vertical-flex gridbox-main"]//tr[contains(@class, "Row")]
    ${count}  Get Element Count  ${row}
	${n}  random_number  1  ${count}
	Click Element  (${row})[${n}]
	Sleep  1
	Підтвердити вибір(F10)


Додати документ до тендара власником (webclient)
    Перейти на вкладку документи (webclient)
    Додати документ власником