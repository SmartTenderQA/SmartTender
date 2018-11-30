*** Variables ***
${map item}		css=[class="row content"] li>a

*** Keywords ***
Порахувати кількість елементів на сторінці
	${n}  Get Element Count  ${map item}
	[Return]  ${n}
