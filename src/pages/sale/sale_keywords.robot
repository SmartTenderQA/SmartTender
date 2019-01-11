*** Settings ***


*** Variables ***


*** Keywords ***
########## common ###############################
Отримати локатор по назві поля
	[Arguments]  ${field}
	${selector}  Set Variable  ${edit_locators${field}}
	[Return]  ${selector}


Розгорнути детальну інформацію по всіх полях (за необхідністю)
	${read more btn}  Set Variable  //*[contains(@class,'second')]//a[not(@href) and contains(text(),'Детальніше')]
	${is contain}  Run Keyword And Return Status  Page Should Contain Element  {read more btn}
	Run Keyword If  ${is contain} == ${True}  Run Keywords
	...  Click Element  {read more btn}
	...  AND  Sleep  .5
	...  AND  sale_keywords.Розгорнути детальну інформацію по всіх полях (за необхідністю)


########### work with fields ####################
Вибрати та повернути елемент з випадаючого списку
    [Arguments]  ${selector}  ${text}=''
  	${items}  Set Variable  ${selector}//ul[@class='ivu-select-dropdown-list']//li
	Scroll Page To Element XPATH  ${selector}
    Click Element  ${selector}
    Sleep  .5
    Run Keyword If  "${text}" != "''"  Run Keywords
    ...  Run Keyword And Ignore Error  Input Text  ${selector}//input[@type='text']  ${text}
    ...  AND  Sleep  1.5
    Wait Until Element Is Visible  ${items}
    ${items count}  Get Element Count  ${items}
	${items number}  random_number  1  ${items count}
	${item name}  Get Text  (${items})[${items number}]
    Click Element  (${items})[${items number}]
    Sleep  .5
   	Should Not Be Empty  ${item name}
    [Return]  ${item name}


Розгорнути всі списки
	[Arguments]  ${modal locator}
	${closed li}  Set Variable  (${modal locator}//*[@class='ivu-tabs-tabpane'])[1]//li[contains(@class,'jstree-closed')]
	: FOR  ${i}  IN RANGE  99999
	\  ${closed li num}  Get Element Count  xpath=${closed li}
	\  Exit For Loop If    ${closed li num} == 0
    \  ${a}  Set Variable  ${closed li}/a
    \  Run Keyword And Ignore Error  Click Element  xpath=${a}
    \  Sleep  .5


Вибрати та повернути випадковий елемент з класифікації
    [Arguments]  ${selector}
	${modal locator}  Set Variable  //div${selector}
	${modal close locator}  Set Variable  ${modal locator}//*[@class='ivu-modal-close']
	${is opened}  Run Keyword And Return Status  Element Should Be Visible  ${modal close locator}
	Run Keyword If  ${is opened}  Run Keywords
	...  Click Element  ${modal close locator}  AND
	...  Sleep  .5
    Click Element  //a${selector}
	Wait Until Element Is Visible  ${modal locator}
	Sleep  1.5
	sale_keywords.Розгорнути всі списки  ${modal locator}
	${items}  Set Variable  ${modal locator}//li[contains(@class,'jstree-leaf')]/a
	${items count}  Get Element Count  xpath=${items}
	${random item}  random_number  1  ${items count}
	${item}  Set Variable  xpath=(${items})[${random item}]
	Click Element  ${item}
	${value}  Get Text  ${item}
	Sleep  .5
	Click Element  ${modal locator}//button
	Sleep  1
	[Return]  ${value}


Вибрати та повернути елемент з класифікації за назвою
    [Arguments]  ${selector}  ${text}
    Click Element  //a${selector}
    ${modal locator}  Set Variable  //div${selector}
	Wait Until Element Is Visible  ${modal locator}
	Sleep  .5
	${input}  Set Variable  ${modal locator}//input
	Input Text  ${input}  ${text}
	Sleep  1.5
	${item}  Set Variable  ${modal locator}//a[contains(text(),'${text}')]
	Click Element  ${item}
	${value}  Get Text  ${item}
	Sleep  .5
	Click Element  ${modal locator}//button
	Sleep  1
	[Return]  ${value}


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