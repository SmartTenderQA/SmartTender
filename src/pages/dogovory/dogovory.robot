*** Keywords ***
Перевірити заголовок договору
	[Arguments]  ${id}
	${get}  Get Text  //h1
	Should Contain  ${get}  Договір
	Should Contain  ${get}  ${id}

