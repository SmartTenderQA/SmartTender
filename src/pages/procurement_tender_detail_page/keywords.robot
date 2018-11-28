*** Keywords ***
Статус тендера повинен бути
    [Arguments]  ${status should}
    ${status is}  Отритами дані зі сторінки  ['status']
    Should Be Equal  '${status should}'  '${status is}'


Парсінг за необхідністью
    [Arguments]  ${field}  ${value}
    ${result}  convert_page_values  ${field}  ${value}
    [Return]  ${result}


Перевірити коректність даних на сторінці
    [Arguments]  ${field}
    ${value}  Отритами дані зі сторінки  ${field}
    Should Be Equal  ${value}  ${data${field}}


Отримати локатор по назві поля
	[Arguments]  ${field}
	${selector}  Set Variable  ${${field}}
	[Return]  ${selector}