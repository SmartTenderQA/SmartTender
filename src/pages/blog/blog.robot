*** Variables ***
${blog}							//*[@class='ivu-card-body']/*[contains(@class,'ivu-row')]
${blog input}					css=.ivu-card-body input
${blog search button}			css=.ivu-card-body button


*** Keywords ***
Перевірити загловок блогу
   Element Should Contain  //h1  Блог


Порахувати кількість блогів
	${count}  Get Element Count  ${blog}
	[Return]  ${count}


Отримати назву блогу за номером
	[Arguments]  ${n}
	${text}  Get Text  (${blog})[${n}]//a
	[Return]  ${text}


Ввести текст для пошуку
	[Arguments]  ${text}
	Input Text  ${blog input}  ${text}
	${get}  Get Element Attribute  ${blog input}  value
	Should Be Equal  ${get}  ${text}


Виконати пошук
	Click Element  ${blog search button}
	Дочекатись закінчення загрузки сторінки


Відкрити Блог за номером
	[Arguments]  ${n}
	Open Button  (${blog})[${n}]//a
	Page Should Contain Element  css=#NewsContent


Отримати заголовок відкритого блогу
	${title}  Get Text  //h1
	[Return]  ${title}
