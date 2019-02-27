*** Settings ***
Resource    ../../src/src.robot
Library     ../../suites/dozorro/dozorro_srv.py
Variables   ../../suites/dozorro/var.py
Suite Setup  Підготувати користувачів
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


#  robot --consolecolors on -L TRACE:INFO -A suites/dozorro/arguments.txt -v hub:None -i $variable suites/dozorro/prod.robot
*** Variables ***

${first tender in search}            //*[@id='tenders']//tbody/*[@class='head']//a[@class='linkSubjTrading']
${sort date}                         xpath=//*[@id="tenders"]//tr/*[contains(text(), 'Дата')]
${org_field}                         xpath=(//label[contains(text(), 'Організатори')]/following::input[@type='text'])[1]
${multylot}
${location}
${comment_num}
${username}
${add_offer}                         xpath=//*[contains(text(), 'Подати пропозицію')]
${advanced search}                   xpath=//div[contains(text(),'Розширений пошук')]/..
${type_1-8_10}                       ${forms_1_to_8_10}
${type_9}                            ${forms_9}
${type_9_multylot}                   ${forms_9_multylot}
${type_11-12}                        ${forms_11_to_12}
${type_11-12_multylot}               ${forms_11_to_12_multylot}
${type_13}                           ${forms_13}
${type_13_multylot}                  ${forms_13_multylot}



*** Test Cases ***

################################################################
#                      ПЕРІОД УТОЧНЕНЬ                         #
################################################################
Знайти випадковий тендер з потрібним статусом (Період уточнень)
    [Tags]  clarification
    Завантажити сесію для  ${provider}
    Відкрити сторінку тестових торгів
    Знайти випадковий тендер з потрібним статусом  Період уточнень


Перевірити відповідність видів відгуків з дозволеними (Період уточнень)
    [Tags]  clarification
    dozorro.Відкрити сторінку відгуки Dozorro
    Перевірити відповідність видів відгуків  ${type_1-8_10}


Залишити відгуки по кожному виду (Період уточнень)
    [Tags]  clarification
    Надати відгук  1
    #Надати відгук  2
    #Надати відгук  3
    #Надати відгук  4
    Надати відгук  5
    #Надати відгук  6
    #Надати відгук  7
    #Надати відгук  8
    Надати відгук  10


Перевірити відображення відгуку всіма ролями (Період уточнень)
  [Tags]  clarification
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення відгуку   ${username}


Неможливість залишити відгук ролями viewer tender_owner (Період уточнень)
  [Tags]  clarification
  ...  non-critical
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Можливість залишити відгук  ${username}


Залишити коментар дозволеними ролями (Період уточнень)
  [Tags]  clarification
  Завантажити сесію для  ${provider}
  Залишити коментар на випадковий відгук


Перевірити відображення коментарів всіма ролями (Період уточнень)
  [Tags]  clarification
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення коментаря  ${username}


Неможливість залишити коментар ролями viewer tender_owner (Період уточнень)
  [Tags]  clarification
  ...  non-critical
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Set Global Variable  ${username}
  \  Можливість залишити коментар  ${username}


Перевірити роботу фільтрів всіма ролями (Період уточнень)
  [Tags]  clarification
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}
  \  Перевірити фільтр відгуків  ${username}


################################################################
#                    ПРИЙОМ ПРОПОЗИЦІЙ                         #
################################################################
Знайти випадковий тендер з потрібним статусом беру участь (Прийом пропозицій)
  [Tags]  acceptance
  Завантажити сесію для  ${provider}
  Відкрити сторінку тестових торгів
  Знайти випадковий тендер з потрібним статусом беру участь  Прийом пропозицій

Перевірити відповідність видів відгуків з дозволеними (Прийом пропозицій)
  [Tags]  acceptance
  :FOR  ${username}  IN  ${provider}  ${provider2}
  \  Завантажити сесію для  ${username}
  \  Go to  ${data.tender_url}
  \  dozorro.Відкрити сторінку відгуки Dozorro
  \  Перевірити відповідність видів відгуків  ${type_1-8_10}

Залишити відгуки по кожному виду (Прийом пропозицій)
  [Tags]  acceptance
  :FOR  ${username}  IN  ${provider}  ${provider2}
  \  Завантажити сесію для  ${username}
  \  Go to  ${data.tender_url}
  \  dozorro.Відкрити сторінку відгуки Dozorro
  #\  Надати відгук  1
  #\  Надати відгук  2
  \  Надати відгук  3
  #\  Надати відгук  4
  #\  Надати відгук  5
  #\  Надати відгук  6
  #\  Надати відгук  7
  \  Надати відгук  8
  \  Надати відгук  10

Перевірити відображення відгуку всіма ролями (Прийом пропозицій)
  [Tags]  acceptance
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення відгуку  ${username}

Неможливість залишити відгук ролями viewer tender_owner (Прийом пропозицій)
  [Tags]  acceptance
  ...  non-critical
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Можливість залишити відгук  ${username}

Залишити коментар дозволеними ролями (Прийом пропозицій)
  [Tags]  acceptance
  :FOR  ${username}  IN  ${provider}  ${provider2}
  \  Завантажити сесію для  ${username}
  \  Go to  ${data.tender_url}
  \  Відкрити Сторінку Відгуки Dozorro
  \  Залишити коментар на випадковий відгук

Перевірити відображення коментарів всіма ролями (Прийом пропозицій)
  [Tags]  acceptance
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення коментаря  ${username}

Неможливість залишити коментар ролями viewer tender_owner (Прийом пропозицій)
  [Tags]  acceptance
  ...  non-critical
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Set Global Variable  ${username}
  \  Можливість залишити коментар  ${username}

Перевірити роботу фільтрів всіма ролями (Прийом пропозицій)
  [Tags]  acceptance
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірити фільтр відгуків  ${username}


################################################################
#                     ПРОПОЗИЦІЇ РОЗГЛЯНУТІ                    #
################################################################
Знайти випадковий тендер з потрібним статусом беру участь (Пропозиції розглянуті)
  [Tags]  considered
  Завантажити сесію для  ${provider}
  Відкрити сторінку тестових торгів
  Знайти випадковий тендер з потрібним статусом беру участь  Пропозиції розглянуті

Перевірити відповідність видів відгуків з дозволеними (Пропозиції розглянуті)
  [Tags]  considered
  dozorro.Відкрити сторінку відгуки Dozorro
  Перевірити відповідність видів відгуків  ${type_11-12}

Залишити відгуки по кожному виду (Пропозиції розглянуті)
  [Tags]  considered
  Надати відгук  11
  Надати відгук  12

Перевірити відображення відгуку всіма ролями (Пропозиції розглянуті)
  [Tags]  considered
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення відгуку  ${username}

Неможливість залишити відгук ролями viewer provider2 (Пропозиції розглянуті)
  [Tags]  considered
  ...  non-critical
  :FOR  ${username}  IN  ${viewer}  ${provider2}
  \  Можливість залишити відгук  ${username}

Залишити коментар дозволеними ролями (Пропозиції розглянуті)
  [Tags]  considered
  Завантажити сесію для  ${provider}
  Залишити коментар на випадковий відгук

Перевірити відображення коментарів всіма ролями (Пропозиції розглянуті)
  [Tags]  considered
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення коментаря  ${username}

Неможливість залишити коментар ролями viewer provider2 (Пропозиції розглянуті)
  [Tags]  considered
  ...  non-critical
  :FOR  ${username}  IN  ${viewer}  ${provider2}
  \  Set Global Variable  ${username}
  \  Можливість залишити коментар  ${username}

Перевірити роботу фільтрів всіма ролями (Пропозиції розглянуті)
  [Tags]  considered
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider2}
  \  Перевірити фільтр відгуків  ${username}


################################################################
#                         КВАЛІФІКАЦІЯ                         #
################################################################
Знайти тендер беру участь (Кваліфікація)
  [Tags]  qualification
  Завантажити сесію для  ${provider}
  Відкрити сторінку тестових торгів
  Знайти випадковий тендер з потрібним статусом беру участь  Кваліфікація

Перевірити відповідність видів відгуків з дозволеними (Кваліфікація)
  [Tags]  qualification
  dozorro.Відкрити сторінку відгуки Dozorro
  Перевірити відповідність видів відгуків  ${type_11-12}

Залишити відгуки по кожному виду (Кваліфікація)
  [Tags]  qualification
  Надати відгук  11
  Надати відгук  12

Перевірити відображення відгуку всіма ролями (Кваліфікація)
  [Tags]  qualification
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення відгуку  ${username}
  
Неможливість залишити відгук ролями viewer provider2 (Кваліфікація)
  [Tags]  qualification
  ...  non-critical
   :FOR  ${username}  IN  ${viewer}  ${provider2}
  \  Можливість залишити відгук  ${username}

Залишити коментар дозволеними ролями (Кваліфікація)
  [Tags]  qualification
  Завантажити сесію для  ${provider}
  Залишити коментар на випадковий відгук
 
Перевірити відображення коментарів всіма ролями (Кваліфікація)
  [Tags]  qualification
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення коментаря  ${username}

Неможливість залишити коментар ролями viewer provider2 (Кваліфікація)
  [Tags]  qualification
  ...  non-critical
  :FOR  ${username}  IN  ${viewer}  ${provider2}
  \  Set Global Variable  ${username}
  \  Можливість залишити коментар  ${username}

Перевірити роботу фільтрів всіма ролями (Кваліфікація)
  [Tags]  qualification
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider2}
  \  Перевірити фільтр відгуків  ${username}


################################################################
#                         ЗАВЕРШЕНО                            #
################################################################
Знайти тендер беру участь (Завершено)
  [Tags]  completed
  Завантажити сесію для  ${provider}
  Відкрити сторінку тестових торгів
  Знайти випадковий тендер з потрібним статусом беру участь  Завершено

Перевірити відповідність видів відгуків з дозволеними (Завершено)
  [Tags]  completed
  dozorro.Відкрити сторінку відгуки Dozorro
  Перевірити відповідність видів відгуків  ${type_11-12}

Залишити відгуки по кожному виду (Завершено)
  [Tags]  completed
  Надати відгук  11
  Надати відгук  12

Перевірити відображення відгуку всіма ролями (Завершено)
  [Tags]  completed
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення відгуку  ${username}

Неможливість залишити відгук ролями viewer provider2 (Завершено)
  [Tags]  completed
  ...  non-critical
  :FOR  ${username}  IN  ${viewer}  ${provider2}
  \  Можливість залишити відгук  ${username}

Залишити коментар дозволеними ролями (Завершено)
  [Tags]  completed
  Завантажити сесію для  ${provider}
  Залишити коментар на випадковий відгук

Перевірити відображення коментарів всіма ролями (Завершено)
  [Tags]  completed
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення коментаря  ${username}

Неможливість залишити коментар ролями viewer provider2 (Завершено)
  [Tags]  completed
  ...  non-critical
  :FOR  ${username}  IN  ${viewer}  ${provider2}
  \  Set Global Variable  ${username}
  \  Можливість залишити коментар  ${username}

Перевірити роботу фільтрів всіма ролями (Завершено)
  [Tags]  completed
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider2}
  \  Перевірити фільтр відгуків  ${username}


################################################################
#                        ЗАКУПКА НЕ ВІДБУЛАСЬ                  #
################################################################
Знайти тендер беру участь (Закупівля не відбулась)
  [Tags]  not_take_place
  Завантажити сесію для  ${provider}
  Відкрити сторінку тестових торгів
  Знайти випадковий тендер з потрібним статусом беру участь  Закупівля не відбулась

Перевірити відповідність видів відгуків з дозволеними (Закупівля не відбулась)
  [Tags]  not_take_place
  dozorro.Відкрити сторінку відгуки Dozorro
  Перевірити відповідність видів відгуків  ${type_11-12}

Залишити відгуки по кожному виду (Закупівля не відбулась)
  [Tags]  not_take_place
  Надати відгук  11
  Надати відгук  12

Перевірити відображення відгуку всіма ролями (Закупівля не відбулась)
  [Tags]  not_take_place
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення відгуку  ${username}

Неможливість залишити відгук ролями viewer provider2 (Закупівля не відбулась)
  [Tags]  not_take_place
  ...  non-critical
  :FOR  ${username}  IN  ${viewer}  ${provider2}
  \  Можливість залишити відгук  ${username}

Залишити коментар дозволеними ролями (Закупівля не відбулась)
  [Tags]  not_take_place
  Завантажити сесію для  ${provider}
  Залишити коментар на випадковий відгук

Перевірити відображення коментарів всіма ролями (Закупівля не відбулась)
  [Tags]  not_take_place
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення коментаря  ${username}

Неможливість залишити коментар ролями viewer provider2 (Закупівля не відбулась)
  [Tags]  not_take_place
  ...  non-critical
  :FOR  ${username}  IN  ${viewer}  ${provider2}
  \  Set Global Variable  ${username}
  \  Можливість залишити коментар  ${username}

Перевірити роботу фільтрів всіма ролями (Закупівля не відбулась)
  [Tags]  not_take_place
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider2}
  \  Перевірити фільтр відгуків  ${username}


################################################################
#                      ЗАКУПІВЛЯ ВІДМІНЕНА                     #
################################################################
Знайти тендер беру участь (Закупівля відмінена)
  [Tags]  canceled
  Завантажити сесію для  ${provider}
  Відкрити сторінку тестових торгів
  Знайти випадковий тендер з потрібним статусом  Закупівля відмінена


Перевірити відповідність видів відгуків з дозволеними (Закупівля відмінена)
  [Tags]  canceled
  dozorro.Відкрити сторінку відгуки Dozorro
  Перевірити відповідність видів відгуків  ${type_9}

Залишити відгуки по кожному виду (Закупівля відмінена)
  [Tags]  canceled
  Надати відгук  9

Перевірити відображення відгуку всіма ролями (Закупівля відмінена)
  [Tags]  canceled
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення відгуку  ${username}

Неможливість залишити відгук ролями viewer tender_owner (Закупівля відмінена)
  [Tags]  canceled
  ...  non-critical
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Можливість залишити відгук  ${username}

Залишити коментар дозволеними ролями (Закупівля відмінена)
  [Tags]  canceled
  Завантажити сесію для  ${provider}
  Залишити коментар на випадковий відгук

Перевірити відображення коментарів всіма ролями (Закупівля відмінена)
  [Tags]  canceled
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення коментаря  ${username}

Неможливість залишити коментар ролями viewer tender_owner (Закупівля відмінена)
  [Tags]  canceled
  ...  non-critical
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}
  \  Set Global Variable  ${username}
  \  Можливість залишити коментар  ${username}

Перевірити роботу фільтрів всіма ролями (Закупівля відмінена)
  [Tags]  canceled
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}
  \  Перевірити фільтр відгуків  ${username}


################################################################
#                            АКТИВНА                           #
################################################################
Знайти тендер беру участь (Опубліковано намір укласти договір)
  [Tags]  active
  ...  smart
  Завантажити сесію для  ${provider}
  Відкрити сторінку тестових торгів
  Знайти випадковий тендер з потрібним статусом беру участь  Опубліковано намір укласти договір

Перевірити відповідність видів відгуків з дозволеними (Опубліковано намір укласти договір)
  [Tags]  active
  ...  smart
  dozorro.Відкрити сторінку відгуки Dozorro
  Перевірити відповідність видів відгуків  ${type_11-12}

Залишити відгуки по кожному виду (Опубліковано намір укласти договір)
  [Tags]  active
  ...  smart
  Надати відгук  11
  Надати відгук  12

Перевірити відображення відгуку всіма ролями (Опубліковано намір укласти договір)
  [Tags]  active
  ...  smart
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення відгуку  ${username}

Неможливість залишити відгук ролями viewer provider2 (Опубліковано намір укласти договір)
  [Tags]  active
  ...  non-critical
  ...  smart
  :FOR  ${username}  IN  ${viewer}  ${provider2}
  \  Можливість залишити відгук  ${username}

Залишити коментар дозволеними ролями (Опубліковано намір укласти договір)
  [Tags]  active
  ...  smart
  Завантажити сесію для  ${provider}
  Залишити коментар на випадковий відгук

Перевірити відображення коментарів всіма ролями (Опубліковано намір укласти договір)
  [Tags]  active
  ...  smart
  :FOR  ${username}  IN  ${viewer}  ${tender_owner}  ${provider}  ${provider2}
  \  Перевірка відображення коментаря  ${username}

Неможливість залишити коментар ролями viewer provider2 (Опубліковано намір укласти договір)
  [Tags]  active
  ...  non-critical
  ...  smart
  :FOR  ${username}  IN  ${viewer}  ${provider2}
  \  Set Global Variable  ${username}
  \  Можливість залишити коментар  ${username}

Перевірити роботу фільтрів всіма ролями (Опубліковано намір укласти договір)
  [Tags]  active
  ...  smart
  :FOR  ${username}  IN  ${viewer}  ${provider}  ${provider2}
  \  Перевірити фільтр відгуків  ${username}





*** Keywords ***
Підготувати користувачів
    Set Global Variable  ${tender_owner}  prod_owner
    Set Global Variable  ${provider}      prod_provider1
    Set Global Variable  ${provider2}     prod_provider2
    Set Global Variable  ${viewer}        prod_viewer

    
    Додати першого користувача  ${tender_owner}
    Додати користувача          ${provider}
    Додати користувача          ${provider2}
    Додати користувача          ${viewer}
    Створити словник            data


Postcondition
    Close All Browsers


Перевірити чи тендер мультилот
    ${status}  Run Keyword and Return Status  Element Should Be Visible  ${first tender in search}/../..//*[contains(text(),'Мультилоти')]
    ${multylot}  Set Variable  ${status}
    Set Global Variable  ${multylot}
    Log  ${multylot}


Змінити значення мультилоту
    ${multylot}  Set Variable  ${False}
    Set Global Variable  ${multylot}

########################### ПОШУК ###############################

Знайти випадковий тендер з потрібним статусом беру участь
  [Arguments]  ${status}
  old_search.Розгорнути розширений пошук
  Відфільтрувати по статусу торгів  ${status}
  old_search.Фільтр беру участь
  Виконати пошук тендера
  #Відфільтрувати по спаданню дати
  Перевірити чи тендер мультилот
  old_search.Перейти по результату пошуку за номером  1
  ${location}  Get Location
  Додаткова перевірка на тестові торги для продуктива
  Log  ${location}  WARN
  Set To Dictionary  ${data}  tender_url=${location}


Знайти випадковий тендер з потрібним статусом
  [Arguments]  ${status}
  old_search.Розгорнути розширений пошук
  Відфільтрувати по статусу торгів  ${status}
  Виконати пошук тендера
  #Відфільтрувати по спаданню дати
  Перевірити чи тендер мультилот
  old_search.Перейти по результату пошуку за номером  1
  ${location}  Get Location
  Додаткова перевірка на тестові торги для продуктива
  Log  ${location}  WARN
  Set To Dictionary  ${data}  tender_url=${location}


Фільтр Організатор  #TODO необхідність цього кейворда?
  Click Element  ${org_field}
  Input Text  ${org_field}  Демо орг
  Wait Until Keyword Succeeds  30s  5  Click Element  xpath=//*[contains(text(), '111111111')]


Відфільтрувати по спаданню дати  #TODO необхідність цього кейворда?
  Wait Until Keyword Succeeds  30s  5  Click Element  ${sort date}
  Wait Until Keyword Succeeds  30s  5  Click Element  ${sort date}
  Wait Until Element Is Visible  ${first tender in search}


########################### ВІДГУК ###############################
Надати відгук
  [Arguments]  ${idscheme}
  Log  ${multylot}
  Надати відгук для мультилоту
  dozorro.Натиснути кнопку залишити відгук
  Run Keyword If  '${multylot}' != 'True' and ${forms_type} == ${type_9}  No Operation
  ...  ELSE  Вибрати вид відгуку зі списку  ${idscheme}
  Наповнити відгук інформацією  ${idscheme}
  dozorro.Відправити відгук


Вибрати вид відгуку зі списку
  [Arguments]  ${idscheme}
  dozorro.Розкрити список відгуків
  ${selector}=  get_review_selector  ${idscheme}
  Wait Until Keyword Succeeds  30s  5  Click Element  ${selector}


Наповнити відгук інформацією
  [Arguments]  ${idscheme}
  Run Keyword If  '${idscheme}' == '1'  Run Keywords
  ...  Wait Until Keyword Succeeds  30s  5  Click Element  xpath=(//input[@type='radio'])[5]
  ...  AND  Вставити довільний текст відгуку
  Run Keyword If  '${idscheme}' == '2' or '${idscheme}' == '10'   Надати відгук виду 2, 10
  Run Keyword If  '${idscheme}' in '3456789'  Run Keywords
  ...  Wait Until Keyword Succeeds  30s  5  Click Element  xpath=(//input[@type='radio'])[1]
  ...  AND  Вставити довільний текст відгуку
  Run Keyword If  '${idscheme}' == '11'  Надати відгук виду 11
  Run Keyword If  '${idscheme}' == '12'  Надати відгук виду 12


Надати відгук виду 2, 10
  :FOR  ${i}  IN RANGE  1  8  2
  \  Wait Until Keyword Succeeds  30s  5  Click Element  xpath=(//input[@type='radio'])[${i}]
  :FOR  ${t}  IN RANGE  1  5
  \  Вставити довільний текст відгуку виду 2,10,11,12  ${t}


Надати відгук виду 11
  :FOR  ${i}  IN RANGE  1  5  2
  \  Wait Until Keyword Succeeds  30s  5  Click Element  xpath=(//input[@type='radio'])[${i}]
  :FOR  ${t}  IN RANGE  1  3
  \  Вставити довільний текст відгуку виду 2,10,11,12  ${t}


Надати відгук виду 12
  Wait Until Keyword Succeeds  30s  5  Click Element  xpath=(//input[@type='radio'])[5]
  Wait Until Keyword Succeeds  30s  5  Click Element  xpath=(//div[@class="checkbox"]//input[@type='checkbox'])[1]
  :FOR  ${t}  IN RANGE  1  3
  \  Вставити довільний текст відгуку виду 2,10,11,12  ${t}


Вставити довільний текст відгуку
  ${text}  create_sentence  10
  Input Text  xpath=//*[@class="controls"]/textarea  ${text}
  Set To Dictionary  ${data}  review_text=${text}


Вставити довільний текст відгуку виду 2,10,11,12
  [Arguments]  ${id}
  ${text}  create_sentence  10
  Input Text  xpath=(//*[@class="controls"]/textarea)[${id}]  ${text}
  Set To Dictionary  ${data}  review_text=${text}


Визначити набір видів відгуків
  [Arguments]  ${forms_type}
  ${forms_type}  Run Keyword If  '${multylot}' == 'True' and ${forms_type} == ${type_9}
  ...  Set Variable  ${type_9_multylot}
  ...  ELSE  Set Variable  ${forms_type}
  ${forms_type}  Run Keyword If  '${multylot}' == 'True' and ${forms_type} == ${type_11-12}
  ...  Set Variable  ${type_11-12_multylot}
  ...  ELSE  Set Variable  ${forms_type}
  Set Global Variable  ${forms_type}


Перевірити відповідність видів відгуків
  [Arguments]  ${forms_type}
  Визначити набір видів відгуків  ${forms_type}
  Log  ${forms_type}
  dozorro.Натиснути кнопку залишити відгук
  Run Keyword If  '${multylot}' != 'True' and ${forms_type} == ${type_9}  No Operation
  ...  ELSE  dozorro.Розкрити список відгуків
  Порівняти список відгуків на сторінці з еталонним списком
  dozorro.Закрити список відгуків


Порівняти список відгуків на сторінці з еталонним списком
  ${forms}  Create List
  ${n}=  Get Element Count  xpath=(//ul[@class="ivu-select-dropdown-list"])[2]/li
  :FOR  ${i}  IN RANGE  ${n}
  \  ${i}=  Evaluate  ${i} + 1
  \  ${value}=  Run Keyword If  '${multylot}' != 'True' and ${forms_type} == ${type_9}
  \  ...  Get Text  xpath=//*[@class="ivu-modal-content"]//span[@class="ivu-select-selected-value"]
  \  ...  ELSE  Get Text  xpath=((//ul[@class="ivu-select-dropdown-list"])[2]/li)[${i}]
  \  Append To List  ${forms}  ${value}
  Log  ${forms}
  Lists Should Be Equal  ${forms}  ${forms_type}


Перевірка відображення відгуку
  [Arguments]  ${username}
  Завантажити сесію для  ${username}
  Go to  ${data.tender_url}
  dozorro.Відкрити сторінку відгуки Dozorro
  ${text}  Get Text  xpath=((//*[@data-qa="dozorro"]//div[@class="ivu-card-body"])[2]//div[contains(@style,"padding-left")])[last()]
  Should Be Equal  ${text}  ${data.review_text}


Перевірити фільтр відгуків
  [Arguments]  ${username}
  Завантажити сесію для  ${username}
  Go to  ${data.tender_url}
  dozorro.Відкрити сторінку відгуки Dozorro
  ${title}  Get Text  xpath=(//*[@class="ivu-card-body"]//h5)[1]
  Scroll Page To Element XPATH  xpath=//div[@data-qa="dozorro"]//div[@class="ivu-select-selection"]
  Click Element  xpath=//div[@data-qa="dozorro"]//div[@class="ivu-select-selection"]
  Wait Until Keyword Succeeds  30s  5  Click Element  xpath=(//ul[@class="ivu-select-dropdown-list"])[1]/li[contains(text(), '${title}')]
  ${count_review}  Get Element Count  xpath=(//*[@class="ivu-card-body"]//h5)
  ${count_title}  Get Element Count  xpath=//h5[contains(text(), '${title}')]
  Should Be Equal  ${count_review}  ${count_title}


Можливість залишити відгук
  [Arguments]  ${username}
  Завантажити сесію для  ${username}
  Go to  ${data.tender_url}
  dozorro.Відкрити сторінку відгуки Dozorro
  Run Keyword And Expect Error  *  Element Should Be Visible  ${review add}


Надати відгук для мультилоту
  Run Keyword If  '${multylot}' == 'True'  Run Keywords
  ...  Змінити значення мультилоту
  ...  AND  Надати Відгук  7



########################### КОМЕНТАР ###############################
Залишити коментар на випадковий відгук
  Go to  ${data.tender_url}
  dozorro.Відкрити сторінку відгуки Dozorro
  ${text}  create_sentence  8
  ${n}=  Get Element Count  xpath=//div/h5
  ${comment_num}  random_number  1  ${n}
  Set Global Variable  ${comment_num}
  Click Element  xpath=(//div/h5)[${comment_num}]/../..//*[contains(text(), 'Додати коментар')]
  Дочекатись закінчення загрузки сторінки
  Input Text  xpath=//*[@class="controls"]/textarea  ${text}
  Set To Dictionary  ${data}  comment_text=${text}
  Wait Until Keyword Succeeds  120  10  dozorro.Подати коментар


Перевірка відображення коментаря
  [Arguments]  ${username}
  Завантажити сесію для  ${username}
  Go to  ${data.tender_url}
  dozorro.Відкрити сторінку відгуки Dozorro
  ${text}  Get Text  xpath=((//*[@class="ivu-card-body"]//h5/ancestor::*[@class="ivu-card-body"])[${comment_num}]//div)[last()-1]
  Should Be Equal  ${text}  ${data.comment_text}


Можливість залишити коментар
  [Arguments]  ${username}
  Завантажити сесію для  ${username}
  Run Keyword And Expect Error  *  Element Should Be Visible  xpath=//div[@data-qa="dozorro"]//*[@type="button"]//*[contains(text(), 'Додати')]









