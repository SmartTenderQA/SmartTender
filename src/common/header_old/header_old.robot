*** Variables ***
${events}                           xpath=//*[@id="LoginDiv"]//a[2]
${logout}                           id=LogoutBtn


*** Keywords ***
Відкрити сторінку Заходи SmartTender
	Click Element  ${events}


Натиснути Вийти
	Click Element  ${logout}
	Wait Until Page Does Not Contain Element  ${logout}