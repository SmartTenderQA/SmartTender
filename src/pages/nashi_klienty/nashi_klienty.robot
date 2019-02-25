*** Variables ***
${nashi-klienty text}               //*[@data-qa="head-vip-client"]/h2
${nashi-klienty text1}              //*[@data-qa="head-last-connected-client"]/h2
${client banner}                    //*[@data-qa="card-client"]


*** Keywords ***
Перевірити заголовок
	Element Text Should Be  ${nashi-klienty text}  Індивідуальні рішення
	Element Text Should Be  ${nashi-klienty text1}  Останнім часом до нас приєдналися


Порахувати кількість клієнтів
  ${count}  Get Element Count  ${client banner}
  [Return]  ${count}


Натиснути "Показати ще"
	Click Element  css=.container .row>button
	Sleep  1