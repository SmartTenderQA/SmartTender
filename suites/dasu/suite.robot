*** Settings ***
Resource  ../../src/src.robot
Library  dasu_service.py
Library  monitoring_owner.py
Suite Setup  Підготувати користувачів
Suite Teardown  Suite Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot



*** Variables ***
${UAID}                         UA-2018-07-04-000042-a
${tender_ID}                    65185416966049988973a95cd118b7a6
${id_for_skip_creating}         4fdf3382da004478bbf0e16c72219538


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
  Switch Browser  tender_owner
  Відкрити сторінку для створення публічних закупівель
  Пошук тендеру у webclient  ${UAID}


Відкрити сторінку моніторингу
  [Tags]  open_monitoring_page
  Перейти за посиланням по dasu
  Відкрити вкладку моніторингу
  ${monitoring_id}  Отримати дані моніторингу по API  monitoring_id
  Знайти потрібний моніторинг за номером  ${monitoring_id}
  :FOR  ${username}  IN  viewer  provider
  \  Switch Browser  ${username}
  \  Go To  ${data['location']}
  \  Відкрити вкладку моніторингу


Перевірити відображення інформації нового моніторингу
  [Tags]  open_monitoring_page
  Отримати дані моніторингу по API
  :FOR  ${username}  IN  tender_owner  provider  viewer
  \  Switch Browser  ${username}
  \  Звірити статус моніторингу
  \  Звірити дату створення
  \  Звірити адитора


################################################################
#                          CANCELLED                           #
################################################################
Скасувати моніторинг
  [Tags]  cancellation
  Скасувати моніторинг по тендеру


Перевірити відображення інформації скасованого моніторингу
  [Tags]  cancellation
  Отримати дані моніторингу по API
  :FOR  ${username}  IN  tender_owner  provider  viewer
  \  Switch Browser  ${username}
  \  Reload Page
  \  Відкрити вкладку моніторингу
  \  Звірити статус моніторингу
  \  Звірити опис сказування


################################################################
#                         ACTIVE                               #
################################################################
Активувати моніторинг
  [Tags]  activation
  Сформувати рішення по моніторингу
  Перевести моніторинг в статус  active


Перевірити відображення інформації моніторингу після активації
  [Tags]  activation
  Отримати дані моніторингу по API
  :FOR  ${username}  IN  tender_owner  provider  viewer
  \  Switch Browser  ${username}
  \  Reload Page
  \  Відкрити вкладку моніторингу
  \  Звірити статус моніторингу
  \  Звірити опис рішення
  \  Звірити дату рішення


################################################################
#                        ADDRESSED                             #
################################################################
Оприлюднити висновок з інформаціэю про порушення
  [Tags]  addressed
  Опублікувати висновок з інформацією про порушення
  Перевести моніторинг в статус  addressed


Перевірити відображення інформації про висновок
  [Tags]  addressed
  Отримати дані моніторингу по API
  :FOR  ${username}  IN  tender_owner  provider  viewer
  \  Switch Browser  ${username}
  \  Reload Page
  \  Відкрити вкладку моніторингу
  \  Звірити результат висновку
  \  Звірити дату висновку
  \  Звірити інформацію про результати висновку
  \  Звірити опис висновку
  \  Звірити обов'язки висновку


################################################################
#                      CLARIFICATION                           #
################################################################
Неможливість створити запит за роз'ясненнями щодо висновку для ролей: viewer, provider
  [Tags]  request_for_clarification
  :FOR  ${username}  IN  provider  viewer
  \  Switch Browser  ${username}
  \  Run Keyword And Expect Error  *  Відкрити бланк запиту за роз'ясненнями


Створити запит за роз'ясненнями щодо висновку
  [Tags]  request_for_clarification
  Switch Browser  tender_owner
  Відкрити бланк запиту за роз'ясненнями
  ${title}  Заповнити поле Предмет
  ${description}  Заповнити поле Опис
  ${path}  ${name}  ${content}  Створити та додати файл  ${monitoring_selector}//*[@data-qa='dialogue-files']//input
  Відправити пояснення
  Перевірити відправлені дані запиту за роз'ясненнями щодо висновку  ${title}  ${description}  ${name}


Перевірити відображення запиту за роз'ясненням
  [Tags]  request_for_clarification
  :FOR  ${username}  IN  tender_owner  provider  viewer
  \  Switch Browser  ${username}
  \  Reload Page
  \  Відкрити вкладку моніторингу
  \  Звірити title запиту
  \  Звірити description запиту
  \  Звірити datePublished запиту
  \  Звірити documents.title запиту
  \  Звірити documents.datePublished запиту


#Накласти ЕЦП на запит за роз'ясненням
#  [Tags]  request_for_clarification
#  ${selector}  Set Variable  ${monitoring_selector}//*[contains(text(), "Запит роз'яснень організатором")]/../following-sibling::*//*[contains(text(), 'Підписати ЕЦП')]
#  Перевірити можливість підписання ЕЦП для позову  ${selector}
#  Відкрити вкладку моніторингу
#  Перевірити успішність підписання ЕЦП  ${selector}


################################################################
#              VIOLATION ELIMINATION REPORT                    #
################################################################
Неможливість опублікувати інформацію про усунення порушення для ролей: viewer, provider
  [Tags]  violation_elimination_report
  :FOR  ${username}  IN  provider  viewer
  \  Switch Browser  ${username}
  \  Run Keyword And Expect Error  *  Відкрити бланк звіту про усунення порушення


Опублікувати інформацію про усунення порушення
  [Tags]  violation_elimination_report
  Switch Browser  tender_owner
  Відкрити бланк звіту про усунення порушення
  ${description}  Заповнити поле Опис звіту про усунення порушення
  ${path}  ${name}  ${content}  Створити та додати файл  ${monitoring_selector}//*[@data-qa='eliminationReport-files']//input
  Відправити звіт про усунення порушення
  Перевірити відправлені дані звіту про усунення порушення  ${description}  ${name}


Перевірити відображення інформації про усунення порушення
  [Tags]  violation_elimination_report
  :FOR  ${username}  IN  tender_owner  provider  viewer
  \  Switch Browser  ${username}
  \  Reload Page
  \  Відкрити вкладку моніторингу
  \  Перевірити дату інформації про усунення порушення
  \  Перевірити description інформації про усунення порушення
  \  Перевірити documents.title інформації про усунення порушення
  \  Перевірити documents.datePublished інформації про усунення порушення


#Накласти ЕЦП на звіт про усунення порушень
#  [Tags]  violation_elimination_report
#  ${selector}  Set Variable  ${monitoring_selector}//*[contains(text(), 'Звіт про усунення порушень')]/following-sibling::*//*[contains(text(), 'Підписати ЕЦП')]
#  Перевірити можливість підписання ЕЦП для позову  ${selector}
#  Відкрити вкладку моніторингу
#  Перевірити успішність підписання ЕЦП  ${selector}


################################################################
#                          APPEAL                              #
################################################################
Неможливість опублікувати позов для ролей: viewer, provider
  [Tags]  appeal
  :FOR  ${username}  IN  provider  viewer
  \  Switch Browser  ${username}
  \  Run Keyword And Expect Error  *  Вікрити бланк позову


Опублікувати позов
  [Tags]  appeal
  Switch Browser  tender_owner
  Вікрити бланк позову
  ${description}  Заповнити поле Опис позову
  ${path}  ${name}  ${content}  Створити та додати файл  ${monitoring_selector}//*[@data-qa='appeal-files']//input
  Відправити позов
  Перевірити відправлені дані позову  ${description}  ${name}


Перевірити відображення інформації про позов
  [Tags]  appeal
  :FOR  ${username}  IN  tender_owner  provider  viewer
  \  Switch Browser  ${username}
  \  Reload Page
  \  Відкрити вкладку моніторингу
  \  Перевірити дату позову
  \  Перевірити description позову
  \  Перевірити documents.title позову
  \  Перевірити documents.datePublished позову


#Накласти ЕЦП на позов
#  [Tags]  appeal
#  ${selector}  Set Variable  ${monitoring_selector}//*[contains(text(), 'Висновок оскаржено в суді')]/following-sibling::*//*[contains(text(), 'Підписати ЕЦП')]
#  Перевірити можливість підписання ЕЦП для позову  ${selector}
#  Відкрити вкладку моніторингу
#  Перевірити успішність підписання ЕЦП  ${selector}


################################################################
#                        COMPLETE                              #
################################################################
Підтвердити факт усунення порушення
  [Tags]  completed
  Сформувати рішення щодо усунення порушення
  Перевести моніторинг в статус  completed


Перевести моніторинг в статус вирішено
  [Tags]  completed
  Отримати дані моніторингу по API
  :FOR  ${username}  IN  tender_owner  provider  viewer
  \  Switch Browser  ${username}
  \  Reload Page
  \  Відкрити вкладку моніторингу
  \  Звірити статус моніторингу
  \  Перевірити опис факту усунення порушення


################################################################
#                      MAKE A DIALOG                           #
################################################################
Неможливість опублікувати позов для ролей: viewer, provider
  [Tags]  make_a_dialogue_individually
  :FOR  ${username}  IN  provider  viewer
  \  Switch Browser  ${username}
  \  Run Keyword And Expect Error  *  Відкрити бланк пояснення з власної ініціативи


Подати пояснення з власної ініціативи
  [Tags]  make_a_dialogue_individually
  Switch Browser  tender_owner
  Відкрити бланк пояснення з власної ініціативи
  ${title}  Заповнити поле предмет пояснення з власної ініціативи
  ${description}  Заповнити поле опис пояснення з власної ініціативи
  ${path}  ${name}  ${content}  Створити та додати файл  ${monitoring_selector}//*[@data-qa='dialogue-files']//input
  Відправити пояснення з власної ініціативи
  Перевірити відправлені дані пояснення з власної ініціативи  ${title}  ${description}  ${name}


Перевірити відображення пояснення з власної ініціативи
  [Tags]  make_a_dialogue_individually
  :FOR  ${username}  IN  tender_owner  provider  viewer
  \  Switch Browser  ${username}
  \  Reload Page
  \  Відкрити вкладку моніторингу
  \  Перевірити date пояснення з власної ініціативи
  \  Перевірити title пояснення з власної ініціативи
  \  Перевірити description пояснення з власної ініціативи
  \  Перевірити documents.title пояснення з власної ініціативи
  \  Перевірити documents.datePublished пояснення з власної ініціативи


Підписати ЕЦП для пояснення з власної ініціативи
  [Tags]  make_a_dialogue_individually
  No Operation


Створити запит
  [Tags]  make_a_dialogue
  Сформувати та відправити запит організатору
  Дочекатись синхронізації  dasu


Перевірити відображення інформаціїї запиту
  [Tags]  make_a_dialogue
  Отримати дані про останній запит
  :FOR  ${username}  IN  tender_owner  provider  viewer
  \  Switch Browser  ${username}
  \  Reload Page
  \  Відкрити вкладку моніторингу
  \  Перевірити title запиту  ${data_cdb}
  \  Перевірити description запиту  ${data_cdb}
  \  Перевірити date запиту  ${data_cdb}


Неможливість відповісти на запит для ролей: viewer, provider
  [Tags]  make_a_dialogue
  :FOR  ${username}  IN  provider  viewer
  \  Switch Browser  ${username}
  \  Run Keyword And Expect Error  *  Відкрити бланк відповіді на запит


Відповісти на запит
  [Tags]  make_a_dialogue
  Switch Browser  tender_owner
  Відкрити бланк відповіді на запит
  ${title}  Заповнити title відповіді на запит
  ${description}  Заповнити description відповіді на запит
  ${path}  ${name}  ${content}  Створити та додати файл  ${monitoring_selector}//*[@data-qa='dialogueAnswer-files']//input
  Відправити відповідь на запит
  Перевірити відправлені дані відповіді на запит  ${title}  ${description}  ${name}


Перевірити відображення інформації про відповідь на запит
  [Tags]  make_a_dialogue
  :FOR  ${username}  IN  tender_owner  provider  viewer
  \  Switch Browser  ${username}
  \  Reload Page
  \  Відкрити вкладку моніторингу
  \  Перевірити date відповіді на запит
  \  Перевірити title відповіді на запит
  \  Перевірити description відповіді на запит
  \  Перевірити documents.title відповіді на запит
  \  Перевірити documents.datePublished відповіді на запит


Підписати ЕЦП для відповіді на запит
  [Tags]  make_a_dialogue
  No Operation


################################################################
#                     STOP MONITORING                          #
################################################################
Зупинити моніторинг у статусі active
  [Tags]  stopped_after_active
  Сформувати дані та зупинити моніторинг
  Дочекатись синхронізації  dasu


Перевірити відображення інформації про зупинку моніторунгу після active
  [Tags]  stopped_after_active
  :FOR  ${username}  IN  tender_owner  provider  viewer
  \  Switch Browser  ${username}
  \  Reload Page
  \  Відкрити вкладку моніторингу
  \  Отримати дані моніторингу по API
  \  Звірити статус моніторингу
  \  Перевірити опис зупинення моніторингу
  \  Перевірити дату зупинення моніторингу


################################################################
#                        DECLINED                              #
################################################################
Оприлюднити висновок з інформаціэю про порушення
  [Tags]  declined
  Опублікувати висновок про відсутність порушень
  Перевести моніторинг в статус  declined


Перевірити відображення інформації про висновок
  [Tags]  declined
  Отримати дані моніторингу по API
  :FOR  ${username}  IN  tender_owner  provider  viewer
  \  Switch Browser  ${username}
  \  Reload Page
  \  Відкрити вкладку моніторингу
  \  Звірити дату висновку


################################################################
#                         CLOSED                               #
################################################################
Завершити моніторинг
  [Tags]  closed
  Перевести моніторинг в статус  closed
  Отримати дані моніторингу по API
  :FOR  ${username}  IN  tender_owner  provider  viewer
  \  Switch Browser  ${username}
  \  Reload Page
  \  Відкрити вкладку моніторингу
  \  Звірити статус моніторингу


#################################################################################################
#                                                                                               #
#                                         Keywords                                              #
#                                                                                               #
#################################################################################################
*** Keywords ***
Підготувати користувачів
  ${data}  Create Dictionary  id  ${id_for_skip_creating}
  Set Global Variable  ${data}
  Open Browser  ${start_page}  ${browser}  alias=tender_owner
  Login  dasu
  Open Browser  ${start_page}  ${browser}  alias=viewer
  Open Browser  ${start_page}  ${browser}  alias=provider
  Login  user1


Перейти за посиланням по dasu
  Sleep  2
  ${link}  Set Variable  xpath=//tbody/tr[@class="evenRow rowselected"]/td[count(//div[contains(text(), 'Мониторинг')]/ancestor::td[@draggable]/preceding-sibling::*)+1]
  Click Element  ${link}
  Wait Until Page Contains  Натисніть для переходу
  Click element  xpath=//a[contains(text(), 'Натисніть для переходу') and @href]
  ${web}  Select Window  New
  ${location}  Get Location
  ${list}  Evaluate  '${location}'.split('&ticket')
  ${location}  Set Variable  ${list[0]}
  Set To Dictionary  ${data}  location  ${location}
  Log  ${location}  WARN


Відкрити вкладку моніторингу
  ${tab}             Set Variable  xpath=//*[contains(@class, 'ivu-tabs-tab')]//*[contains(text(), 'Моніторинг ДАСУ')]
  ${not_active_tab}  Set Variable  xpath=//*[contains(@class, 'ivu-tabs-tab') and not(contains(@class, 'active'))]//*[contains(text(), 'Моніторинг ДАСУ') ]
  ${active tab}      Set Variable  xpath=//*[contains(@class, 'ivu-tabs-tab') and (contains(@class, 'active'))]//*[contains(text(), 'Моніторинг ДАСУ') ]
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${active_tab}
  Run Keyword If  '${status}' == 'False'  Click Element  ${tab}
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${active_tab}
  Run Keyword If  '${status}' == 'False'  Відкрити вкладку моніторингу
  Execute Javascript    window.scrollTo(0, 1200)
  Дочекатись закінчення загрузки сторінки


Отримати дані моніторингу по API
  [Arguments]  ${field}=${None}  ${title}=${None}
  ${data_cdb}  get_monitoring_data  ${data['id']}  ${field}  ${title}
  Log  ${data_cdb}
  Set Global Variable  ${data_cdb}
  [Return]  ${data_cdb}


Розпочати моніторинг по тендеру
  [Arguments]  ${tender_ID}
  ${name}  create_sentence  1
  ${response}  create_monitoring  ${tender_ID}  ${name}
  Run keyword If  '${response['status']}' == 'error'  Fail  Look at the response
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
  Run keyword If  '${data_cancellation['status']}' == 'error'  Fail  Look at the response
  Дочекатись синхронізації  dasu


Сформувати рішення по моніторингу
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${description}  create_sentence  20
  ${data_decision}  decision
  ...  ${relatedParty}
  ...  ${description}
  ...  ${data['id']}
  Log  ${data_decision}
  Run keyword If  '${data_decision['status']}' == 'error'  Fail  Look at the response


Перевести моніторинг в статус
  [Arguments]  ${status}
  ${date_status}  change_monitoring_status
  ...  ${status}
  ...  ${data['id']}
  Log  ${date_status}
  Run keyword If  '${date_status['status']}' == 'error'  Fail  Look at the response
  Дочекатись синхронізації  dasu


Сформувати рішення щодо усунення порушення
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${description}  create_sentence  20
  ${eliminationResolution}  eliminationResolution
  ...  ${relatedParty}
  ...  ${description}
  ...  ${data['id']}
  Log  ${eliminationResolution}
  Run keyword If  '${eliminationResolution['status']}' == 'error'  Fail  Look at the response


Знайти потрібний моніторинг за номером
  [Arguments]  ${monitoring_id}
  Set Global Variable  ${monitoring_id}
  ${monitoring_selector}  Set Variable  xpath=//*[contains(text(), '${monitoring_id}')]/ancestor::div[@class='ivu-card-body']
  Set Global Variable  ${monitoring_selector}
  Дочекатись закінчення загрузки сторінки
  Page Should Contain Element  ${monitoring_selector}


Звірити номер моніторингу
  ${cdb}  Отримати дані моніторингу по API  monitoring_id
  ${site}  Get Text  xpath=//*[contains(text(), '${monitoring_id}')]
  Should Be Equal  ${site}  ${cdb}


Звірити статус моніторингу
  ${cdb}  Set Variable  ${data_cdb['status']}
  ${text}  Get Text  ${monitoring_selector}//*[@data-qa='monitoring-statusTitle']
  ${site}  convert_data_from_the_page  ${text}  status
  Should Be Equal  ${site}  ${cdb}


Звірити дату створення
  ${cdb_time}  Set Variable  ${data_cdb['dateCreated']}
  ${text}  Get Text  ${monitoring_selector}//*[@data-qa='monitoring-number']/..
  ${site_time}  convert_data_from_the_page  ${text}  dateCreated
  ${status}  compare_dates_smarttender  ${cdb_time}  ${site_time}
  Should Be Equal  ${status}  ${True}


Звірити адитора
  ${cdb}  Set Variable  ${data_cdb['parties'][0]['contactPoint']['name']}
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Аудитори')]/following-sibling::ul
  Should Be Equal  ${cdb}  ${site}


Звірити опис сказування
  ${cdb}  Set Variable  ${data_cdb['cancellation']['description']}
  ${site}  Get Text  ${monitoring_selector}//div[contains(text(), 'Відмінено')]/following-sibling::*
  Should Be Equal  ${cdb}  ${site}


Звірити опис рішення
  ${cdb}  Set Variable  ${data_cdb['decision']['description']}
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Рішення про початок моніторингу')]/following-sibling::*
  Should Be Equal  ${cdb}  ${site}


Звірити дату рішення
  ${cdb_time}  Set Variable  ${data_cdb['decision']['datePublished']}
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Рішення про початок моніторингу')]
  ${site_time}  convert_data_from_the_page  ${site}  decision.date
  ${status}  compare_dates_smarttender  ${cdb_time}  ${site_time}
  Should Be Equal  ${status}  ${True}


Опублікувати висновок з інформацією про порушення
  ${violationOccurred}  Set Variable  ${True}
  ${description}  create_sentence  20
  ${stringsAttached}  create_sentence  10
  ${auditFinding}  create_sentence  10
  ${data_conclusion}  conclusion_true
  ...  ${violationOccurred}
  ...  ${description}
  ...  ${stringsAttached}
  ...  ${auditFinding}
  ...  ${data['id']}
  Log  ${data_conclusion}
  Run keyword If  '${data_conclusion['status']}' == 'error'  Fail  Look at the response


Звірити результат висновку
  ${cdb}  Set Variable  ${data_cdb['conclusion']['violationOccurred']}
  ${text}  Get Text  ${monitoring_selector}//*[contains(text(), 'Висновок')]/following-sibling::*/*[@class='break-word']/div[1]/div
  ${site}  convert_data_from_the_page  ${text}  status
  Should Be Equal  ${site}  ${cdb}


Звірити дату висновку
  ${cdb_time}  Set Variable  ${data_cdb['conclusion']['dateCreated']}
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Висновок')]
  ${site_time}  convert_data_from_the_page  ${site}  decision.date
  ${status}  compare_dates_smarttender  ${cdb_time}  ${site_time}
  Should Be Equal  ${status}  ${True}


Звірити опис висновку
  ${cdb}  Set Variable  ${data_cdb['conclusion']['description']}
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Опис')]/following-sibling::*
  Should Be Equal  ${cdb}  ${site}


Звірити інформацію про результати висновку
  ${cdb}  Set Variable  ${data_cdb['conclusion']['auditFinding']}
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Інформація про результати моніторингу')]/following-sibling::*
  Should Be Equal  ${cdb}  ${site}


Звірити обов'язки висновку
  ${cdb}  Set Variable  ${data_cdb['conclusion']['stringsAttached']}
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), "Забов'язання щодо усунення порушень")]/following-sibling::*
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
  Отримати дані моніторингу по API  posts  ${title}
  Should Be Equal  ${title}  ${data_cdb['title']}
  Should Be Equal  ${description}  ${data_cdb['description']}
  Should Be Equal  ${name}  ${data_cdb['documents'][0]['title']}


Звірити title запиту
  Page Should Contain Element  xpath=//*[contains(text(), "${data_cdb['title']}")]


Звірити description запиту
  ${cdb}  Set Variable  ${data_cdb['description']}
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), '${data_cdb['title']}')]/following-sibling::*
  Should Be Equal  ${cdb}  ${site}


Звірити datePublished запиту
  ${cdb_time}  Set Variable  ${data_cdb['datePublished']}
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), "Запит роз'яснень організатором")]
  ${site_time}  convert_data_from_the_page  ${site}  decision.date
  ${status}  compare_dates_smarttender  ${cdb_time}  ${site_time}
  Should Be Equal  ${status}  ${True}


Звірити documents.title запиту
  ${cdb}  Set Variable  ${data_cdb['documents'][0]['title']}
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), '${data_cdb['title']}')]/../following-sibling::*//a
  Should Be Equal  ${cdb}  ${site}


Звірити documents.datePublished запиту
  ${cdb_time}  Set Variable  ${data_cdb['documents'][0]['datePublished']}
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), '${data_cdb['title']}')]/../following-sibling::*//a/../following-sibling::*
  ${site_time}  convert_data_from_the_page  ${site}  decision.date
  ${status}  compare_dates_smarttender  ${cdb_time}  ${site_time}
  Should Be Equal  ${status}  ${True}


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
  Отримати дані моніторингу по API
  Should Be Equal  ${data_cdb['eliminationReport']['description']}  ${description}
  Should Be Equal  ${data_cdb['eliminationReport']['documents'][0]['title']}  ${file_name}


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
  Отримати дані моніторингу по API
  Should Be Equal  ${data_cdb['appeal']['description']}  ${description}
  Should Be Equal  ${data_cdb['appeal']['documents'][0]['title']}  ${file_name}


Перевірити дату інформації про усунення порушення
  ${date_cdb}  Set Variable  ${data_cdb['eliminationReport']['dateCreated']}
  ${text_site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Звіт про усунення порушень')]
  ${date_site}  convert_data_from_the_page  ${text_site}  decision.date
  ${status}  compare_dates_smarttender  ${date_site}  ${date_cdb}
  Should Be Equal  ${status}  ${True}


Перевірити description інформації про усунення порушення
  ${description}  Set Variable  ${data_cdb['eliminationReport']['description']}
  ${description_site}  Get Text  ${monitoring_selector}//*[@data-qa='monitoring-eliminationReport-description']
  Should Be Equal  ${description}  ${description_site}


Перевірити documents.title інформації про усунення порушення
  ${title}  Set Variable  ${data_cdb['eliminationReport']['documents'][0]['title']}
  ${title_site}  Get Text  ${monitoring_selector}//*[@data-qa="monitoring-eliminationReport-description"]/following-sibling::*/div[2]//a
  Should Be Equal  ${title}  ${title_site}


Перевірити documents.datePublished інформації про усунення порушення
  ${file_date}  Set Variable  ${data_cdb['eliminationReport']['documents'][0]['datePublished']}
  ${file_date_site}  Get Text  ${monitoring_selector}//*[@data-qa="monitoring-eliminationReport-description"]/following-sibling::*/div[2]/div/div/div[2]
  ${status}  compare_dates_smarttender  ${file_date}  ${file_date_site}
  Should Be Equal  ${status}  ${True}


Перевірити дату позову
  ${date_cdb}  Set Variable  ${data_cdb['appeal']['datePublished']}
  ${text_site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Висновок оскаржено в суді')]
  ${date_site}  convert_data_from_the_page  ${text_site}  decision.date
  ${status}  compare_dates_smarttender  ${date_site}  ${date_cdb}
  Should Be Equal  ${status}  ${True}


Перевірити description позову
  ${description}  Set Variable  ${data_cdb['appeal']['description']}
  ${description_site}  Get Text  ${monitoring_selector}//*[@data-qa='monitoring-appeal-description']
  Should Be Equal  ${description}  ${description_site}


Перевірити documents.title позову
  ${title}  Set Variable  ${data_cdb['appeal']['documents'][0]['title']}
  ${title_site}  Get Text  ${monitoring_selector}//*[@data-qa="monitoring-appeal-description"]/following-sibling::*/div[2]//a
  Should Be Equal  ${title}  ${title_site}


Перевірити documents.datePublished позову
  ${file_date}  Set Variable  ${data_cdb['appeal']['documents'][0]['datePublished']}
  ${file_date_site}  Get Text  ${monitoring_selector}//*[@data-qa="monitoring-appeal-description"]/following-sibling::*/div[2]/div/div/div[2]
  ${status}  compare_dates_smarttender  ${file_date}  ${file_date_site}
  Should Be Equal  ${status}  ${True}


Перевірити опис факту усунення порушення
  ${description}  Set Variable  ${data_cdb['eliminationResolution']['description']}
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
  Отримати дані моніторингу по API  posts  ${title}
  Should Be Equal  ${title}  ${data_cdb['title']}
  Should Be Equal  ${description}  ${data_cdb['description']}
  Should Be Equal  ${name}  ${data_cdb['documents'][0]['title']}


Перевірити date пояснення з власної ініціативи
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
  Run keyword If  '${data_dialogue['status']}' == 'error'  Fail  Look at the response
  ${posts}  Create Dictionary  title  ${title}
  ${list}  Create List  ${posts}
  Set To Dictionary  ${data}  posts  ${list}


Отримати дані про останній запит
  [Documentation]  get info about last dialogue through title
  ...  title taken from ${data}
  ${dict}  Get From List  ${data['posts']}  -1
  ${title}  Set Variable  ${dict['title']}
  Отримати дані моніторингу по API  posts  ${title}


Перевірити title запиту
  [Arguments]  ${data_cdb}
  Page Should Contain Element  xpath=//*[contains(text(), "${data_cdb['title']}")]


Перевірити description запиту
  [Arguments]  ${data_cdb}
  ${description}  Get Text  xpath=//*[contains(text(), "${data_cdb['title']}")]/following-sibling::div
  Should Be Equal  ${description}  ${data_cdb['description']}


Перевірити date запиту
  [Arguments]  ${data_cdb}
  ${text}  Get Text  xpath=//*[contains(text(), "${data_cdb['title']}")]/ancestor::*[@class="ivu-row"]//*[@class="text-muted"]
  ${date_site}  convert_data_from_the_page  ${text}  decision.date
  ${status}  compare_dates_smarttender  ${date_site}  ${data_cdb['datePublished']}
  Should Be Equal  ${status}  ${True}


Заповнити title відповіді на запит
  ${selector}  Set Variable  ${monitoring_selector}//*[@data-qa='dialogueAnswer-title']//input
  ${title}  create_sentence  10
  Input Text  ${selector}  ${title}
  [Return]  ${title}


Заповнити description відповіді на запит
  ${selector}  Set Variable  ${monitoring_selector}//*[@data-qa='dialogueAnswer-description']//textarea
  ${description}  create_sentence  20
  Input Text  ${selector}  ${description}
  [Return]  ${description}


Відкрити бланк відповіді на запит
  Click Element  xpath=//*[contains(text(), "${data_cdb['title']}")]/ancestor::*[@class="ivu-row"]//*[contains(text(), "Відповісти на запит")]
  Wait Until Page Contains Element  xpath=//*[@data-qa='dialogueAnswer-title']  60


Відправити відповідь на запит
  ${selector}  Set Variable  ${monitoring_selector}//*[@data-qa='dialogueAnswer-submit-accept']
  Click Element  ${selector}
  Дочекатись закінчення загрузки сторінки
  Wait Until Page Does Not Contain Element  ${selector}


Перевірити відправлені дані відповіді на запит
  [Arguments]  ${title}  ${description}  ${name}
  ${data_cdb}  Отримати дані моніторингу по API  posts  ${title}
  Set Global Variable  ${data_cdb}
  Should Be Equal  ${title}  ${data_cdb['title']}
  Should Be Equal  ${description}  ${data_cdb['description']}
  Should Be Equal  ${name}  ${data_cdb['documents'][0]['title']}


Перевірити date відповіді на запит
  ${text}  Get Text  xpath=//*[contains(text(), "${data_cdb['title']}")]/ancestor::*[@class='ivu-card-body'][1]//*[contains(text(), 'Відповідь організатора')]
  ${date_site}  convert_data_from_the_page  ${text}  decision.date
  ${status}  compare_dates_smarttender  ${date_site}  ${data_cdb['datePublished']}
  Should Be Equal  ${status}  ${True}


Перевірити title відповіді на запит
  ${title}  Get Text  xpath=//*[contains(text(), "${data_cdb['title']}")]
  Should Be Equal  ${title}  ${data_cdb['title']}


Перевірити description відповіді на запит
  ${description}  Get Text  xpath=//*[contains(text(), "${data_cdb['title']}")]/ancestor::*[@class='ivu-row'][1]//*[@class='break-word']/div[2]
  Should Be Equal  ${description}  ${data_cdb['description']}


Перевірити documents.title відповіді на запит
  ${documents.title}  Get Text  xpath=//*[contains(text(), "${data_cdb['title']}")]/ancestor::*[@class='ivu-row'][1]//a
  Should Be Equal  ${documents.title}  ${data_cdb['documents'][0]['title']}


Перевірити documents.datePublished відповіді на запит
  ${documents.datePublished}  Get Text  xpath=//*[contains(text(), "${data_cdb['title']}")]/ancestor::*[@class='ivu-row'][1]//a/../following-sibling::div
  ${status}  compare_dates_smarttender  ${documents.datePublished}  ${data_cdb['documents'][0]['datePublished']}
  Should Be Equal  ${status}  ${True}


Сформувати дані та зупинити моніторинг
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${description}  create_sentence  15
  ${data_cdb}  stopped
  ...  ${description}
  ...  ${relatedParty}
  ...  ${data['id']}
  Log  ${data_cdb}
  Run keyword If  '${data_cdb['status']}' == 'error'  Fail  Look at the response


Перевірити опис зупинення моніторингу
  ${cdb_description}  Set Variable  ${data_cdb['data']['cancellation']['description']}
  ${description}  Get Text  ${monitoring_selector}//*[@data-qa="monitoring-cancellation-description"]/..
  Should Be Equal  ${cdb_description}  ${description}


Перевірити дату зупинення моніторингу
  ${cdb_time}  Set Variable  ${data_cdb['data']['cancellation']['datePublished']}
  ${text}  Get Text  ${monitoring_selector}//*[@data-qa="monitoring-cancellation-description"]/../preceding-sibling::div
  ${site_time}  convert_data_from_the_page  ${text}  decision.date
  ${status}  compare_dates_smarttender  ${cdb_time}  ${site_time}
  Should Be Equal  ${status}  ${True}


Опублікувати висновок про відсутність порушень
  ${violationOccurred}  Set Variable  ${False}
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${data_cdb}  conclusion_false
  ...  ${violationOccurred}
  ...  ${relatedParty}
  ...  ${data['id']}
  Log  ${data_cdb}
  Run keyword If  '${data_cdb['status']}' == 'error'  Fail  Look at the response
