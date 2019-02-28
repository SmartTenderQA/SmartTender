*** Variables ***
${item plan}                         //tr[@data-planid]//a


*** Keywords ***
Порахувати кількість плану
	Select Frame  css=iframe
	${count}  Get Element Count  ${item plan}
	Unselect Frame
	[Return]  ${count}


Перейти по результату пошуку за номером
	[Arguments]  ${n}
	Select Frame  css=iframe
	${selector}  Set Variable  xpath=(${item plan})[${n}]
	${href}  Get Element Attribute  ${selector}  href
	${href}  Поправити лінку для IP  ${href}
	Go To Smart  ${href}


Отримати назву плану за номером
	[Arguments]  ${n}
	Select Frame  css=iframe
	${selector}  Set Variable  xpath=(${item plan})[${n}]
	${text}  Get Text  ${selector}
	Unselect Frame
	[Return]  ${text}