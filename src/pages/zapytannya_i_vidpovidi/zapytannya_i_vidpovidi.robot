*** Variables ***
${zaa item}			css=#faqGroupTree>div>div.hover-div

*** Keywords ***
Перевірити заголовок сторінки
	Element Should Contain  //h1  Питання та відповіді


Порахувати кількість запитань
	Select Frame  css=iframe
	${count}  Get Element Count  ${zaa item}
	Unselect Frame
	[Return]  ${count}