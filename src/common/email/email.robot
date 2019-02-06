*** Settings ***
Resource  				keywords.robot


*** Keywords ***
Розпочати роботу з Gmail
	[Arguments]  ${user}
	Open Browser  https://www.google.com/gmail/about/#  chrome  email  ${hub}  platformName:ANY
	Авторизуватися в Gmail  ${user}
	Закрити валідаційне вікно (за необходністю)


Відкрити лист в email за темою
	[Arguments]  ${title}
	Wait Until Keyword Succeeds  10 min  15 s  Перевірити наявність листа за темою  ${title}
	Wait Until Keyword Succeeds  10  2  Click Element  xpath=//td[@id]//span[contains(text(), '${title}')]
	Wait Until Page Contains Element  xpath=//*[@class='Bu bAn']


Перейти за посиланням в листі
	[Arguments]  ${title}
	${link selector}  Set Variable  //a[contains(text(),'${title}')]
	Розгорнути останній лист (за необхідність)
	elements.Дочекатися відображення елемента на сторінці  (${link selector})[last()]
	Click Element  xpath=(${link selector})[last()]
	Select Window  New
	sleep  0.5


Розгорнути останній лист (за необхідність)
	${count}  Get Element Count  //img[@class='ajT']
	sleep  0.5
	Wait Until Keyword Succeeds  10 s  1 s  Run Keyword If  ${count} > 0  Click Element  xpath=(//img[@class='ajT'])[last()]
	sleep  1


Перевірити вкладений файл за назвою
	[Arguments]  ${amount}  ${title}
	Відкрити файл в листі за назвою  ${title}
	Wait Until Page Contains  Ɋɚɡɨɦ ${amount},00


Відкрити файл в листі за назвою
    [Arguments]  ${title}
   	Wait Until Keyword Succeeds  10 s  1 s  Click Element  (//a[contains(., '${title}')])[last()]
   	Element Should Contain  //*[@class='aLF-aPX-aPU-awE']  ${title}
