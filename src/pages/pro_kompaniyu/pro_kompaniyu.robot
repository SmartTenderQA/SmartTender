*** Variables ***
${pro_kompaniyu header text}					css=div[itemscope=itemscope] h1
${pro-kompaniyu text}               			//div[@itemscope='itemscope']//div[1]/*[@class='ivu-card-body']/div[2]/div[1]


*** Keywords ***
Перевірити заголовок сторінки
	${should header}  Set Variable  Про майданчик SmartTender
	${is header}  Get Text  ${pro_kompaniyu header text}
	Should Be Equal  ${is header}  ${should header}


Звірити початок тексту на сторінці
	${should text}  Set variable  Раді вітати Вас на електронному торговельному майданчику SmartTender!
	${is text}  Get Text  ${pro-kompaniyu text}
	Should Contain  ${is text}  ${should text}