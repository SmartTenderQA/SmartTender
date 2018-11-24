*** Settings ***
Resource  				keywords.robot


*** Keywords ***
Розпочати роботу з Gmail
	[Arguments]  ${user}
	Open Browser  https://www.google.com/gmail/about/#  chrome  email
	Авторизуватися в Gmail  ${user}
	Закрити валідаційне вікно (за необходністю)


Відкрити лист в email за темою
	[Arguments]  ${title}
	Wait Until Keyword Succeeds  5 min  3 s  Перевірити наявність листа за темою  ${title}
	Click Element  xpath=//td[@id]//span[contains(text(), '${title}')]
	Wait Until Page Contains Element  xpath=//*[@class='Bu bAn']


Перейти за посиланням в листі
	[Arguments]  ${title}
	Розгорнути останній лист (за необхідність)
	Click Element  xpath=//a[contains(text(),'Відновити пароль→')]
	Select Window  New
	sleep  0.5


Розгорнути останній лист (за необхідність)
	${count}  Get Element Count  //img[@class='ajT']
	sleep  0.5
	Run Keyword If  ${count} > 0  Click Element  xpath=(//img[@class='ajT'])[last()]
	sleep  1


Перевірити вкладений файл за назвою
	[Arguments]  ${should}  ${title}
	Click Element  //a[contains(., '${title}')]
	${text}  Evaluate  str(${should})
	Wait Until Page Contains  ${text}  10