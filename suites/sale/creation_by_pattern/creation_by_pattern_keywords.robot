*** Keywords ***
Порівняти дані словників за назвою поля
	[Arguments]  ${old}  ${new}  ${field}
	Should Be Equal  ${old${field}}  ${old${field}}  Oops! Значення поля ${field} різне.\n ${old${field}} != ${old${field}}