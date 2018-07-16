*** Settings ***
Resource  ../../src/src.robot
Library  dasu_service.py
Library  monitoring_owner.py
Suite Setup  Підготувати організатора
Suite Teardown  Suite Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot



*** Variables ***
${UAID}                         UA-2018-07-04-000042-a
${tender_ID}                    65185416966049988973a95cd118b7a6
${id_for_skip_creating}         bb9d8dde76dc4c07a8a7782069311868


*** Test Cases ***
Розпочати моніторинг
  [Tags]  create_monitoring
  Розпочати моніторинг по тендеру  ${tender_ID}


Знайти тендер по ідентифікатору
  [Tags]  compare_data_after_create_monitoring
  Відкрити сторінку для створення публічних закупівель
  Пошук тендеру у webclient  ${UAID}


Відкрити сторінку моніторингу
  [Tags]  compare_data_after_create_monitoring
  Перейти за посиланням по dasu
  Відкрити вкладку моніторингу
  ${monitoring_id}  Отримати дані моніторингу по API  monitoring_id
  Знайти потрібний моніторинг за номером  ${monitoring_id}


Перевірити статус моніторингу
  [Tags]  compare_data_after_create_monitoring
  Звірити статус моніторингу


Перевірити дату створення
  [Tags]  compare_data_after_create_monitoring
  Звірити дату створення


Перевірити адитора
  [Tags]  compare_data_after_create_monitoring
  Звірити адитора


Скасувати моніторинг
  [Tags]  cancellation
  Скасувати моніторинг по тендеру


Перевірити статус скасованого моніторингу
  [Tags]  compare_data_after_ancellation
  Звірити статус моніторингу


Перевірити опис скасованого моніторингу
  [Tags]  compare_data_after_ancellation
  Звірити опис сказування


Активувати моніторинг
  [Tags]  activation
  Сформувати рішення по моніторингу
  Перевести моніторинг в статус  active


Перевірити статус моніторингу після активації
  [Tags]  compare_data_after_activation
  Звірити статус моніторингу


Перевірити опис рішення початку моніторингу
  [Tags]  compare_data_after_activation
  Звірити опис рішення


Перевірити дату рішення початку моніторингу
  [Tags]  compare_data_after_activation
  Звірити дату рішення


Оприлюднення висновку з інформаціэю про порушення
  [Tags]  conclusion
  Опублікувати висновок з інформацією про порушення
  Перевести моніторинг в статус  addressed


Перевірити дату висновку
  [Tags]  compare_data_after_conclusion
  debug


Перевірити опис висновку


*** Keywords ***
Підготувати організатора
  ${data}  create dictionary  id  ${id_for_skip_creating}
  Set Global Variable  ${data}
  Open Browser  ${start_page}  ${browser}  alias=tender_owner
  Login  dasu


Перейти за посиланням по dasu
  Sleep  2
  ${link}  Set Variable  xpath=//tbody/tr[@class="evenRow rowselected"]/td[count(//div[contains(text(), 'Мониторинг')]/ancestor::td[@draggable]/preceding-sibling::*)+1]
  Click Element  ${link}
  Wait Until Page Contains  Натисніть для переходу
  Click element  xpath=//a[contains(text(), 'Натисніть для переходу') and @href]
  ${web}  Select Window  New
  ${location}  Get Location
  Log  ${location}  WARN


Відкрити вкладку моніторингу
  ${tab}  Set Variable  xpath=//*[contains(@class, 'ivu-tabs-tab') and contains(text(), 'Моніторинг ДАСУ')]
  ${not_active_tab}  Set Variable  xpath=//*[contains(@class, 'ivu-tabs-tab') and contains(text(), 'Моніторинг ДАСУ') and not(contains(@class, 'active'))]
  ${active tab}  Set Variable  xpath=//*[contains(@class, 'ivu-tabs-tab') and contains(text(), 'Моніторинг ДАСУ') and contains(@class, 'active')]
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${active_tab}
  Run Keyword If  '${status}' == 'False'  Click Element  ${tab}
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${active_tab}
  Run Keyword If  '${status}' == 'False'  Відкрити вкладку моніторингу


Отримати дані моніторингу по API
  [Arguments]  ${field}
  ${response}  get_monitoring_data  ${data['id']}  ${field}
  [Return]  ${response}


Розпочати моніторинг по тендеру
  [Arguments]  ${tender_ID}
  ${name}  create_sentence  1
  ${response}  create_monitoring  ${tender_ID}  ${name}
  Log  ${response}
  ${data}  create dictionary  id  ${response['data']['id']}
  Set Global Variable  ${data}
  Дочекатись синхронізації


Скасувати моніторинг по тендеру
  ${description}  create_sentence  20
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${data_cancellation}  cancellation_monitoring
  ...  ${description}
  ...  ${relatedParty}
  ...  ${data['id']}
  Log  ${data_cancellation}
  Дочекатись синхронізації


Сформувати рішення по моніторингу
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${description}  create_sentence  20
  ${data_decision}  decision
  ...  ${relatedParty}
  ...  ${description}
  ...  ${data['id']}
  Log  ${data_decision}

############################### stopped here
Перевести моніторинг в статус
  [Arguments]  ${status}
  ${date_status}  change_monitoring_status
  ...  ${status}
  ...  ${data['id']}
  Log  ${date_status}
  Дочекатись синхронізації


Знайти потрібний моніторинг за номером
  [Arguments]  ${monitoring_id}
  Set Global Variable  ${monitoring_id}
  ${monitoring_selector}  Set Variable  xpath=//*[contains(text(), '${monitoring_id}')]/ancestor::div[@class='ivu-card-body']
  Set Global Variable  ${monitoring_selector}
  Page Should Contain Element  ${monitoring_selector}
  Execute Javascript    window.scrollTo(0,1200)


Звірити номер моніторингу
  ${cdb}  Отримати дані моніторингу по API  monitoring_id
  ${site}  Get Text  xpath=//*[contains(text(), '${monitoring_id}')]
  Should Be Equal  ${site}  ${cdb}


Звірити статус моніторингу
  Reload Page
  Відкрити вкладку моніторингу
  ${cdb}  Отримати дані моніторингу по API  status
  ${text}  Get Text  ${monitoring_selector}//*[@data-qa='monitoring-statusTitle']
  ${site}  convert_data_from_the_page  ${text}  status
  Should Be Equal  ${site}  ${cdb}


Звірити дату створення
  ${cdb_time}  Отримати дані моніторингу по API    dateCreated
  ${text}  Get Text  ${monitoring_selector}//*[@data-qa='monitoring-number']/..
  ${site_time}  convert_data_from_the_page  ${text}  dateCreated
  ${status}  compare_dates_smarttender  ${cdb_time}  ${site_time}
  Should Be Equal  ${status}  ${True}


Звірити адитора
  ${cdb}  Отримати дані моніторингу по API  parties.0.contactPoint.name
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Аудитори')]/following-sibling::ul
  Should Be Equal  ${cdb}  ${site}


Звірити опис сказування
  ${cdb}  Отримати дані моніторингу по API  cancellation.description
  ${site}  Get Text  ${monitoring_selector}//div[contains(text(), 'Відмінено')]/following-sibling::*
  Should Be Equal  ${cdb}  ${site}


Звірити опис рішення
  ${cdb}  Отримати дані моніторингу по API  decision.description
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Рішення про початок моніторингу')]/following-sibling::*
  Should Be Equal  ${cdb}  ${site}


Звірити дату рішення
  ${cdb_time}  Отримати дані моніторингу по API  decision.date
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Рішення про початок моніторингу')]
  ${site_time}  convert_data_from_the_page  ${text}  decision.date
  ${status}  compare_dates_smarttender  ${cdb_time}  ${site_time}
  Should Be Equal  ${status}  ${True}


Опублікувати висновок з інформацією про порушення
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${violationOccurred}  Set Variable  ${True}
  ${description}  create_sentence  20
  ${stringsAttached}  create_sentence  10
  ${auditFinding}  create_sentence  10
  ${data_conclusion}  conclusion
  ...  ${relatedParty}
  ...  ${violationOccurred}
  ...  ${description}
  ...  ${stringsAttached}
  ...  ${auditFinding}
  ...  ${data['id']}
  Log  ${data_conclusion}


Дочекатись синхронізації
  syncronization  dasu
