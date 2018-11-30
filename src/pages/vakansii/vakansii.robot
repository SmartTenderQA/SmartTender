*** Variables ***
${vakansii text}                    css=.container>div.row>div


*** Keywords ***
Перевірити заголовок сторінки вакансій
	${should}  Set variable  Вакансії
	${is}  Get Text  ${vakansii text}
	Should Be Equal  ${is}  ${should}