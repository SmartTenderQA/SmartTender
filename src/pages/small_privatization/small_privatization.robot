*** Settings ***


*** Variables ***


*** Keywords ***
Перейти на сторінку малої приватизації
	${current url}  Get Location
	Run Keyword If  '${current url}' != '${start page}'
	...  Run Keywords  Go To  ${start page}
	...  AND  Дочекатись Закінчення Загрузки Сторінки
    Click Element  (//div[@id='main']/div[@class='link-image']/*)[2]
	Дочекатись Закінчення Загрузки Сторінки
    Click Element  link=Аукціони на продаж активів держпідприємств
    Дочекатись закінчення загрузки сторінки


Перейти на сторінку реєстр об'єктів приватизації
    Click Element  //*[@data-qa='registry']
    Дочекатись закінчення загрузки сторінки(skeleton)


Увімкнути тестовий режим (за необхідністю)
	${switcher}  Set Variable  //*[@data-qa='test-mode-switch']
	${switcher status}  Get Element Attribute  ${switcher}//input  value
	Run Keyword If  '${switcher status}' == 'false'  Click Element  ${switcher}



Перейти до створення об'єкта малої приватизації
    Click Element  //span[contains(text(),'Кабінет')]
    Дочекатись Закінчення Загрузки Сторінки
	Click Element  //*[@data-qa='button-create-privatization-object']
    Дочекатись закінчення загрузки сторінки(skeleton)


Перейти до створення інформаційного повідомлення
    Click Element  //span[contains(text(),'Кабінет')]
    Дочекатись Закінчення Загрузки Сторінки
	Click Element  //*[@data-qa='button-create-lot']
    Дочекатись закінчення загрузки сторінки(skeleton)


Заповнити та перевірити текстове поле
	[Arguments]  ${selector}  ${text}
	Scroll Page To Element XPATH  ${selector}
	Click Element  ${selector}
	Sleep  .5
	Очистити поле  ${selector}
	Input Text  ${selector}  ${text}
	${got}  Get Element Attribute  ${selector}  value
	Press Key  ${selector}  \\13
	Should Be Equal  ${got}  ${text}


Заповнити та перевірити поле з вартістю
	[Arguments]  ${selector}  ${text}
	Scroll Page To Element XPATH  ${selector}
	Click Element  ${selector}
	Sleep  .5
	Очистити поле  ${selector}
	Input Text  ${selector}  ${text}
	${got}  Get Element Attribute  ${selector}  value
	${got}  Evaluate  '${got}'.replace(' ','')
	Press Key  ${selector}  \\13
	Should Be Equal  ${got}  ${text}


Очистити поле
    [Arguments]    ${selector}
    :FOR    ${i}    IN RANGE    999999
    \  ${text}  Get Element Attribute  ${selector}  value
    \  ${length}  Get Length  ${text}
    \  Exit For Loop If    ${length} == 0
    \  Double Click Element  ${selector}
    \  Press Key  ${selector}  \\8


Вибрати та повернути елемент з випадаючого списку
	[Arguments]  ${selector}  ${value}
	Scroll Page To Element XPATH  ${selector}
  	${item}  Set Variable  ${selector}/div[@class='ivu-select-dropdown']//*[contains(text(),'${value}')]
    Click Element  ${selector}
	Wait Until Element Is Visible  ${item}
    Click Element  ${item}
    ${element}  Get Text  ${selector}//*[@class='ivu-select-selected-value']
    Sleep  .5
    [Return]  ${element}


Ввести та повернути елемент з випадаючого списку
    [Arguments]  ${selector}  ${value}
   	Scroll Page To Element XPATH  ${selector}
  	${item}  Set Variable  ${selector}//ul[@class='ivu-select-dropdown-list']//*[contains(text(),'${value}')]
  	${input}  Set Variable  ${selector}//input[@type='text']
    Click Element  ${input}
    Sleep  .5
    Input Text  ${input}  ${value}
    Wait Until Element Is Visible  ${item}
    Click Element  ${item}
    ${text}  Get Element Attribute  ${input}  value
   	Should Not Be Empty  ${text}
	Sleep  .5
    [Return]  ${text}
