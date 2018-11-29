*** Variables ***
${asset type}			//*[contains(text(), 'Тип активу')]/../following-sibling::div


*** Keywords ***
Отримати тип активу
	${text}  Get Text  ${asset type}
	[Return]  ${text}