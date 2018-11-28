*** Variables ***
${item}	          					//*[@class='ivu-row']//div[@class="ivu-card-body"]
${advanced search}                 	//span[contains(text(),'Розгорнути')]


*** Keywords ***
Розгорнути детальний пошук
	Click Element  ${advanced search}


Вибрати тип активу
	[Arguments]  ${text}
	Click Element  xpath=//span[contains(text(),'Оберіть тип активу')]
	Wait Until Page Contains Element  xpath=//li[contains(text(),'${text}')]
	Click Element  xpath=//li[contains(text(),'${text}')]
	Дочекатись закінчення загрузки сторінки(sales spin)


Перейти по результату пошуку за номером
	[Arguments]  ${n}
	${selector}  Set Variable  (${item}//a)[${n}]
	${href}  Get Element Attribute  ${selector}  href
	${href}  Поправити лінку для IP  ${href}
	Go To  ${href}
	Дочекатись закінчення загрузки сторінки(skeleton)


Порахувати активи
	${n}  Get Element Count  ${item}
	[Return]  ${n}