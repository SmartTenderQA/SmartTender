*** Variables ***
${opponent btn}             //*[@class='ivu-col ivu-col-span-sm-8']//button[@type='button']
${company name input}       //*[@class='ivu-input-wrapper ivu-input-type']//input
${num_of_tenders}           (//*[@class="num"])[3]
${diagram}                  (//*[@class="echarts"]//canvas)


*** Keywords ***
Відкрити вікно аналітика по конкурентам
  Click Element  ${opponent btn}
  Wait Until Element Is Visible  ${company name input}


Ввести назву компанії
  [Arguments]  ${company name}
  Input Text  ${company name input}  ${company name}


Вибрати конкурента з списка за номером
  [Arguments]  ${i}
  ${item}  Set Variable  //tbody[@class='ivu-table-tbody']//tr[${i}]//a
  Wait Until Element Is Visible  ${item}
  Open button  ${item}


Змінити період аукціону
  [Arguments]  ${period}
  Click Element  //*[contains(@class, 'calendar')]
  Click Element  //div[contains(text(), '${period}')]
  Дочекатись закінчення загрузки сторінки


Перевірити наявність діаграм
  Element Should Be Visible  ${diagram}[1]
  Element Should Be Visible  ${diagram}[2]
  Element Should Be Visible  ${diagram}[3]
  Element Should Be Visible  ${diagram}[4]
  Element Should Be Visible  ${diagram}[5]
  Element Should Be Visible  ${diagram}[6]


Перевірити наявність таблиці
  ${table}  Set Variable  //*[@class="ivu-table-header"]//tr
  Element Should Be Visible  ${table}


Отримати кількість торгів
  ${count}  Get Text  ${num_of_tenders}
  ${count}  Evaluate  int('${count}'.replace(',',''))
  [Return]  ${count}


Натиснути по діаграмі
  Click Element At Coordinates  ${diagram}[2]  80  0