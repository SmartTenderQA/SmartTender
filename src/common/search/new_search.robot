*** Variables ***
${item dogovory}		  			//*[@class="panel panel-default panel-highlight"]
${elastic search input}             css=.ivu-card-bordered input
${elastic search button}            css=.ivu-card-bordered button
${elastic search clean filter}      css=.tag-holder button


*** Keywords ***
Ввести фразу для пошуку
	[Arguments]  ${text}
	Input Text  ${elastic search input}  ${text}
	${get}  Get Element Attribute  ${elastic search input}  value
	Should Be Equal  ${text}  ${get}


Натиснути кнопку пошуку
	Click Element  ${elastic search button}
	Дочекатись закінчення загрузки сторінки
	Wait Until Page Contains Element  ${elastic search clean filter}


Перейти по результату пошуку за номером
	[Arguments]  ${n}
	${selector}  Set Variable  xpath=(${item dogovory}//h4/a)[${n}]
	Wait Until Page Contains Element  ${selector}
	${href}  Get Element Attribute  ${selector}  href
	${href}  Поправити лінку для IP  ${href}
	Go To Smart  ${href}


Порахувати кількість торгів
	elements.Дочекатися відображення елемента на сторінці  ${item dogovory}  10
	${count}  Get Element Count  ${item dogovory}
	[Return]  ${count}


Отримати uaid договору за номером
	[Arguments]  ${n}
	${selector}  Set Variable  xpath=(${item dogovory}//h4)[${n}]
	Wait Until Page Contains Element  ${selector}  10
	${id}  Get Text  ${selector}
	[Return]  ${id}


Очистити фільтр пошуку
	Дочекатись закінчення загрузки сторінки
	${status}  Run Keyword And Return Status  Wait Until Page Contains Element  ${elastic search clean filter}
	Run Keyword If  ${status} == ${True}  Run Keywords
	...  Wait Until Keyword Succeeds  10  1  Click Element  ${elastic search clean filter}
	...  AND  Дочекатись закінчення загрузки сторінки
	...  AND  Wait Until Element Is Not Visible  ${elastic search clean filter}


Операція над чекбоксом
	[Documentation]  ${action} == select|unselect
	[Arguments]  ${field_text}  ${action}
	${selector}  Set Variable  //label[contains(., "${field_text}")]//input[@type="checkbox"]
	Scroll Page To Element XPATH  ${selector}
	Run Keyword  ${action} Checkbox  ${selector}
	Дочекатись закінчення загрузки сторінки
	${status}  Run Keyword And Return Status  Checkbox Should Be Selected  ${selector}
	Run Keyword If  ${status} == ${False}  Операція над чекбоксом  ${field_text}  ${action}


Розгорнути фільтр
	[Documentation]  example: Вид торгів, Статус, Область....
	[Arguments]  ${element}
	${selector}  Set Variable  //p[contains(text(), "${element}")]
	Wait Until Page Contains Element  ${selector}
	${class}  Get Element Attribute  ${selector}//i  class
	${expand_status}  Run Keyword And Return Status  Should Contain  ${class}  down
	Run Keyword If  ${expand_status} == ${False}  Click Element  ${selector}

