*** Settings ***
Library     synchronization.py


*** Keywords ***
Дочекатись синхронізації
  [Arguments]  ${mode}
  ${n}  synchronization_map  ${mode}
  ${date_now}  smart_get_time  s
  ${url}  Set Variable
  ...  http://test.smarttender.biz/ws/webservice.asmx/Execute?calcId=_QA.GET.LAST.SYNCHRONIZATION&args={"SEGMENT":${n}}

  Go To  ${url}
  ${synch dict}  Get Text  css=.text
  ${dict}  synchronization  ${synch dict}
  ${DateStart}  Set Variable  ${dict[0]}
  ${DateEnd}  Set Variable  ${dict[1]}
  ${WorkStatus}  Set Variable  ${dict[2]}
  ${Success}  Set Variable  ${dict[3]}

  ${compared_time}  compare_dates_smarttender  ${DateStart}  ${date_now}  >
   ${status}  Run Keyword if  '${compared_time}' == '${True}' and '${DateEnd}' != '${EMPTY}' and '${WorkStatus}' != 'working' and '${WorkStatus}' != 'fail' and '${Success}' == 'true'
  ...  Set Variable  Pass
  ...  ELSE  Reload Page
  Should Be Equal  ${status}  Pass
  Go Back