*** Variables ***
${procedure type}              //h5[@class='label-key' and contains(text(), 'Тип процедури')]/following-sibling::p

*** Keywords ***
Отримати тип процедури
	${text}  Get Text  ${procedure type}
	[Return]  ${text}


Переглянути файл за іменем
    [Arguments]  ${file}
    tender_detail_page.Переглянути файл за іменем  ${file}


Скачати файл на сторінці
    [Arguments]  ${file}
    tender_detail_page.Скачати файл на сторінці  ${file}
