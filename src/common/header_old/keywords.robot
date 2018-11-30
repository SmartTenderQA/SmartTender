*** Variables ***
${button pro-kompaniyu}             css=.with-drop>a[href='/pro-kompaniyu/']
${button trading-platform}          css=.with-drop>a[href='/komertsiyni-torgy/']


*** Keywords ***
Отримати словник для випадаючих списків
	${pro-kompaniyu}  		Encode String To Bytes  Про компанію  		UTF-8
	${trading-platform}  	Encode String To Bytes  Торговий майданчик  UTF-8
	${dict}  Create Dictionary
	...  ${pro-kompaniyu}=${button pro-kompaniyu}
	...  ${trading-platform}=${button trading-platform}
	[Return]  ${dict}