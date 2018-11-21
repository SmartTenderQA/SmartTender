*** Keywords ***
Активувати перемикач на сторінці пошуку малої приватизації
	[Arguments]  ${field_text}
	${selector}  Set Variable  //input[@type="radio"]/ancestor::label[contains(., "${field_text}")]
	${class}  Get Element Attribute  ${selector}  class
	${status}  Run Keyword And Return Status  Should Contain  ${class}  checked
	Run Keyword If  ${status} == ${False}  Run Keywords
	...  Click Element  ${selector}
	...  AND  Дочекатись закінчення загрузки сторінки(skeleton)

