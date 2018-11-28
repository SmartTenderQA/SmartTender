*** Variables ***
${item dogovory}		  	//*[@class="panel panel-default panel-highlight"]


*** Keywords ***
Перейти по результату пошуку за номером
	[Arguments]  ${n}
	${selector}  Set Variable  xpath=(${item dogovory}//h4/a)[${n}]
	${href}  Get Element Attribute  ${selector}  href
	${href}  Поправити лінку для IP  ${href}
	Go To  ${href}
	Дочекатись закінчення загрузки сторінки(skeleton)


Порахувати кількість торгів
	${count}  Get Element Count  ${item dogovory}
	[Return]  ${count}


Отримати uaid договору за номером
	[Arguments]  ${n}
	${selector}  Set Variable  xpath=(${item dogovory}//h4)[${n}]
	Wait Until Page Contains Element  ${selector}  10
	${id}  Get Text  ${selector}
	[Return]  ${id}


Очистити фільтр пошуку
	${status}  Run Keyword And Return Status  Page Should Contain Element  ${elastic search clean filter}
	Run Keyword If  ${status} == ${True}  Run Keywords
	...  Wait Until Keyword Succeeds  10  1  Click Element  ${elastic search clean filter}
	...  AND  Дочекатись закінчення загрузки сторінки(skeleton)
	...  AND  Wait Until Element Is Not Visible  ${elastic search clean filter}



Операція над чекбоксом
	[Documentation]  ${action} == select|unselect
	[Arguments]  ${field_text}  ${action}
	${selector}  Set Variable  //label[contains(., "${field_text}")]//input[@type="checkbox"]
	Run Keyword  ${action} Checkbox  ${selector}


Розгорнути фільтр
	[Documentation]  example: Вид торгів, Статус, Область....
	[Arguments]  ${element}
	${selector}  Set Variable  //p[contains(text(), "${element}")]
	Wait Until Page Contains Element  ${selector}
	${class}  Get Element Attribute  ${selector}//i  class
	${expand_status}  Run Keyword And Return Status  Should Contain  ${class}  down
	Run Keyword If  ${expand_status} == ${False}  Click Element  ${selector}