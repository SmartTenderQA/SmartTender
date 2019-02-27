*** Variables ***
${novyny title}					//h1[@class="text-center"]
${news block}					//*[contains(@class, 'ivu-row-undefined-space-between')]
${news search input}			css=.ivu-card-body input
${news search button}			//div[contains(@class,"search-btn")]


*** Keywords ***
Перевірити заголовок сторінки з новинами
	${should}  Set Variable  Новини
	${is}  Get Text  ${novyny title}
	Should Be Equal  ${is}  ${should}


Порахувати кількість новин
	${count}  Get Element Count  ${news block}
	[Return]  ${count}


Отримати заголовк новини за номером
	[Arguments]  ${n}
	${text}  Get Text  (${news block})[${n}]//a[1]
	[Return]  ${text}


Ввести текст для пошуку
	[Arguments]  ${text}
	Input text  ${news search input}  ${text}


Виконати пошук
	[Arguments]  ${action}=click
	Run Keyword If  '${action}' == 'click'
	...  Click Element  ${news search button}  ELSE IF
	...  '${action}' == 'press'
	...  Press Key  ${news search input}  \\13
	Дочекатись закінчення загрузки сторінки


Відкрити новину за номером
	[Arguments]  ${n}
	Open Button  (${news block})[${n}]//a[1]
	${header}  Get Text  css=h1
	Should Not Be Empty  ${header}
	${news}  Get Text  css=#News
	Should Not Be Empty  ${news}


Отримати заголовок відкритої новини
	${title}  Get Text  css=h1
	[Return]  ${title}