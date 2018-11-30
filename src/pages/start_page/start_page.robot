*** Settings ***
Resource    	keywords.robot


*** Variables ***
${button kontakty}					css=.menu a[href='/pro-kompaniyu/kontakty/']
${komertsiyni-torgy icon}			//*[@id="main"]//a[2]/img


*** Keywords ***
Зайти на сторінку contacts
	Click Element  ${button kontakty}
	Location Should Contain  /pro-kompaniyu/kontakty/


Натиснути На торговельний майданчик
	Click Element  ${komertsiyni-torgy icon}
	Location Should Contain  /komertsiyni-torgy/


Відкрити особистий кабінет
    Run Keyword  Відкрити особистий кабінет для ${role}

