*** Keywords ***
Операція над чекбоксом square
	[Documentation]  ${action} == check|uncheck
	[Arguments]  ${field_text}  ${action}
	${selector}  Set Variable  //label[contains(., "${field_text}")]//input[@type="checkbox"]
	Run Keyword  ${action} Checkbox  ${selector}