*** Variables ***
${komercial type}                       xpath=//*[@data-qa='tender-header-detail-biddingForm']/div[2]|//*[@id='tenderPage']//h1


*** Keywords ***
Отримати форму торгів
	${text}  Get Text  ${komercial type}
	[Return]  ${text}