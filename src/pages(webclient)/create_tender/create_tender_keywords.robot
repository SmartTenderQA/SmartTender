*** Keywords ***
Заповнити текстове поле
	[Arguments]  ${selector}  ${text}
	Wait Until Keyword Succeeds  20  2  create_tender_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити та перевірити текстове поле
	[Arguments]  ${selector}  ${text}
	Click Element  ${selector}
	Дочекатись закінчення загрузки сторінки
	Clear input By JS  ${selector}
	Input Text  ${selector}  ${text}
	Дочекатись закінчення загрузки сторінки
	${got}  Get Element Attribute  ${selector}  value
	Click Element  ${selector}
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
    Дочекатись закінчення загрузки сторінки
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


Очистити поле з датою
    [Arguments]  ${selector}
	Click Element  ${selector}
	Click Element  ${selector}/../following-sibling::*
	Click Element  xpath=(//*[contains(text(), 'Очистити')])[last()]
	${value}  Get Element Attribute  ${selector}  value
	${status}  Run Keyword And Return Status  Should Be Empty  ${value}
	Run Keyword If  '${status}' == 'False'  Очистити поле з датою  ${selector}
