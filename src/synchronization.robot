*** Settings ***
Library     synchronization.py
Library     service.py

*** Keywords ***
Дочекатись синхронізації
  [Arguments]  ${mode}
  ${date_now}  smart_get_time  s
  #Log to console  synchronization has started ${date_now}
  Wait Until Keyword Succeeds  20m  3  Дочекатись синхронізації продовження  ${mode}  ${date_now}

Дочекатись синхронізації продовження
  [Arguments]  ${mode}  ${date_now}
  ${n}  synchronization_map  ${mode}
  ${url}  Set Variable
  ...  http://test.smarttender.biz/ws/webservice.asmx/Execute?calcId=_QA.GET.LAST.SYNCHRONIZATION&args={"SEGMENT":${n}}

  ${location}  Get Location
  Run Keyword If  '/ws/webservice.asmx/' in '${location}'  Reload Page
  ...  ELSE  Go To  ${url}

  ${synch dict}  Get Text  css=.text
  ${dict}  synchronization  ${synch dict}
  ${DateStart}  Set Variable  ${dict[0]}
  ${DateEnd}  Set Variable  ${dict[1]}
  ${WorkStatus}  Set Variable  ${dict[2]}
  ${Success}  Set Variable  ${dict[3]}

  ${compared_time}  compare_dates_synch  ${DateStart}  ${date_now}
   ${status}  Run Keyword if  '${compared_time}' == '${True}' and '${DateEnd}' != '${EMPTY}' and '${WorkStatus}' != 'working' and '${WorkStatus}' != 'fail' and '${Success}' == 'true'
  ...  Set Variable  Pass
  ...  ELSE  Reload Page
  Should Be Equal  ${status}  Pass
  Go Back