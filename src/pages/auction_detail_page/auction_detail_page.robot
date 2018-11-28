*** Variables ***
${procedure type}              //h5[@class='label-key' and contains(text(), 'Тип процедури')]/following-sibling::p

*** Keywords ***
Отримати тип процедури
	${text}  Get Text  ${procedure type}
	[Return]  ${text}