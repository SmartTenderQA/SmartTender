*** Variables ***
${privatization item}			//*[@class="asset-card ivu-card ivu-card-bordered"]
#${privatization item}			//*[@class="data-card ivu-row"]


*** Keywords ***
Активувати перемемик процедури на
	[Documentation]  ${field_text} == Об'єкти приватизації|Реєстр інформаційних повідомлень
	[Arguments]  ${field_text}
	${selector}  Set Variable  //input[@type="radio"]/ancestor::label[contains(., "${field_text}")]
	${class}  Get Element Attribute  ${selector}  class
	${status}  Run Keyword And Return Status  Should Contain  ${class}  checked
	Run Keyword If  ${status} == ${False}  Run Keywords
	...  Click Element  ${selector}
	...  AND  Дочекатись закінчення загрузки сторінки(skeleton)


Активувати вкладку
	[Documentation]  ${tab name} == Аукціони|Реєстр об'єктів приватизації
	[Arguments]  ${tab name}
	${selector}  Set Variable  //*[contains(@class,'tab-pane') and contains(., "${tab name}")]
	${class}  Get Element Attribute  ${selector}  class
	${tab status}  Run Keyword And Return Status  Should Contain  ${class}  active
	Run Keyword If  ${tab status} == ${False}  Wait Until Keyword Succeeds  10  1  Click Element  ${selector}
	Дочекатись закінчення загрузки сторінки(skeleton)


Вибрати режим сторінки об'єктів приватизації
    [Arguments]  ${type}
    [Documentation]  Вибираємо режим сторінки. "Кабінет"  або "ПУблічний режим"
    Дочекатись закінчення загрузки сторінки(skeleton)
    ${selector}  Set Variable  //*[@data-qa="page-mode"]//span[text()="${type}"]
    Click Element   ${selector}
    Дочекатись закінчення загрузки сторінки(skeleton)
    Element Should Be Visible
    ...  ${selector}/preceding-sibling::span[contains(@class,"radio-checked")]


Активувати перемемик тестового режиму на
	[Documentation]  ${switcher mode} == вкл|викл
	[Arguments]  ${switcher mode}
	${switcher locator}  Set Variable  //*[@data-qa='test-mode-switch']
	${switcher status}  Run Keyword And Return Status  Element Should Contain  //*[@data-qa='test-mode-span']  ${switcher mode}
	Run Keyword If  ${switcher status} == ${False}  Click Element  ${switcher locator}
	Дочекатись закінчення загрузки сторінки(skeleton)


Перейти по результату пошуку за номером
	[Arguments]  ${n}
	${selector}  Set Variable  (${privatization item}//a)[${n}]
	Wait Until Element Is Visible  ${selector}  10
	${href}  Get Element Attribute  ${selector}  href
	${href}  Поправити лінку для IP  ${href}
	Go To  ${href}
	Дочекатись закінчення загрузки сторінки(skeleton)


Натиснути кнопку пошуку
	Click Element  ${elastic search button}
	Дочекатись закінчення загрузки сторінки(skeleton)
	Wait Until Page Contains Element  //*[@class="tag-holder"]


Натиснути створити
	[Documentation]  ${create button} == об'єкт|інформаційне повідомлення
	[Arguments]  ${create button}
	${create button locator}  Set Variable  //*[contains(@class,'action-block-item')]//button[contains(.,"${create button}")]
	Click Element  ${create button locator}
	Дочекатись закінчення загрузки сторінки(skeleton)