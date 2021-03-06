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
	${selector}  Set Variable  xpath=(//*[@class='panel-body']//h4//a)[${n}]
	Дочекатись закінчення загрузки сторінки
	Wait Until Page Contains Element  ${selector}
	${href}  Get Element Attribute  ${selector}  href
	${href}  Поправити лінку для IP  ${href}
	Go To Smart  ${href}


Очистити фільтр пошуку
	${status}  Run Keyword And Return Status  Page Should Contain Element  ${elastic search clean filter}
	Run Keyword If  ${status} == ${True}  Wait Until Keyword Succeeds  30  1
	...  Run Keywords
	...  Wait Until Keyword Succeeds  10  1  Click Element  ${elastic search clean filter}  AND
	...  Дочекатись закінчення загрузки сторінки  AND
	...  Wait Until Element Is Not Visible  ${elastic search clean filter}


Розгорнути фільтр
	[Documentation]  example: Вид торгів, Статус, Область....
	[Arguments]  ${element}
	${selector}  Set Variable  //p[contains(text(), "${element}")]
	Wait Until Page Contains Element  ${selector}
	${class}  Get Element Attribute  ${selector}//i  class
	${expand_status}  Run Keyword And Return Status  Should Contain  ${class}  down
	Run Keyword If  ${expand_status} == ${False}  Click Element  ${selector}


Вибрати вид торгів
	[Arguments]  ${bid form}
	new_search.Очистити фільтр пошуку
	${bid form locator}  Set Variable  //*[@class='ivu-checkbox-group' and contains(.,'Конкурентні')]//label[contains(text(),'${bid form}')]
	Click Element  ${bid form locator}
	Дочекатись закінчення загрузки сторінки


Сортувати за
	[Arguments]  ${sort by text}
	${sort by locator}  Set Variable  //*[@class="text-right ivu-col ivu-col-span-sm-12"]
	elements.Дочекатися відображення елемента на сторінці  ${sort by locator}
	${sort by is}  Get Text  ${sort by locator}
	Run Keyword If  '${sort by is.split('\n')[-1]}' != '${sort by text}'  Run Keywords
	...  Click Element  ${sort by locator}                                                                  AND
	...  elements.Дочекатися відображення елемента на сторінці  //li[contains(text(), "${sort by text}")]   AND
	...  Click Element  //li[contains(text(), "${sort by text}")]                                           AND
	...  Дочекатись закінчення загрузки сторінки                                                            AND
	...  dgf_search.Сортувати за  ${sort by text}