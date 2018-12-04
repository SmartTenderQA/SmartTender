*** Settings ***
Resource    	keywords.robot


*** Variables ***
${button kontakty}					css=.menu a[href='/pro-kompaniyu/kontakty/']
${komertsiyni-torgy icon}			//*[@id="main"]//a[2]/img


*** Keywords ***
Зайти на сторінку contacts
	Click Element  ${button kontakty}
	Location Should Contain  /pro-kompaniyu/kontakty/
	${header text}  Set Variable  css=div[itemscope=itemscope] h1
	${should header}  Set Variable  Контакти SmartTender
	${is header}  Get Text  ${header text}
	Should Be Equal  ${is header}  ${should header}


Натиснути На торговельний майданчик
	Click Element  ${komertsiyni-torgy icon}
	Location Should Contain  /komertsiyni-torgy/


Відкрити особистий кабінет
    Run Keyword  Відкрити особистий кабінет для ${role}

