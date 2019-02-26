*** Variables ***
${item}	          					//*[@class='ivu-row']//div[@class="ivu-card-body"]
${advanced search}                 	//span[contains(text(),'Розгорнути')]


*** Keywords ***
Розгорнути детальний пошук
	Click Element  ${advanced search}


Вибрати тип активу
	[Arguments]  ${type}
	${type locator}  Set Variable  //li[contains(text(),'${type}')]
	elements.Дочекатися відображення елемента на сторінці  xpath=//span[contains(text(),'Оберіть тип активу')]  5
	Wait Until Keyword Succeeds  5  .5  Click Element  xpath=//span[contains(text(),'Оберіть тип активу')]
	elements.Дочекатися відображення елемента на сторінці  ${type locator}
	Click Element  ${type locator}
	Дочекатись закінчення загрузки сторінки(skeleton)
	${status}  Run Keyword And Return Status
	...  Wait Until Page Contains Element  //li[contains(text(),'${type}') and contains(@class,'selected')]
	Run Keyword If  '${status}' == '${False}'  Вибрати тип активу  ${type}


Перейти по результату пошуку за номером
	[Arguments]  ${n}
	${selector}  Set Variable  (${item}//a)[${n}]
	${href}  Get Element Attribute  ${selector}  href
	${href}  Поправити лінку для IP  ${href}
	Go To  ${href}
	Дочекатись закінчення загрузки сторінки(skeleton)


Порахувати активи
	${n}  Get Element Count  ${item}
	[Return]  ${n}