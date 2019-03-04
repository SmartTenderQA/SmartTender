*** Variables ***
${privatization item}			//*[@class="asset-card ivu-card ivu-card-bordered"]
#${privatization item}			//*[@class="data-card ivu-row"]


*** Keywords ***
Активувати перемемик процедури на
	[Documentation]  ${field_text} == Об'єкти приватизації|Реєстр інформаційних повідомлень
	[Arguments]  ${field_text}
	${selector}  Set Variable  //input[@type="radio"]/ancestor::label[contains(., "${field_text}")]
	Wait Until Keyword Succeeds  60  1  Wait Until Element Is Visible  ${selector}
	${class}  Get Element Attribute  ${selector}  class
	${status}  Run Keyword And Return Status  Should Contain  ${class}  checked
	Run Keyword If  ${status} == ${False}  Run Keywords
	...  Wait Until Keyword Succeeds  60  1  Click Element  ${selector}
	...  AND  Дочекатись закінчення загрузки сторінки


Активувати вкладку
	[Documentation]  ${tab name} == Аукціони|Реєстр об'єктів приватизації
	[Arguments]  ${tab name}
	Дочекатись закінчення загрузки сторінки
	${selector}  Set Variable  //*[contains(@class,'tab-pane') and contains(., "${tab name}")]
	${class}  Get Element Attribute  ${selector}  class
	${tab status}  Run Keyword And Return Status  Should Contain  ${class}  active
	Run Keyword If  ${tab status} == ${False}  Wait Until Keyword Succeeds  60  1  Click Element  ${selector}
	Дочекатись закінчення загрузки сторінки


Вибрати режим сторінки об'єктів приватизації
    [Arguments]  ${type}
    [Documentation]  Вибираємо режим сторінки. "Кабінет"  або "ПУблічний режим"
    Дочекатись закінчення загрузки сторінки
    ${selector}  Set Variable  //*[@data-qa="page-mode"]//span[text()="${type}"]
    elements.Дочекатися відображення елемента на сторінці  ${selector}  20
    Click Element   ${selector}
    Дочекатись закінчення загрузки сторінки
    Element Should Be Visible
    ...  ${selector}/preceding-sibling::span[contains(@class,"radio-checked")]


Активувати перемемик тестового режиму на
	[Documentation]  ${switcher mode} == вкл|викл
	[Arguments]  ${switcher mode}
	Дочекатись закінчення загрузки сторінки
	${switcher locator}  Set Variable  //*[@data-qa='test-mode-switch']
	${switcher status}  Run Keyword And Return Status  Element Should Contain  //*[@data-qa='test-mode-span']  ${switcher mode}
	Run Keyword If  ${switcher status} == ${False}  Click Element  ${switcher locator}
	Дочекатись закінчення загрузки сторінки


Перейти по результату пошуку за номером
	[Arguments]  ${n}
	${selector}  Set Variable  (${privatization item})[${n}]//a
	Wait Until Element Is Visible  ${selector}  10
	${href}  Get Element Attribute  ${selector}  href
	${href}  Поправити лінку для IP  ${href}
	Go To Smart  ${href}


Натиснути кнопку пошуку
	Click Element  ${elastic search button}
	Дочекатись закінчення загрузки сторінки
	Wait Until Page Contains Element  //*[@class="tag-holder"]


Натиснути створити
	[Documentation]  ${create button} == об'єкт|інформаційне повідомлення
	[Arguments]  ${create button}
	${create button locator}  Set Variable  //*[contains(@class,'action-block-item')]//button[contains(.,"${create button}")]
	Click Element  ${create button locator}
	Дочекатись закінчення загрузки сторінки


Отримати кількість сторінок
	elements.Дочекатися відображення елемента на сторінці  //*[contains(@class,"ivu-page-item")][last()]
	${page count}  Get Text  //*[contains(@class,"ivu-page-item")][last()]
	[Return]  ${page count}


Отримати кількість лотів
	elements.Дочекатися відображення елемента на сторінці  ${privatization item}
	${lot count}  Get Element Count  ${privatization item}
	[Return]  ${lot count}


Перейти на сторінку за номером
	[Arguments]  ${page num}
	${active page num}  Get Text  //*[@class="ivu-page-item ivu-page-item-active"]
	${cur url}  Get Location
	${new url}  Evaluate  '${cur url}'.replace('&p=' + '${active page num}', '&p=' + '${page num}')
	Go To Smart  ${new url}


Встановити фільтр "Організатор"
	[Arguments]  ${owner_name}
	Click Element  //input[@placeholder="Введіть код ЄДРПОУ або назву організації"]
	Input Text  //input[@placeholder="Введіть код ЄДРПОУ або назву організації"]  ${owner_name}
	elements.Дочекатися відображення елемента на сторінці  //li[contains(text(), '${owner_name}')]
	Click Element  //li[contains(text(), '${owner_name}')]
	Дочекатись закінчення загрузки сторінки