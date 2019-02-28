*** Variables ***
${button messages}						xpath=//*[contains(@class,'fa-bell')]
${kontakty block}						//div[@itemscope='itemscope']/div[contains(@class, 'ivu-card')]


*** Keywords ***
Зайти на сторінку povidomlenya
	Click Element  ${button messages}
	Location Should Contain  /povidomlenya/
	loading.Дочекатись закінчення загрузки сторінки
	${header text}  Set Variable  //h1
	${should header}  Set Variable  Повідомлення
	${is header}  Get Text  ${header text}
	Should Be Equal  ${is header}  ${should header}


Перевірити відсутність дзвіночка(povidomlenya)
	Run Keyword And Expect Error  *${button messages}* not found.  Зайти на сторінку povidomlenya


Порахувати кількість контактів
	${count}  Get Element Count  ${kontakty block}
	[Return]  ${count}