*** Settings ***


*** Variables ***


*** Keywords ***
Заповнити та перевірити поле з датою
	[Arguments]  ${selector}  ${text}
	Scroll Page To Element XPATH  ${selector}
	Click Element  ${selector}
	Sleep  .5
	Run Keyword And Ignore Error  Clear input By JS  ${selector}
	Input Text  ${selector}  ${text}
	${got}  Get Element Attribute  ${selector}  value
	Press Key  ${selector}  \\13
	Should Not Be Empty  ${selector}


Заповнити та перевірити текстове поле
	[Arguments]  ${selector}  ${text}
	Scroll Page To Element XPATH  ${selector}
	Click Element  ${selector}
	Sleep  .5
	Run Keyword And Ignore Error  Clear input By JS  ${selector}
	Input Text  ${selector}  ${text}
	${got}  Get Element Attribute  ${selector}  value
	Press Key  ${selector}  \\13
	Should Be Equal As Strings  ${got}  ${text}


Заповнити та перевірити поле з вартістю
	[Arguments]  ${selector}  ${text}
	Scroll Page To Element XPATH  ${selector}
	Click Element  ${selector}
	Sleep  .5
	Run Keyword And Ignore Error  Clear input By JS  ${selector}
	Input Text  ${selector}  ${text}
	${got}  Get Element Attribute  ${selector}  value
	${got}  Evaluate  '${got}'.replace(' ','')
	Press Key  ${selector}  \\13
	Should Be Equal  ${got}  ${text}


Вибрати та повернути елемент з випадаючого списку за назвою
	[Arguments]  ${selector}  ${value}
	Scroll Page To Element XPATH  ${selector}
  	${item}  Set Variable  ${selector}//div[contains(@class,'ivu-select-dropdown')]//li[contains(text(),'${value}')]
    Click Element  ${selector}
    Sleep  .5
    Run Keyword And Ignore Error  Input Text  ${selector}//input[@type='text']  ${value}
	Wait Until Element Is Visible  ${item}
    Click Element  ${item}
    ${element}  Get Text  ${selector}//*[@class='ivu-select-selected-value']
    Sleep  .5
    [Return]  ${element}


Вибрати та повернути випадковий елемент з випадаючого списку
    [Arguments]  ${selector}
  	${items}  Set Variable  ${selector}//ul[@class='ivu-select-dropdown-list']/li
  	${input}  Set Variable  ${selector}//input[@type='text']
	Scroll Page To Element XPATH  ${input}
    Click Element  ${input}
    Sleep  .5
    Wait Until Element Is Visible  ${items}
    ${items count}  Get Element Count  ${items}
	${items number}  random_number  1  ${items count}
    Click Element  (${items})[${items number}]
    ${text}  Get Element Attribute  ${input}  value
   	Should Not Be Empty  ${text}
	Sleep  .5
    [Return]  ${text}


Отримати локатор по назві поля
	[Arguments]  ${field}
	${selector}  Set Variable  ${edit_locators${field}}
	[Return]  ${selector}