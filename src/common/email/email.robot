*** Settings ***
Resource  				/keywords.robot


*** Keywords ***
email precondition
	[Arguments]  ${user}
	Open Browser  https://www.google.com/gmail/about/#  chrome  email
	eMail login  ${user}
	Run Keyword And Ignore Error  Закрити валідаційне вікно в email  welcome_dialog_next
	Run Keyword And Ignore Error  Закрити валідаційне вікно в email  ok


Відкрити лист в email
	[Arguments]  ${text}
	Wait Until Keyword Succeeds  5 min  15 s  Перевірити наявність листа  ${text}
	Wait Until Page Contains Element  xpath=//*[@class='nH']  timeout=10s
	Click Element  xpath=//td[@id]//span[contains(text(), '${text}')]
	Wait Until Page Contains Element  xpath=//*[@class='Bu bAn']


Перейти за посиланням в листі
	[Arguments]  ${text}
	${count}  Get Element Count  //img[@class='ajT']
	sleep  0.5
	Run Keyword If  ${count} > 0  Click Element  xpath=(//img[@class='ajT'])[last()]
	Click Element  xpath=//a[.='${text}']