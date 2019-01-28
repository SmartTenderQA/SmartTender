*** Settings ***
Resource  ../../src/src.robot
Library  DateTime
Library  dasu_service.py
Library  monitoring_owner.py
Suite Setup  Підготувати користувачів
Suite Teardown  Close All Browsers
Test Setup  Stop The Whole Test Execution If Previous Test Failed
Test Teardown  Test Postcondition



*** Variables ***
&{data}
${UAID}                         UA-2019-01-22-000137-c
${tender_ID}                    5db517ca10c34271a2636dd2db0fc959


*** Test Cases ***
################################################################
#                     CREATE NEW TENDER                        #
################################################################
Створити тендер та отримати UAID
  [Tags]  create_tender
  test_open_trade.Створити тендер
  Отримати UAID та tender_Id для створеного тендера
  Повернутися на головну сторінку особистого кабінету


################################################################
#                           DRAFT                              #
################################################################
Розпочати моніторинг
  [Tags]  create_monitoring
  Розпочати моніторинг по тендеру  ${tender_ID}


Скасувати моніторинг
  [Tags]  cancellation
  Скасувати моніторинг по тендеру


Активувати моніторинг
  [Tags]  activation
  Сформувати рішення по моніторингу
  Перевести моніторинг в статус  active


Знайти тендер по ідентифікатору
  [Tags]  find_tender
  Натиснути Повторить попытку (за необхідністю)
  Перейти у webclient за необхідністю
#  Змінити мову на укр.
  Відкрити сторінку для створення публічних закупівель
  Пошук об'єкта у webclient по полю  Номер тендер  ${UAID}


Відкрити сторінку моніторингу
  [Tags]  open_monitoring_page
  Перейти за посиланням по dasu
  Відкрити вкладку моніторингу
  ${monitoring_id}  Отримати дані моніторингу по API  monitoring_id
  Log  ${monitoring_id}  WARN
  Wait Until Keyword Succeeds  30  2  Знайти потрібний моніторинг за номером  ${monitoring_id}
  :FOR  ${username}  IN  ${viewer}  ${provider1}
  \  Завантажити сесію для  ${username}
  \  Go To  ${data['location']}
  \  Відкрити вкладку моніторингу
  \  Зберегти сесію  ${username}


Перевірити відображення інформації нового моніторингу
  [Tags]  open_monitoring_page123
  Отримати дані моніторингу по API
  :FOR  ${username}  IN  ${tender_owner}  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Звірити статус моніторингу
  \  Звірити дату створення
  \  Звірити адитора
  \  Зберегти сесію  ${username}


################################################################
#                          CANCELLED                           #
################################################################
Перевірити відображення інформації скасованого моніторингу
  [Tags]  cancellation
  Отримати дані моніторингу по API
  :FOR  ${username}  IN  ${tender_owner}  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Звірити статус моніторингу
  \  Звірити опис сказування
  \  Зберегти сесію  ${username}


################################################################
#                         ACTIVE                               #
################################################################
Перевірити відображення інформації моніторингу після активації
  [Tags]  activation
  Отримати дані моніторингу по API
  :FOR  ${username}  IN  ${tender_owner}  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Звірити статус моніторингу
  \  Звірити опис рішення
  \  Звірити дату рішення
  \  Зберегти сесію  ${username}


################################################################
#               MAKE A DIALOG INDIVIDUALLY                     #
################################################################
Неможливість подати пояснення з валсної ініціативи для ролей: viewer, provider
  [Tags]  make_a_dialogue_individually
  :FOR  ${username}  IN  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Run Keyword And Expect Error  *  Відкрити бланк пояснення з власної ініціативи
  \  Зберегти сесію  ${username}


Подати пояснення з власної ініціативи
  [Tags]  make_a_dialogue_individually
  ${loc}  Get Location
  Завантажити сесію для  ${tender_owner}
  Go to  ${loc}
  Відкрити вкладку моніторингу
  Відкрити бланк пояснення з власної ініціативи
  ${title}  Заповнити поле предмет пояснення з власної ініціативи
  ${description}  Заповнити поле опис пояснення з власної ініціативи
  ${path}  ${name}  ${content}  Створити та додати файл  ${monitoring_selector}//*[@data-qa='dialogue-files']//input
  Відправити пояснення з власної ініціативи
  Перевірити відправлені дані пояснення з власної ініціативи  ${title}  ${description}  ${name}
  Зберегти сесію  ${tender_owner}


Перевірити відображення пояснення з власної ініціативи
  [Tags]  make_a_dialogue_individually
  :FOR  ${username}  IN  ${provider1}  ${viewer}  ${tender_owner}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Перевірити date пояснення з власної ініціативи
  \  Перевірити title пояснення з власної ініціативи
  \  Перевірити description пояснення з власної ініціативи
  \  Перевірити documents.title пояснення з власної ініціативи
  \  Перевірити documents.datePublished пояснення з власної ініціативи
  \  Зберегти сесію  ${username}


Підписати ЕЦП для пояснення з власної ініціативи
  [Tags]  make_a_dialogue_individually
#  Натиснути Підписати ЕЦП
#  ${block}  Set Variable  //*[contains(text(), "${data_cdb['title']}")]/ancestor::*[@class='ivu-card-body'][1]
#  ${EDS button}  Set Variable  ${block}//span[contains(text(), 'ЕЦП')]
#  Click Element  ${EDS button}
  No Operation



Надати відповіть на пояснення з власної ініціативи органом ДАСУ
  [Tags]  make_a_dialogue_individually
  Сформувати та відправити відповідь органом ДАСУ
  Дочекатись синхронізації  dasu


Перевірити відображення відповіді на пояснення з власної ініціативи органом ДАСУ
  [Tags]  make_a_dialogue_individually
  :FOR  ${username}  IN  ${provider1}  ${viewer}  ${tender_owner}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Перевірити title відповіді на пояснення з власної ініціативи
  \  Перевірити datePublished відповіді на пояснення з власної ініціативи
  \  Перевірити description відповіді на пояснення з власної ініціативи


#Підписати ЕЦП для пояснення з власної ініціативи2
#  [Tags]  make_a_dialogue_individually
#  No Operation


################################################################
#                      MAKE A DIALOG                           #
################################################################
Створити запит
  [Tags]  make_a_dialogue
  Сформувати та відправити запит організатору
  Дочекатись синхронізації  dasu


Перевірити відображення інформаціїї запиту
  [Tags]  make_a_dialogue
  Отримати дані про останній запит
  :FOR  ${username}  IN  ${tender_owner}  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Перевірити title запиту  ${data_cdb}
  \  Перевірити description запиту  ${data_cdb}
  \  Перевірити date запиту  ${data_cdb}
  \  Зберегти сесію  ${username}


Неможливість відповісти на запит для ролей: viewer, provider
  [Tags]  make_a_dialogue
  :FOR  ${username}  IN  ${provider1}  ${viewer}
  \  Завантажити сесію для  ${username}
  \  Run Keyword And Expect Error  *  Відкрити бланк відповіді на запит
  \  Зберегти сесію  ${username}


Відповісти на запит
  [Tags]  make_a_dialogue
  Завантажити сесію для  ${tender_owner}
  Відкрити вкладку моніторингу
  Відкрити бланк відповіді на запит
  ${title}  Заповнити title відповіді на запит
  ${description}  Заповнити description відповіді на запит
  ${path}  ${name}  ${content}  Створити та додати файл  ${monitoring_selector}//*[@data-qa='dialogueAnswer-files']//input
  Відправити відповідь на запит
  Перевірити відправлені дані відповіді на запит  ${title}  ${description}  ${name}
  Зберегти сесію  ${tender_owner}


Перевірити відображення інформації про відповідь на запит
  [Tags]  make_a_dialogue
  :FOR  ${username}  IN  ${tender_owner}  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Перевірити date відповіді на запит
  \  Перевірити title відповіді на запит
  \  Перевірити description відповіді на запит
  \  Перевірити documents.title відповіді на запит
  \  Перевірити documents.datePublished відповіді на запит
  \  Зберегти сесію  ${username}


Підписати ЕЦП для відповіді на запит
  [Tags]  make_a_dialogue
  No Operation


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
  :FOR  ${username}  IN  ${tender_owner}  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Звірити результат висновку
  \  Звірити дату висновку
  \  Звірити інформацію про результати висновку
  \  Звірити опис висновку
  \  Звірити обов'язки висновку
  \  Зберегти сесію  ${username}


################################################################
#                       INSPECTION                             #
################################################################
Створити інспекцію
  [Tags]  inspection
  Сформувати та опублікувати інспекцію


Перевірити дані інспекції
  [Tags]  inspection
  :FOR  ${username}  IN  ${tender_owner}  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Відкрити вікно інспекції
  \  Перевірити наявність description інспекціїї
  \  Перевірити наявність inspection_id інспекціїї
  \  Перевірити наявність dateCreated інспекціїї
  \  Закрити вікно інспекцій
  \  Зберегти сесію  ${username}

################################################################
#                      CLARIFICATION                           #
################################################################
Неможливість створити запит за роз'ясненнями щодо висновку для ролей: viewer, provider
  [Tags]  request_for_clarification
  :FOR  ${username}  IN  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Run Keyword And Expect Error  *  Відкрити бланк запиту за роз'ясненнями
  \  Зберегти сесію  ${username}


Створити запит за роз'ясненнями щодо висновку
  [Tags]  request_for_clarification
  Завантажити сесію для  ${tender_owner}
  Відкрити вкладку моніторингу
  Відкрити бланк запиту за роз'ясненнями
  ${title}  Заповнити поле Предмет
  ${description}  Заповнити поле Опис
  ${path}  ${name}  ${content}  Створити та додати файл  ${monitoring_selector}//*[@data-qa='dialogue-files']//input
  Відправити пояснення
  Перевірити відправлені дані запиту за роз'ясненнями щодо висновку  ${title}  ${description}  ${name}
  Зберегти сесію  ${tender_owner}


Перевірити відображення запиту за роз'ясненням
  [Tags]  request_for_clarification
  :FOR  ${username}  IN  ${tender_owner}  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Звірити title запиту
  \  Звірити description запиту
  \  Звірити datePublished запиту
  \  Звірити documents.title запиту
  \  Звірити documents.datePublished запиту
  \  Зберегти сесію  ${username}


Надати відповідь на запит за роз'ясненнями щодо висновку органом ДАСУ
  [Tags]  request_for_clarification
  Сформувати та відправити відповідь органом ДАСУ
  Дочекатись синхронізації  dasu


Перевірити відображення відповіді на запит за роз'ясненнями щодо висновку органом ДАСУ
  [Tags]  request_for_clarification
  :FOR  ${username}  IN  ${tender_owner}  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Перевірити title відповіді на запит за роз'ясненнями щодо висновку органом ДАСУ
  \  Перевірити datePublished відповіді на запит за роз'ясненнями щодо висновку органом ДАСУ
  \  Перевірити description відповіді на запит за роз'ясненнями щодо висновку органом ДАСУ
  \  Зберегти сесію  ${username}



Накласти ЕЦП на запит за роз'ясненням
  [Tags]  request_for_clarification
  No Operation
#  ${selector}  Set Variable  ${monitoring_selector}//*[contains(text(), "Запит роз'яснень організатором")]/../following-sibling::*//*[contains(text(), 'Підписати ЕЦП')]
#  Перевірити можливість підписання ЕЦП для позову  ${selector}
#  Відкрити вкладку моніторингу
#  Перевірити успішність підписання ЕЦП  ${selector}


################################################################
#              VIOLATION ELIMINATION REPORT                    #
################################################################
Неможливість опублікувати інформацію про усунення порушення для ролей: viewer, provider
  [Tags]  violation_elimination_report
  :FOR  ${username}  IN  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Run Keyword And Expect Error  *  Відкрити бланк звіту про усунення порушення
  \  Зберегти сесію  ${username}


Опублікувати інформацію про усунення порушення
  [Tags]  violation_elimination_report
  Завантажити сесію для  ${tender_owner}
  Відкрити вкладку моніторингу
  Відкрити бланк звіту про усунення порушення
  ${description}  Заповнити поле Опис звіту про усунення порушення
  ${path}  ${name}  ${content}  Створити та додати файл  ${monitoring_selector}//*[@data-qa='eliminationReport-files']//input
  Відправити звіт про усунення порушення
  Перевірити відправлені дані звіту про усунення порушення  ${description}  ${name}
  Зберегти сесію  ${tender_owner}


Перевірити відображення інформації про усунення порушення
  [Tags]  violation_elimination_report
  :FOR  ${username}  IN  ${tender_owner}  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Перевірити дату інформації про усунення порушення
  \  Перевірити description інформації про усунення порушення
  \  Перевірити documents.title інформації про усунення порушення
  \  Перевірити documents.datePublished інформації про усунення порушення
  \  Зберегти сесію  ${username}

Накласти ЕЦП на звіт про усунення порушень
  [Tags]  violation_elimination_report
  No Operation
#  ${selector}  Set Variable  ${monitoring_selector}//*[contains(text(), 'Звіт про усунення порушень')]/following-sibling::*//*[contains(text(), 'Підписати ЕЦП')]
#  Перевірити можливість підписання ЕЦП для позову  ${selector}
#  Відкрити вкладку моніторингу
#  Перевірити успішність підписання ЕЦП  ${selector}


################################################################
#                          APPEAL                              #
################################################################
Неможливість опублікувати позов для ролей: viewer, provider
  [Tags]  appeal
  :FOR  ${username}  IN  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Run Keyword And Expect Error  *  Вікрити бланк позову
  \  Зберегти сесію  ${username}


Опублікувати позов
  [Tags]  appeal
  Завантажити сесію для  ${tender_owner}
  Відкрити вкладку моніторингу
  Вікрити бланк позову
  ${description}  Заповнити поле Опис позову
  ${path}  ${name}  ${content}  Створити та додати файл  ${monitoring_selector}//*[@data-qa='appeal-files']//input
  Відправити позов
  Перевірити відправлені дані позову  ${description}  ${name}
  Зберегти сесію  ${tender_owner}


Перевірити відображення інформації про позов
  [Tags]  appeal
  :FOR  ${username}  IN  ${tender_owner}  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Перевірити дату позову
  \  Перевірити description позову
  \  Перевірити documents.title позову
  \  Перевірити documents.datePublished позову
  \  Зберегти сесію  ${username}


Накласти ЕЦП на позов
  [Tags]  appeal
  No Operation
#  ${selector}  Set Variable  ${monitoring_selector}//*[contains(text(), 'Висновок оскаржено в суді')]/following-sibling::*//*[contains(text(), 'Підписати ЕЦП')]
#  Перевірити можливість підписання ЕЦП для позову  ${selector}
#  Відкрити вкладку моніторингу
#  Перевірити успішність підписання ЕЦП  ${selector}


################################################################
#                        COMPLETE                              #
################################################################
Підтвердити факт усунення порушення та перевести моніторинг в статус вирішено
  [Tags]  completed
  Сформувати рішення щодо усунення порушення
  Дочекатись закінчення elimination period
  Перевести моніторинг в статус  completed


Перевірити відображення інформації моніторингу в статусі в вирішено
  [Tags]  completed
  Отримати дані моніторингу по API
  :FOR  ${username}  IN  ${tender_owner}  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Звірити статус моніторингу
  \  Перевірити опис факту усунення порушення
  \  Зберегти сесію  ${username}


################################################################
#                     STOP MONITORING                          #
################################################################
Зупинити моніторинг у статусі active
  [Tags]  stopped_after_active
  Сформувати дані та зупинити моніторинг
  Дочекатись синхронізації  dasu


Перевірити відображення інформації про зупинку моніторунгу після active
  [Tags]  stopped_after_active
  :FOR  ${username}  IN  ${tender_owner}  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Отримати дані моніторингу по API
  \  Звірити статус моніторингу
  \  Перевірити опис зупинення моніторингу
  \  Перевірити дату зупинення моніторингу
  \  Зберегти сесію  ${username}


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
  :FOR  ${username}  IN  ${tender_owner}  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Звірити дату висновку
  \  Зберегти сесію  ${username}


################################################################
#                         CLOSED                               #
################################################################
Завершити моніторинг
  [Tags]  closed
  Дочекатись закінчення elimination period
  Перевести моніторинг в статус  closed
  Отримати дані моніторингу по API
  :FOR  ${username}  IN  ${tender_owner}  ${provider1}  ${viewer}
  \  ${loc}  Get Location
  \  Завантажити сесію для  ${username}
  \  Go to  ${loc}
  \  Відкрити вкладку моніторингу
  \  Звірити статус моніторингу
  \  Зберегти сесію  ${username}


#################################################################################################
#                                                                                               #
#                                         Keywords                                              #
#                                                                                               #
#################################################################################################
*** Keywords ***
Test Postcondition
  Log Location
  Run Keyword If Test Failed  Capture Page Screenshot


Отримати UAID та tender_Id для створеного тендера
  ${uaid}  Get Text  (//*[contains(text(),'UA')])[1]
  Set Global Variable  ${UAID}  ${uaid}
  Open Button  (//a[contains(@href,'smarttender.biz')])[1]
  Дочекатись закінчення загрузки сторінки
  ${id}  Get Text  //*[@data-qa='prozorro-id']//*[@data-qa='value']
  Set Global Variable  ${tender_ID}  ${id}


Повернутися на головну сторінку особистого кабінету
  Click Element  //*[@class='fa fa-user']
  Click Element  //a[contains(text(),'Особистий кабінет')]
  Дочекатись закінчення загрузки сторінки


Натиснути Повторить попытку (за необхідністю)
	${again locator}  Set Variable  //a[contains(text(),'Повтор')]
	${again status}  Run Keyword And Return Status  Wait Until Page Contains Element  ${again locator}
	Run Keyword If  ${again status} == ${True}
	...  Click Element  ${again locator}
	Дочекатись закінчення загрузки сторінки


Підготувати користувачів
	Set Global Variable  ${provider1}     user1
	Set Global Variable  ${viewer}        test_viewer
	Set Global Variable  ${tender_owner}  dasu

	Додати першого користувача  ${provider1}
	Додати користувача          ${viewer}
	Додати користувача          ${tender_owner}


Перейти за посиланням по dasu
  Sleep  2
  ${link}  Set Variable  xpath=//tbody/tr[@class="evenRow rowselected"]/td[count(//div[contains(text(), 'Мониторинг')]/ancestor::td[@draggable]/preceding-sibling::*)+1]
  Click Element  ${link}
  Wait Until Page Contains  Натисніть для переходу
  Click element  xpath=//a[contains(text(), 'Натисніть для переходу') and @href]
  Close Window
  ${web}  Select Window  Main
  ${location}  Get Location
  ${list}  Evaluate  '${location}'.split('?ticket')
  ${location}  Set Variable  ${list[0]}
  Set To Dictionary  ${data}  location  ${location}
  Log  ${location}  WARN


Відкрити вкладку моніторингу
  ${tab}             Set Variable  xpath=//*[contains(@class, 'ivu-tabs-tab')]//*[contains(text(), 'Моніторинг ДАСУ')]
  ${not_active_tab}  Set Variable  xpath=//*[contains(@class, 'ivu-tabs-tab') and not(contains(@class, 'active'))]//*[contains(text(), 'Моніторинг ДАСУ') ]
  ${active tab}      Set Variable  xpath=//*[contains(@class, 'ivu-tabs-tab') and (contains(@class, 'active'))]//*[contains(text(), 'Моніторинг ДАСУ') ]
  Дочекатись закінчення загрузки сторінки(skeleton)
  Scroll Page To Element XPATH  ${tab}
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${active_tab}
  Run Keyword If  '${status}' == 'False'  Wait Until Keyword Succeeds  15  3  Click Element  ${tab}
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${active_tab}
  Run Keyword If  '${status}' == 'False'  Відкрити вкладку моніторингу
  Дочекатись закінчення загрузки сторінки


Отримати дані моніторингу по API
  [Arguments]  ${field}=${None}  ${title}=${None}
  ${data_cdb}  Wait Until Keyword Succeeds  60  1  get_monitoring_data  ${data['id']}  ${field}  ${title}
  Log  ${data_cdb}
  Перевірити та зберегти відповідь  ${data_cdb}
  [Return]  ${data_cdb}


Перевірити та зберегти відповідь
  [Arguments]  ${data_cdb}
  Run Keyword And Ignore Error  Run keyword If  '${data_cdb["status"]}' == 'error'  Fatal Error  Look at the response
  Set Global Variable  ${data_cdb}


Розпочати моніторинг по тендеру
  [Arguments]  ${tender_ID}
  ${name}  create_sentence  1
  ${data_cdb}  Wait Until Keyword Succeeds  60  5
  ...  create_monitoring  ${tender_ID}  ${name}
  Log  ${data_cdb}
  ${data}  Create Dictionary  id  ${data_cdb['id']}
  Set Global Variable  ${data}


Скасувати моніторинг по тендеру
  ${description}  create_sentence  20
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${data_cdb}  Wait Until Keyword Succeeds  60  5  cancellation_monitoring
  ...  ${description}
  ...  ${relatedParty}
  ...  ${data['id']}
  Log  ${data_cdb}
  Перевірити та зберегти відповідь  ${data_cdb}
  Дочекатись синхронізації  dasu


Сформувати рішення по моніторингу
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${description}  create_sentence  20
  ${data_cdb}  Wait Until Keyword Succeeds  60  5  decision
  ...  ${relatedParty}
  ...  ${description}
  ...  ${data['id']}
  Log  ${data_cdb}
  Перевірити та зберегти відповідь  ${data_cdb}


Перевести моніторинг в статус
  [Arguments]  ${status}
  ${data_cdb}  Wait Until Keyword Succeeds  60  5  change_monitoring_status
  ...  ${status}
  ...  ${data['id']}
  Log  ${data_cdb}
  Перевірити та зберегти відповідь  ${data_cdb}
  Дочекатись синхронізації  dasu


Сформувати рішення щодо усунення порушення
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${description}  create_sentence  20
  ${data_cdb}  eliminationResolution
  ...  ${relatedParty}
  ...  ${description}
  ...  ${data['id']}
  Log  ${data_cdb}
  Перевірити та зберегти відповідь  ${data_cdb}


Дочекатись закінчення elimination period
  ${cdb}  Set Variable  ${data_cdb['eliminationPeriod']['endDate']}
  ${until}  convert_date_from_cdb  ${cdb}
  ${now}  Get Current Date
  ${sleep}  Subtract Date From Date  ${until}  ${now}
  Run Keyword If  ${sleep} > ${0}  Sleep  ${sleep}
  Sleep  5


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
  ${cdb_time}  service.convert_datetime_to_smart_format  ${cdb_time}  m
  ${status}  compare_dates_smarttender  ${cdb_time}  ==  ${site_time}
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
  ${cdb_time}  service.convert_datetime_to_smart_format  ${cdb_time}  m
  ${status}  compare_dates_smarttender  ${cdb_time}  ==  ${site_time}
  Should Be Equal  ${status}  ${True}


Опублікувати висновок з інформацією про порушення
  ${violationOccurred}  Set Variable  ${True}
  ${description}  create_sentence  20
  ${stringsAttached}  create_sentence  10
  ${auditFinding}  create_sentence  10
  ${data_cdb}  conclusion_true
  ...  ${violationOccurred}
  ...  ${description}
  ...  ${stringsAttached}
  ...  ${auditFinding}
  ...  ${data['id']}
  Log  ${data_cdb}
  Перевірити та зберегти відповідь  ${data_cdb}


Звірити результат висновку
  ${cdb}  Set Variable  ${data_cdb['conclusion']['violationOccurred']}
  ${text}  Get Text  ${monitoring_selector}//*[contains(text(), 'Висновок')]/following-sibling::*/*[@class='break-word']/div[1]/div
  ${site}  convert_data_from_the_page  ${text}  status
  Should Be Equal  ${site}  ${cdb}


Звірити дату висновку
  ${cdb_time}  Set Variable  ${data_cdb['conclusion']['dateCreated']}
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Висновок')]
  ${site_time}  convert_data_from_the_page  ${site}  decision.date
  ${cdb_time}  service.convert_datetime_to_smart_format  ${cdb_time}  m
  ${status}  compare_dates_smarttender  ${cdb_time}  ==  ${site_time}
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
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), "${data_cdb['title']}")]/following-sibling::*
  Should Be Equal  ${cdb}  ${site}


Звірити datePublished запиту
  ${cdb_time}  Set Variable  ${data_cdb['datePublished']}
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), "Запит роз'яснень організатором")]
  ${site_time}  convert_data_from_the_page  ${site}  decision.date
  ${cdb_time}  service.convert_datetime_to_smart_format  ${cdb_time}  m
  ${status}  compare_dates_smarttender  ${cdb_time}  ==  ${site_time}
  Should Be Equal  ${status}  ${True}


Звірити documents.title запиту
  ${cdb}  Set Variable  ${data_cdb['documents'][0]['title']}
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), "${data_cdb['title']}")]/../following-sibling::*//a
  Should Be Equal  ${cdb}  ${site}


Звірити documents.datePublished запиту
  ${cdb_time}  Set Variable  ${data_cdb['documents'][0]['datePublished']}
  ${site}  Get Text  ${monitoring_selector}//*[contains(text(), "${data_cdb['title']}")]/../following-sibling::*//a/../following-sibling::*
  ${cdb_time}  service.convert_datetime_to_smart_format  ${cdb_time}  m
  ${status}  compare_dates_smarttender  ${cdb_time}  ==  ${site}
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
  ${cdb_time}  Set Variable  ${data_cdb['eliminationReport']['dateCreated']}
  ${text_site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Звіт про усунення порушень')]
  ${date_site}  convert_data_from_the_page  ${text_site}  decision.date
  ${cdb_time}  service.convert_datetime_to_smart_format  ${cdb_time}  m
  ${status}  compare_dates_smarttender  ${date_site}  ==  ${cdb_time}
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
  ${cdb_time}  Set Variable  ${data_cdb['eliminationReport']['documents'][0]['datePublished']}
  ${file_date_site}  Get Text  ${monitoring_selector}//*[@data-qa="monitoring-eliminationReport-description"]/following-sibling::*/div[2]/div/div/div[2]
  ${cdb_time}  service.convert_datetime_to_smart_format  ${cdb_time}  m
  ${status}  compare_dates_smarttender  ${cdb_time}  ==  ${file_date_site}
  Should Be Equal  ${status}  ${True}


Перевірити дату позову
  ${cdb_time}  Set Variable  ${data_cdb['appeal']['datePublished']}
  ${text_site}  Get Text  ${monitoring_selector}//*[contains(text(), 'Висновок оскаржено в суді')]
  ${date_site}  convert_data_from_the_page  ${text_site}  decision.date
  ${cdb_time}  service.convert_datetime_to_smart_format  ${cdb_time}  m
  ${status}  compare_dates_smarttender  ${date_site}  ==  ${cdb_time}
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
  ${cdb_time}  Set Variable  ${data_cdb['appeal']['documents'][0]['datePublished']}
  ${file_date_site}  Get Text  ${monitoring_selector}//*[@data-qa="monitoring-appeal-description"]/following-sibling::*/div[2]/div/div/div[2]
  ${cdb_time}  service.convert_datetime_to_smart_format  ${cdb_time}  m
  ${status}  compare_dates_smarttender  ${cdb_time}  ==  ${file_date_site}
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
  ${cdb_time}  service.convert_datetime_to_smart_format  ${data_cdb['datePublished']}  m
  ${status}  compare_dates_smarttender  ${date_site}  ==  ${cdb_time}
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
  ${cdb_time}  service.convert_datetime_to_smart_format  ${data_cdb['documents'][0]['datePublished']}  m
  ${status}  compare_dates_smarttender  ${documents.datePublished}  ==  ${cdb_time}
  Should Be Equal  ${status}  ${True}


Перевірити title відповіді на пояснення з власної ініціативи
  ${title}  Get Text  //*[contains(text(), "${data_cdb['title']}")]
  Should Be Equal  ${title}  ${data_cdb['title']}


Перевірити datePublished відповіді на пояснення з власної ініціативи
  ${text}  Get Text  (//*[contains(text(), "${data_cdb['title']}")]/ancestor::*[@class='ivu-row'])[last()]//*[contains(@class, 'muted')]
  ${date_site}  convert_data_from_the_page  ${text}  posts.datePublished
  ${cdb_time}  service.convert_datetime_to_smart_format  ${data_cdb['datePublished']}  m
  ${status}  compare_dates_smarttender  ${cdb_time}  ==  ${date_site}
  Should Be Equal  ${status}  ${True}


Перевірити description відповіді на пояснення з власної ініціативи
  ${description}  Get Text  //*[contains(text(), "${data_cdb['title']}")]/following-sibling::*
  Should Be Equal  ${description}  ${data_cdb['description']}


Перевірити title відповіді на запит за роз'ясненнями щодо висновку органом ДАСУ
  ${title}  Get Text  //*[contains(text(), "${data_cdb['title']}")]
  Should Be Equal  ${title}  ${data_cdb['title']}


Перевірити datePublished відповіді на запит за роз'ясненнями щодо висновку органом ДАСУ
  ${text}  Get Text  (//*[contains(text(), "${data_cdb['title']}")]/ancestor::*[@class='ivu-row'])[last()]//*[contains(@class, 'muted')]
  ${date_site}  convert_data_from_the_page  ${text}  posts.datePublished
  ${cdb_time}  service.convert_datetime_to_smart_format  ${data_cdb['datePublished']}  m
  ${status}  compare_dates_smarttender  ${cdb_time}  ==  ${date_site}
  Should Be Equal  ${status}  ${True}


Перевірити description відповіді на запит за роз'ясненнями щодо висновку органом ДАСУ
  ${title}  Get Text  //*[contains(text(), "${data_cdb['title']}")]
  Should Be Equal  ${title}  ${data_cdb['title']}


Сформувати та відправити запит організатору
  ${title}  create_sentence  5
  ${description}  create_sentence  20
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${data_cdb}  make_a_dialogue
  ...  ${title}
  ...  ${description}
  ...  ${relatedParty}
  ...  ${data['id']}
  Log  ${data_cdb}
  Перевірити та зберегти відповідь  ${data_cdb}
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
  ${text}  Get Text  (//*[contains(text(), "${data_cdb['title']}")]/ancestor::*[@class="ivu-row"])[last()]//*[@class="text-muted"]
  ${date_site}  convert_data_from_the_page  ${text}  decision.date
  ${cdb_time}  service.convert_datetime_to_smart_format  ${data_cdb['datePublished']}  m
  ${status}  compare_dates_smarttender  ${date_site}  ==  ${cdb_time}
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
  ${cdb_time}  service.convert_datetime_to_smart_format  ${data_cdb['datePublished']}  m
  ${status}  compare_dates_smarttender  ${date_site}  ==  ${cdb_time}
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
  ${cdb_time}  service.convert_datetime_to_smart_format  ${data_cdb['documents'][0]['datePublished']}  m
  ${status}  compare_dates_smarttender  ${documents.datePublished}  ==  ${cdb_time}
  Should Be Equal  ${status}  ${True}


Сформувати дані та зупинити моніторинг
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${description}  create_sentence  15
  ${data_cdb}  stopped
  ...  ${description}
  ...  ${relatedParty}
  ...  ${data['id']}
  Log  ${data_cdb}
  Перевірити та зберегти відповідь  ${data_cdb}


Перевірити опис зупинення моніторингу
  ${cdb_description}  Set Variable  ${data_cdb['cancellation']['description']}
  ${description}  Get Text  ${monitoring_selector}//*[@data-qa="monitoring-cancellation-description"]/..
  Should Be Equal  ${cdb_description}  ${description}


Перевірити дату зупинення моніторингу
  ${cdb_time}  Set Variable  ${data_cdb['cancellation']['datePublished']}
  ${text}  Get Text  ${monitoring_selector}//*[@data-qa="monitoring-cancellation-description"]/../preceding-sibling::div
  ${site_time}  convert_data_from_the_page  ${text}  decision.date
  ${cdb_time}  service.convert_datetime_to_smart_format  ${cdb_time}  m
  ${status}  compare_dates_smarttender  ${cdb_time}  ==  ${site_time}
  Should Be Equal  ${status}  ${True}


Опублікувати висновок про відсутність порушень
  ${violationOccurred}  Set Variable  ${False}
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${data_cdb}  conclusion_false
  ...  ${violationOccurred}
  ...  ${relatedParty}
  ...  ${data['id']}
  Log  ${data_cdb}
  Перевірити та зберегти відповідь  ${data_cdb}


Сформувати та опублікувати інспекцію
  ${description}  create_sentence  20
  ${data_cdb}  inspection
  ...  ${description}
  ...  ${data['id']}
  Log  ${data_cdb}
  Перевірити та зберегти відповідь  ${data_cdb}
  Дочекатись синхронізації  inspection


Відкрити вікно інспекції
  Sleep  2
  Click Element  ${monitoring_selector}//*[@data-qa="inspection-show"]


Перевірити наявність description інспекціїї
  ${description}  Set Variable  ${data_cdb['description']}
  Page Should Contain Element  //*[@class="ivu-modal-content"]//*[contains(text(), "Інспекції")]/../..//*[contains(text(), "${description}")]


Перевірити наявність inspection_id інспекціїї
  ${inspection_id}  Set Variable  ${data_cdb['inspection_id']}
  Page Should Contain Element  //*[@class="ivu-modal-content"]//*[contains(text(), "Інспекції")]/../..//*[contains(text(), "${inspection_id}")]


Перевірити наявність dateCreated інспекціїї
  ${dateCreated}  Set Variable  ${data_cdb['dateCreated']}
  ${data_converted}  service.convert_datetime_to_smart_format  ${dateCreated}  m
  Page Should Contain Element  //*[@class="ivu-modal-content"]//*[contains(text(), "Інспекції")]/../..//*[contains(text(), "${data_converted}")]


Закрити вікно інспекцій
  Click Element  //*[@class='ivu-modal-content']//*[contains(text(), 'Інспекції')]/../..//*[contains(text(), 'Закрити')]
  ${status}  Run Keyword And Return Status
  ...  Wait Until Element Is Not Visible  //*[@class='ivu-modal-content']//*[contains(text(), 'Інспекції')]/../..//*[contains(text(), 'Закрити')]  20
  Run Keyword If  '${status}' == 'False'  Закрити вікно інспекцій


Перейти у webclient за необхідністю
  ${status}  Run Keyword And Return Status  Page Should Contain  организатор
  Run Keyword If  '${status}' == 'True'  Перейти у webclient


Перейти у webclient
  Go To  ${start_page}/webclient/
  Дочекатись закінчення загрузки сторінки(webclient)


Змінити мову на укр.
  Click Element  //*[@class="dxr-groupContent"]/div/a[2]
  ${selector}  Set Variable  //*[contains(text(), "Українська")]
  ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  ${selector}
  Натиснути Повторить попытку (за необхідністю)
  Run Keyword If  ${status} != ${true}  Click Element  //*[@class="dxr-groupContent"]/div/a[2]
  Wait Until Page Contains Element  ${selector}  30
  Sleep  2
  Click Element  ${selector}
  Wait Until Element Is Not Visible  ${selector}  15
  Дочекатись закінчення загрузки сторінки(webclient)


Сформувати та відправити відповідь органом ДАСУ
  [Documentation]  для:
  ...  Подати пояснення з власної ініціативи
  ...  Створити запит за роз'ясненнями щодо висновку
  ${title}  create_sentence  3
  ${description}  create_sentence  4
  ${relatedParty}  Отримати дані моніторингу по API  parties.0.id
  ${relatedPost}  Отримати дані моніторингу по API  posts.-1.id
  ${data_cdb}  sas_answer
  ...  ${title}
  ...  ${description}
  ...  ${relatedParty}
  ...  ${relatedPost}
  ...  ${data['id']}
  Log  ${data_cdb}
  Перевірити та зберегти відповідь  ${data_cdb}
