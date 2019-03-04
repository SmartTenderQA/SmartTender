*** Variables ***
${komercial type}                       xpath=//*[@data-qa='tender-header-detail-biddingForm']/div[2]|//*[@id='tenderPage']//h1


*** Keywords ***
Отримати форму торгів
	${text}  Get Text  ${komercial type}
	[Return]  ${text}


Переглянути файл за іменем
    [Arguments]  ${file}
    tender_detail_page.Переглянути файл за іменем  ${file}


Скачати файл на сторінці
    [Arguments]  ${file}
    tender_detail_page.Скачати файл на сторінці  ${file}
