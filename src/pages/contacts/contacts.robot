*** Variables ***
${button messages}						xpath=//*[contains(@class,'fa-bell')]
${header text}							css=div[itemscope=itemscope] h1
${kontakty block}						//div[@itemscope='itemscope']/div[contains(@class, 'ivu-card')]


*** Keywords ***
Зайти на сторінку povidomlenya
	Click Element  ${button messages}
	Location Should Contain  /povidomlenya/
	${should header}  Set Variable  Контакти SmartTender
	${is header}  Get Text  ${header text}
	Should Be Equal  ${is header}  ${should header}


Перевірити відсутність дзвіночка(povidomlenya)
	Run Keyword And Expect Error  Element with locator '${button messages}' not found.  Зайти на сторінку povidomlenya


Порахувати кількість контактів
	${count}  Get Element Count  ${kontakty block}
	[Return]  ${count}