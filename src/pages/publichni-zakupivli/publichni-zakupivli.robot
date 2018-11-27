*** Variables ***
${first element find tender}        //*[@id="tenders"]//tr[1]/td[2]/a
&{tabs}
...		Конкурентні процедури=${torgy top/bottom tab}(2) ${torgy count tab}(1)
...		Неконкурентні процедури=${torgy top/bottom tab}(2) ${torgy count tab}(2)
...		Плани=${torgy top/bottom tab}(2) ${torgy count tab}(3)
...		Договори=${torgy top/bottom tab}(2) ${torgy count tab}(4)


*** Keywords ***
Перевірити назву вкладки Державних закупівель
	${should}  Set variable  Публічні (державні) закупівлі PROZORRO
	${is}  Get Text  ${torgy top/bottom tab}(1) ${torgy count tab}(2)
	Should Be Equal  ${is}  ${should}


Перевірити заголовок вкладки
	[Arguments]  ${text}
	${is}  Get Text  ${tabs['${text}'])
	Should Be Equal  ${is}  ${text}


Порахувати кількість торгів
  ${count}  Get Element Count  ${first element find tender}
  Run Keyword if  '${count}' == '0'  Fail  Як це нема торгів?!

