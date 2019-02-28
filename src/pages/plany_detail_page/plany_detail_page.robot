*** Keywords ***
Порівняти назву плану
	[Arguments]  ${text}
	Location Should Contain  /publichni-zakupivli-prozorro-plany/
	Select Frame  css=iFrame
	Wait Until Page Contains Element  (//*[contains(@class,"title-plan bold")])[1]
	${title}  Get Text  (//*[contains(@class,"title-plan bold")])[1]
	Should Be Equal  ${title}  ${text}
	Unselect Frame