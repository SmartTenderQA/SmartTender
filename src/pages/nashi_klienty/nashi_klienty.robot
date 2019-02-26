*** Variables ***
${nashi-klienty text}               xpath=(//*[@class="row text-center"]//b)[1]
${nashi-klienty text1}              xpath=(//*[@class="row text-center"]//b)[2]
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