*** Variables ***
${num_of_tenders}           (//*[@class="num"])[3]
${diagram}                  (//*[@class="echarts"]//canvas)


*** Keywords ***
Отримати кількість торгів
  ${count}  Get Text  ${num_of_tenders}
  ${count}  Evaluate  int('${count}'.replace(',','').replace(' ',''))
  [Return]  ${count}


Натиснути по діаграмі
  Click Element At Coordinates  ${diagram}[2]  80  0