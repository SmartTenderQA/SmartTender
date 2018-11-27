*** Variables ***
${first element find tender}        //*[@id="tenders"]//tr[1]/td[2]/a


*** Keywords ***
Перевірити назву вкладки Державних закупівель
	${should}  Set variable  Публічні (державні) закупівлі PROZORRO
	${is}  Get Text  ${torgy top/bottom tab}(1) ${torgy count tab}(2)
	Should Be Equal  ${is}  ${should}


Перевірити заголовок вкладки Конкурентні процедури
	${should}  Set variable  Конкурентні процедури
	${is}  Get Text  ${torgy top/bottom tab}(2) ${torgy count tab}(1)
	Should Be Equal  ${is}  ${should}


Порахувати кількість торгів
  ${count}  Get Element Count  ${first element find tender}
  Run Keyword if  '${count}' == '0'  Fail  Як це нема торгів?!

