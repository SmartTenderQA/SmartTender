*** Variables ***
${button pro-kompaniyu}             css=.with-drop>a[href='/pro-kompaniyu/']
${button trading-platform}          css=.with-drop>a[href='/komertsiyni-torgy/']


*** Keywords ***
Отримати словник для випадаючих списків
	${pro-kompaniyu}  		Set Variable  Про компанію
	${trading-platform}  	Set Variable  Торговий майданчик
	${dict}  Create Dictionary
	...  ${pro-kompaniyu}=${button pro-kompaniyu}
	...  ${trading-platform}=${button trading-platform}
	[Return]  ${dict}