*** Variables ***
${item dogovory}		  	//*[contains(@class, 'container')]//*[contains(@class, 'content-expanded')]/div[2]/*


*** Keywords ***
Перейти по результату пошуку за номером
	[Arguments]  ${n}
	${selector}  Set Variable  xpath=(${item dogovory}//h4/a)[${n}]
	${href}  Get Element Attribute  ${selector}  href
	${href}  Поправити лінку для IP  ${href}
	Go To  ${href}
	Дочекатись закінчення загрузки сторінки(skeleton)


Порахувати кількість торгів
	${count}  Get Element Count  ${item dogovory}
	[Return]  ${count}


Отримати uaid договору за номером
	[Arguments]  ${n}
	${selector}  Set Variable  xpath=(${item dogovory}//h4)[${n}]
	Wait Until Page Contains Element  ${selector}  10
	${id}  Get Text  ${selector}
	[Return]  ${id}