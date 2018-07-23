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
${id_for_skip_creating}         6d7108a548f24d87bd38e77ccaf0fa26


*** Test Cases ***
################################################################
#                           DRAFT                              #
################################################################
Розпочати моніторинг
  [Tags]  create_monitoring
  Розпочати моніторинг по тендеру  ${tender_ID}
  Дочекатись синхронізації  dasu


Знайти тендер по ідентифікатору
  [Tags]  find_tender
  Відкрити сторінку для створення публічних закупівель
  Пошук тендеру у webclient  ${UAID}


Відкрити сторінку моніторингу
  [Tags]  open_monitoring
  Перейти за посиланням по dasu
  Відкрити вкладку моніторингу
  ${monitoring_id}  Отримати дані моніторингу по API  monitoring_id
  Знайти потрібний моніторинг за номером  ${monitoring_id}


Перевірити відображення інформації нового моніторингу
  [Tags]  compare_data_after_create_monitoring
  Звірити статус моніторингу
  Звірити дату створення
  Звірити адитора


################################################################
#                          CANCELLED                           #
################################################################
Скасувати моніторинг
  [Tags]  cancellation
  Скасувати моніторинг по тендеру


Перевірити відображення інформації скасованого моніторингу
  [Tags]  compare_data_after_cancellation
  Звірити статус моніторингу
  Звірити опис сказування


################################################################
#                         ACTIVE                               #
################################################################
Активувати моніторинг
  [Tags]  activation
  Сформувати рішення по моніторингу
  Перевести моніторинг в статус  active


Перевірити відображення інформації моніторингу після активації
  [Tags]  compare_data_after_activation
  Звірити статус моніторингу
  Звірити опис рішення
  Звірити дату рішення

################################################################
#                       CONCLUSION                             #
################################################################
Оприлюднення висновку з інформаціэю про порушення
  [Tags]  conclusion
  Опублікувати висновок з інформацією про порушення
  Перевести моніторинг в статус  addressed


Перевірити відображення інформації про висновок
  [Tags]  compare_data_after_conclusion
  Звірити результат висновку
  Звірити дату висновку
  Звірити інформацію про результати висновку
  Звірити опис висновку
  Звірити обов'язки висновку


################################################################
#                      CLARIFICATION                           #
################################################################
Створити запит за роз'ясненнями щодо висновку
  [Tags]  request_for_clarification
  Відкрити бланк запиту за роз'ясненнями
  ${title}  Заповнити поле Предмет
  ${description}  Заповнити поле Опис
  ${path}  ${name}  ${content}  Створити та додати файл  ${monitoring_selector}//*[@data-qa='dialogue-files']//input
  ${title}  Create Dictionary  title  ${name}
  Set To Dictionary  ${data['posts']}  documents  ${title}
  Відправити пояснення
  Перевірити відправлені дані запиту за роз'ясненнями щодо висновку  ${title}  ${description}  ${name}


Перевірити відображення запиту за роз'ясненням
  [Tags]  compare_data_after_request_for_clarification
  Log To Console  Перевірити відображення запиту за роз'ясненням
  debug


Накласти ЕЦП на запит за роз'ясненням
  [Tags]  compare_data_after_request_for_clarification
  ${selector}  Set Variable  ${monitoring_selector}//*[contains(text(), "Запит роз'яснень організатором")]/../following-sibling::*//*[contains(text(), 'Підписати ЕЦП')]
  Перевірити можливість підписання ЕЦП для позову  ${selector}
  Відкрити вкладку моніторингу
  Перевірити успішність підписання ЕЦП  ${selector}


################################################################
#              VIOLATION ELIMINATION REPORT                    #
################################################################
Опублікувати інформацію про усунення порушення
  [Tags]  violation_elimination_report
  Відкрити бланк звіту про усунення порушення
  ${description}  Заповнити поле Опис звіту про усунення порушення
  ${path}  ${name}  ${content}  Створити та додати файл  ${monitoring_selector}//*[@data-qa='eliminationReport-files']//input
  ${title}  Create Dictionary  title  ${name}
  Set To Dictionary  ${data['eliminationReport']}  documents  ${title}
  Відправити звіт про усунення порушення
  Перевірити відправлені дані звіту про усунення порушення  ${description}  ${name}


Перевірити відображення інформації про усунення порушення
  [Tags]  violation_elimination_report
  Перевірити дату інформації про усунення порушення
  Перевірити description інформації про усунення порушення
  Перевірити documents.title інформації про усунення порушення
  Перевірити documents.datePublished інформації про усунення порушення


Накласти ЕЦП на звіт про усунення порушень
  [Tags]  violation_elimination_report
  ${selector}  Set Variable  ${monitoring_selector}//*[contains(text(), 'Звіт про усунення порушень')]/following-sibling::*//*[contains(text(), 'Підписати ЕЦП')]
  Перевірити можливість підписання ЕЦП для позову  ${selector}
  Відкрити вкладку моніторингу
  Перевірити успішність підписання ЕЦП  ${selector}


################################################################
#                          APPEAL                              #
################################################################
Опублікувати позов
  [Tags]  appeal
  Вікрити бланк позову
  ${description}  Заповнити поле Опис позову
  ${path}  ${name}  ${content}  Створити та додати файл  ${monitoring_selector}//*[@data-qa='appeal-files']//input
  ${title}  Create Dictionary  title  ${name}
  Set To Dictionary  ${data['appeal']}  documents  ${title}
  Відправити позов
  Перевірити відправлені дані позову  ${description}  ${name}


Перевірити відображення інформації про позов
  [Tags]  appeal
  Перевірити дату позову
  Перевірити description позову
  Перевірити documents.title позову
  Перевірити documents.datePublished позову


Накласти ЕЦП на позов
  [Tags]  appeal
  ${selector}  Set Variable  ${monitoring_selector}//*[contains(text(), 'Висновок оскаржено в суді')]/following-sibling::*//*[contains(text(), 'Підписати ЕЦП')]
  Перевірити можливість підписання ЕЦП для позову  ${selector}
  Відкрити вкладку моніторингу
  Перевірити успішність підписання ЕЦП  ${selector}


################################################################
#                        COMPLETE                              #
################################################################
Підтвердити факт усунення порушення
  [Tags]  completed
  Сформувати рішення щодо усунення порушення


Перевести моніторинг в статус вирішено
  [Tags]  completed
  Перевести моніторинг в статус  completed
  Звірити статус моніторингу
  Перевірити опис факту усунення порушення


################################################################
#                      MAKE A DIALOG                           #
################################################################
Подати пояснення з власної ініціативи
  [Tags]  make_a_dialogue_individually
  Відкрити бланк пояснення з власної ініціативи
  ${title}  Заповнити поле предмет пояснення з власної ініціативи
  ${description}  Заповнити поле опис пояснення з власної ініціативи
  ${path}  ${name}  ${content}  Створити та додати файл  ${monitoring_selector}//*[@data-qa='dialogue-files']//input
  Відправити пояснення з власної ініціативи
  Перевірити відправлені дані пояснення з власної ініціативи  ${title}  ${description}  ${name}


Перевірити відображення пояснення з власної ініціативи
  [Tags]  make_a_dialogue_individually
  Перевірити data пояснення з власної ініціативи
  Перевірити title пояснення з власної ініціативи
  Перевірити description пояснення з власної ініціативи
  Перевірити documents.title пояснення з власної ініціативи
  Перевірити documents.datePublished пояснення з власної ініціативи


Створити запит
  [Tags]  make_a_dialogue
  Сформувати та відправити запит організатору
  Дочекатись синхронізації  dasu


Перевірити відображення інформаціїї запиту
  [Tags]  make_a_dialogue
  debug
  #Перевірити title запиту
  #Перевірити description запиту
  #Перевірити date запиту




#################################################################################################
#                                                                                               #
#                                         Keywords                                              #
#                                                                                               #
#################################################################################################
*** Keywords ***
Підготувати організатора
  ${data}  Create Dictionary  id  ${id_for_skip_creating}
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
  ${tab}             Set Variable  xpath=//*[contains(@class, 'ivu-tabs-tab')]//*[contains(text(), 'Моніторинг ДАСУ')]
  ${not_active_tab}  Set Variable  xpath=//*[contains(@class, 'ivu-tabs-tab') and not(contains(@class, 'active'))]//*[contains(text(), 'Моніторинг ДАСУ') ]
  ${active tab}      Set Variable  xpath=//*[contains(@class, 'ivu-tabs-tab') and (contains(@class, 'active'))]//*[contains(text(), 'Моніторинг ДАСУ') ]
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${active_tab}
  Run Keyword If  '${status}' == 'False'  Click Element  ${tab}
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${active_tab}
  Run Keyword If  '${status}' == 'False'  Відкрити вкладку моніторингу


Отримати дані моніторингу по API
  [Arguments]  ${field}  ${title}=${None}
  ${response}  get_monitoring_data  ${data['id']}  ${field}  ${title}
  [Return]  ${response}


Розпочати моніторинг по тендеру
  [Arguments]  ${tender_ID}
  ${name}  create_sentence  1
  ${response}  create_monitoring  ${tender_ID}  ${name}
  Log  ${response}
  ${data}  Create Dictionary  id  ${response['data']['id']}
  Set Global Variable  ${data}


Скасувати моніторинг по тендеру
  ${description}  create_sentence  20
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${data_cancellation}  cancellation_monitoring
  ...  ${description}
  ...  ${relatedParty}
  ...  ${data['id']}
  Log  ${data_cancellation}
  Дочекатись синхронізації  dasu
  Відкрити вкладку моніторингу


Сформувати рішення по моніторингу
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${description}  create_sentence  20
  ${data_decision}  decision
  ...  ${relatedParty}
  ...  ${description}
  ...  ${data['id']}
  Log  ${data_decision}


Перевести моніторинг в статус
  [Arguments]  ${status}
  ${date_status}  change_monitoring_status
  ...  ${status}
  ...  ${data['id']}
  Log  ${date_status}
  Дочекатись синхронізації  dasu
  Відкрити вкладку моніторингу


Сформувати рішення щодо усунення порушення
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${description}  create_sentence  20
  ${data_eliminationResolution}  eliminationResolution
  ...  ${relatedParty}
  ...  ${description}
  ...  ${data['id']}
  Log  ${eliminationResolution}
  ${dic_description}  Create Dictionary  description  ${description}
  Set To Dictionary  ${data}  eliminationResolution  ${dic_description}


Знайти потрібний моніторинг за номером
  [Arguments]  ${monitoring_id}
  Set Global Variable  ${monitoring_id}
  ${monitoring_selector}  Set Variable  xpath=//*[contains(text(), '${monitoring_id}')]/ancestor::div[@class='ivu-card-body']
  Set Global Variable  ${monitoring_selector}
  Дочекатись закінчення загрузки сторінки
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
  ${cdb_time}  Отримати дані моніторингу по API  decision.datePublished
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Рішення про початок моніторингу')]
  ${site_time}  convert_data_from_the_page  ${site}  decision.date
  ${status}  compare_dates_smarttender  ${cdb_time}  ${site_time}
  Should Be Equal  ${status}  ${True}


Опублікувати висновок з інформацією про порушення
  ${violationOccurred}  Set Variable  ${True}
  ${description}  create_sentence  20
  ${stringsAttached}  create_sentence  10
  ${auditFinding}  create_sentence  10
  ${data_conclusion}  conclusion
  ...  ${violationOccurred}
  ...  ${description}
  ...  ${stringsAttached}
  ...  ${auditFinding}
  ...  ${data['id']}
  Log  ${data_conclusion}


Звірити результат висновку
  ${cdb}  Отримати дані моніторингу по API  conclusion.violationOccurred
  ${text}  Get Text  ${monitoring_selector}//*[contains(text(), 'Висновок')]/following-sibling::*/*[@class='break-word']/div[1]/div
  ${site}  convert_data_from_the_page  ${text}  status
  Should Be Equal  ${site}  ${cdb}


Звірити дату висновку
  ${cdb_time}  Отримати дані моніторингу по API  conclusion.dateCreated
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Висновок')]
  ${site_time}  convert_data_from_the_page  ${site}  decision.date
  ${status}  compare_dates_smarttender  ${cdb_time}  ${site_time}
  Should Be Equal  ${status}  ${True}


Звірити опис висновку
  ${cdb}  Отримати дані моніторингу по API  conclusion.description
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Опис')]/following-sibling::*
  Should Be Equal  ${cdb}  ${site}


Звірити інформацію про результати висновку
  ${cdb}  Отримати дані моніторингу по API  conclusion.stringsAttached
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Інформація про результати моніторингу')]/following-sibling::*
  Should Be Equal  ${cdb}  ${site}


Звірити обов'язки висновку
  ${cdb}  Отримати дані моніторингу по API  conclusion.auditFinding
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Зобов'язання щодо усунення порушень')]/following-sibling::*
  Should Be Equal  ${cdb}  ${site}


Відкрити бланк запиту за роз'ясненнями
  Click Element  ${monitoring_selector}//*[@data-qa='dialogueConclusion-submit']


Заповнити поле Предмет
  ${selector}  Set Variable  ${monitoring_selector}//*[@data-qa='dialogue-title']//input
  ${text}  create_sentence  5
  Input Text  ${selector}  ${text}
  ${posts}  Create Dictionary  title  ${text}
  Set To Dictionary  ${data}  posts  ${posts}
  [Return]  ${text}


Заповнити поле Опис
  ${selector}  Set Variable  ${monitoring_selector}//*[@data-qa='dialogue-description']//textarea
  ${text}  create_sentence  20
  Input Text  ${selector}  ${text}
  Set To Dictionary  ${data['posts']}  description  ${text}
  [Return]  ${text}


Відправити пояснення
  ${selector}  Set Variable  ${monitoring_selector}//*[@data-qa='dialogue-submit-accept']
  Click Element  ${selector}
  Дочекатись закінчення загрузки сторінки
  Wait Until Page Does Not Contain Element  ${selector}


Перевірити відправлені дані запиту за роз'ясненнями щодо висновку
  [Arguments]  ${title}  ${description}  ${name}
  ${cdb_title}  Отримати дані моніторингу по API  posts.0.title
  ${cdb_description}  Отримати дані моніторингу по API  posts.0.description
  ${cdb_name}  Отримати дані моніторингу по API  posts.0.documents.0.title
  Should Be Equal  ${title}  ${cdb_title}
  Should Be Equal  ${description}  ${cdb_description}
  Should Be Equal  ${name}  ${cdb_name}


Відкрити бланк звіту про усунення порушення
  Click Element  ${monitoring_selector}//*[@data-qa='eliminationReport-submit']


Заповнити поле Опис звіту про усунення порушення
  ${selector}  Set Variable  ${monitoring_selector}//*[@data-qa='eliminationReport-description']//textarea
  ${text}  create_sentence  30
  Input Text  ${selector}  ${text}
  ${description}  Create Dictionary  description  ${text}
  Set To Dictionary  ${data}  eliminationReport  ${description}
  [Return]  ${text}


Відправити звіт про усунення порушення
  ${selector}  Set Variable  ${monitoring_selector}//*[@data-qa='eliminationReport-submit-accept']
  Click Element  ${selector}
  Дочекатись закінчення загрузки сторінки
  Wait Until Page Does Not Contain Element  ${selector}


Перевірити відправлені дані звіту про усунення порушення
  [Arguments]  ${description}  ${file_name}
  ${cdb_eliminationReport}  Отримати дані моніторингу по API  eliminationReport.description
  Should Be Equal  ${cdb_eliminationReport['description']}              ${description}
  Should Be Equal  ${cdb_eliminationReport['documents'][0]['title']}    ${file_name}

Вікрити бланк позову
  Click Element  ${monitoring_selector}//*[@data-qa='appeal-submit']


Заповнити поле Опис позову
  ${selector}  Set Variable  ${monitoring_selector}//*[@data-qa='appeal-description']//textarea
  ${text}  create_sentence  30
  ${appeal}  Create Dictionary  description  ${text}
  ${data}  Set To Dictionary  ${data}  appeal  ${appeal}
  Input Text  ${selector}  ${text}
  [Return]  ${text}


Відправити позов
  ${selector}  Set Variable  ${monitoring_selector}//*[@data-qa='appeal-submit-accept']
  Click Element  ${selector}
  Дочекатись закінчення загрузки сторінки
  Wait Until Page Does Not Contain Element  ${selector}


Перевірити відправлені дані позову
  [Arguments]  ${description}  ${file_name}
  ${cdb_appeal}  Отримати дані моніторингу по API  appeal
  Should Be Equal  ${cdb_appeal['description']}  ${description}
  Should Be Equal  ${cdb_appeal['documents'][0]['title']}  ${file_name}


Перевірити дату інформації про усунення порушення
  ${date_cdb}  Отримати дані моніторингу по API  eliminationReport.dateCreated
  ${text_site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Звіт про усунення порушень')]
  ${date_site}  convert_data_from_the_page  ${text_site}  decision.date
  ${status}  compare_dates_smarttender  ${date_site}  ${date_cdb}
  Should Be Equal  ${status}  ${True}


Перевірити description інформації про усунення порушення
  ${description}  Set Variable  ${data['eliminationReport']['description']}
  ${description_site}  Get Text  ${monitoring_selector}//*[@data-qa='monitoring-eliminationReport-description']
  Should Be Equal  ${description}  ${description_site}


Перевірити documents.title інформації про усунення порушення
  ${title}  Set Variable  ${data['eliminationReport']['documents']['title']}
  ${title_site}  Get Text  ${monitoring_selector}//*[@data-qa="monitoring-eliminationReport-description"]/following-sibling::*/div[2]//a
  Should Be Equal  ${title}  ${title_site}


Перевірити documents.datePublished інформації про усунення порушення
  ${file_date}  Отримати дані моніторингу по API  eliminationReport.documents.0.datePublished
  ${file_date_site}  Get Text  ${monitoring_selector}//*[@data-qa="monitoring-eliminationReport-description"]/following-sibling::*/div[2]/div/div/div[2]
  ${status}  compare_dates_smarttender  ${file_date}  ${file_date_site}
  Should Be Equal  ${status}  ${True}


Перевірити дату позову
  ${date_cdb}  Отримати дані моніторингу по API  appeal.datePublished
  ${text_site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Висновок оскаржено в суді')]
  ${date_site}  convert_data_from_the_page  ${text_site}  decision.date
  ${status}  compare_dates_smarttender  ${date_site}  ${date_cdb}
  Should Be Equal  ${status}  ${True}


Перевірити description позову
  ${description}  Set Variable  ${data['appeal']['description']}
  ${description_site}  Get Text  ${monitoring_selector}//*[@data-qa='monitoring-appeal-description']
  Should Be Equal  ${description}  ${description_site}


Перевірити documents.title позову
  ${title}  Set Variable  ${data['appeal']['documents']['title']}
  ${title_site}  Get Text  ${monitoring_selector}//*[@data-qa="monitoring-appeal-description"]/following-sibling::*/div[2]//a
  Should Be Equal  ${title}  ${title_site}


Перевірити documents.datePublished позову
  ${file_date}  Отримати дані моніторингу по API  appeal.documents.0.datePublished
  ${file_date_site}  Get Text  ${monitoring_selector}//*[@data-qa="monitoring-appeal-description"]/following-sibling::*/div[2]/div/div/div[2]
  ${status}  compare_dates_smarttender  ${file_date}  ${file_date_site}
  Should Be Equal  ${status}  ${True}


Перевірити опис факту усунення порушення
  ${description}  Set Variable  ${data['eliminationResolution']['description']}
  ${description_site}  Get Text  ${monitoring_selector}//*[@data-qa='monitoring-eliminationResolution-description']
  Should Be Equal  ${description}  ${description_site}


Відкрити бланк пояснення з власної ініціативи
  Click Element  xpath=//*[@data-qa="dialogue-submit"]
  Wait Until Page Contains Element  ${monitoring_selector}//*[@data-qa='dialogue-title']


Заповнити поле предмет пояснення з власної ініціативи
  ${selector}  Set Variable  ${monitoring_selector}//*[@data-qa='dialogue-title']//input
  ${title}  create_sentence  10
  Input Text  ${selector}  ${title}
  [Return]  ${title}


Заповнити поле опис пояснення з власної ініціативи
  ${selector}  Set Variable  ${monitoring_selector}//*[@data-qa='dialogue-description']//textarea
  ${description}  create_sentence  30
  Input Text  ${selector}  ${description}
  [Return]  ${description}


Відправити пояснення з власної ініціативи
  ${selector}  Set Variable  ${monitoring_selector}//*[@data-qa='dialogue-submit-accept']
  Click Element  ${selector}
  Дочекатись закінчення загрузки сторінки
  Wait Until Page Does Not Contain Element  ${selector}


Перевірити відправлені дані пояснення з власної ініціативи
  [Arguments]  ${title}  ${description}  ${name}
  ${data_cdb}  Отримати дані моніторингу по API  posts  ${title}
  Set Global Variable  ${data_cdb}
  Should Be Equal  ${title}  ${cdb_post['title']}
  Should Be Equal  ${description}  ${cdb_post['description']}
  Should Be Equal  ${name}  ${cdb_post['documents'][0]['title']}


Перевірити data пояснення з власної ініціативи
  ${text}  Get Text  xpath=//*[contains(text(), "${data_cdb['title']}")]/ancestor::*[@class='ivu-card-body'][1]//*[contains(text(), 'Пояснення з ініціативи організатора')]
  ${date_site}  convert_data_from_the_page  ${text}  decision.date
  ${status}  compare_dates_smarttender  ${date_site}  ${data_cdb['datePublished']}
  Should Be Equal  ${status}  ${True}


Перевірити title пояснення з власної ініціативи
  ${title}  Get Text  xpath=//*[contains(text(), "${data_cdb['title']}")]
  Should Be Equal  ${title}  ${data_cdb['title']}


Перевірити description пояснення з власної ініціативи
  ${description}  Get Text  xpath=//*[contains(text(), "${data_cdb['title']}")]/ancestor::*[@class='ivu-row'][1]//*[@class='break-word']/div[2]
  Should Be Equal  ${description}  ${data_cdb['description']}


Перевірити documents.title пояснення з власної ініціативи
  ${documents.title}  Get Text  xpath=//*[contains(text(), "${data_cdb['title']}")]/ancestor::*[@class='ivu-row'][1]//a
  Should Be Equal  ${documents.title}  ${data_cdb['documents'][0]['title']}


Перевірити documents.datePublished пояснення з власної ініціативи
  ${documents.datePublished}  Get Text  xpath=//*[contains(text(), "${data_cdb['title']}")]/ancestor::*[@class='ivu-row'][1]//a/../following-sibling::div
  ${status}  compare_dates_smarttender  ${documents.datePublished}  ${data_cdb['documents'][0]['datePublished']}
  Should Be Equal  ${status}  ${True}


Сформувати та відправити запит організатору
  ${title}  create_sentence  5
  ${description}  create_sentence  20
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${data_dialogue}  make_a_dialogue
  ...  ${title}
  ...  ${description}
  ...  ${relatedParty}
  ...  ${data['id']}
  Log  ${data_dialogue}