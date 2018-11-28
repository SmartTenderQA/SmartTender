*** Variables ***
${num_of_tenders}                    xpath=(//*[@class="num"])[3]


*** Keywords ***
Відкрити аналітику по конкурентах за назвою
  [Arguments]  ${text}
  ${opponent btn}  Set Variable  //*[@class='ivu-col ivu-col-span-sm-8']//button[@type='button']
  Click Element  ${opponent btn}
  Input Text  //*[@class='ivu-input-wrapper ivu-input-type']//input  ${text}
  ${first item}  Set Variable  //tbody[@class='ivu-table-tbody']//tr[1]//a
  Wait Until Element Is Visible  ${first item}
  Open button  ${first item}
  Дочекатись закінчення загрузки сторінки


Вибрати інший період аукціону
  [Arguments]  ${period}
  Click Element  xpath=//*[contains(@class, 'calendar')]
  Click Element  xpath=//div[contains(text(), '${period}')]
  Дочекатись закінчення загрузки сторінки


Перевірити наявність діаграми та таблиці
  ${diag}  Set Variable  xpath=(//*[@class="echarts"]//canvas)[1]
  ${table}  Set Variable  xpath=//*[@class="ivu-table-header"]//tr
  Element Should Be Visible  ${diag}
  Element Should Be Visible  ${table}


Перевірити роботу кругової діаграми
  ${tenders_before}  Get Text  ${num_of_tenders}
  ${tenders_before}  Evaluate  int(${tenders_before})
  Element Should Be Visible  xpath=(//*[@class="echarts"]//canvas)[2]
  Click Element At Coordinates  xpath=(//*[@class="echarts"]//canvas)[2]  80  0
  Дочекатись закінчення загрузки сторінки
  Wait Until Keyword Succeeds  1m  5s  Element Should Be Visible  xpath=//*[contains(@class, 'tag-checked')]
  ${tenders_after}  Get Text  ${num_of_tenders}
  ${tenders_after}  Evaluate  int(${tenders_after})
  Run Keyword if  ${tenders_before} < ${tenders_after}  Fail  Не працює кругова діаграма


Перевірити зміну періоду
  ${tenders_before}  Get Text  ${num_of_tenders}
  ${tenders_before}  Evaluate  int(${tenders_before})
  Вибрати інший період аукціону  Поточний рік
  ${tenders_after}  Get Text  ${num_of_tenders}
  ${tenders_after}  Evaluate  int('${tenders_after}'.replace(',',''))
  Run Keyword if  ${tenders_before} > ${tenders_after}  Fail  Не працює фільтрація по періоду
