*** Settings ***
Resource  				keywords.robot


*** Keywords ***
Розпочати роботу з Gmail
	[Arguments]  ${user}
	Go To  https://www.google.com/gmail/about/#
	Авторизуватися в Gmail  ${user}
	Закрити валідаційне вікно (за необходністю)


Відкрити лист в email за темою
	[Arguments]  ${title}
	Wait Until Keyword Succeeds  30  2  Click Element  xpath=//td[@id]//span[contains(text(), '${title}')]
	Дочекатись закінчення загрузки сторінки по елементу  //span[@class='v1']
	Page Should Contain Element  xpath=//*[@class='Bu bAn']


Дочекатися отримання листа на пошту
	[Arguments]  ${timeout}  ${subject}
	Wait Until Keyword Succeeds  ${timeout}  15 s  Перевірити наявність листа за темою  ${subject}


Перейти за посиланням в листі
	[Arguments]  ${title}
	${link selector}  Set Variable  //a[contains(text(),'${title}')]
	Розгорнути останній лист (за необхідність)
	Sleep  30   #ждем пока догрузится gmail
	elements.Дочекатися відображення елемента на сторінці  (${link selector})[last()]  30
	Open button  xpath=(${link selector})[last()]
	sleep  0.5


Розгорнути останній лист (за необхідність)
	${count}  Get Element Count  //img[@class='ajT']
	sleep  0.5
	Wait Until Keyword Succeeds  30 s  1 s  Run Keyword If  ${count} > 0  Run Keywords
	...  elements.Дочекатися відображення елемента на сторінці  xpath=(//img[@class='ajT'])[last()]		AND
	...  Click Element  xpath=(//img[@class='ajT'])[last()]
	sleep  1


Перевірити вкладений файл за назвою
	[Arguments]  ${amount}  ${title}
	Відкрити файл в листі за назвою  ${title}
	Wait Until Page Contains Element  //p[contains(text(),'Ɋɚɡɨɦ ${amount}')]|//p[contains(text(),'Разом ${amount}')]


Відкрити файл в листі за назвою
    [Arguments]  ${title}
   	Wait Until Keyword Succeeds  10 s  1 s  Click Element  (//a[contains(., '${title}')])[last()]
   	Element Should Contain  //*[@class='aLF-aPX-aPU-awE']  ${title}
