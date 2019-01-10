*** Settings ***
Resource  ../../src/src.robot

Suite Teardown  Close All Browsers
Test Setup      Stop The Whole Test Execution If Previous Test Failed
Test Teardown   Run Keyword If Test Failed  Run Keywords
...                                         Log Location  AND
...                                         Capture Page Screenshot

#  robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None suites/questions/procurement_questions.robot
*** Test Cases ***
Підготувати користувачів
    Додати першого користувача  user1           provider1
    Додати користувача          test_viewer     viewer


Знайти випадковий тендер з потрібним статусом (Період уточнень)
    Завантажити сесію для  provider1
    search.Відкрити сторінку тестових торгів
    old_search.Розгорнути розширений пошук
    search.Відфільтрувати по статусу торгів  Період уточнень
    ${date}  smart_get_time  1  d
    search.Відфільтрувати по даті кінця прийому пропозиції від  ${date}
    old_search.Виконати пошук тендера
    old_search.Перейти по результату пошуку за номером  1
    ${tender_href}  Get Location
    Log  ${tender_href}  WARN
    Set To Dictionary  ${data}  tender_href  ${tender_href}


Поставити довільне запитання
    procurement_questions.Активувати вкладку "Запитання"
    procurement_questions.Натиснути кнопку "Поставити запитання"
    ${theme}  create_sentence  3
    procurement_questions.Заповнити тему запитання  ${theme}
    ${text}   create_sentence  8
    procurement_questions.Заповнити текст запитання  ${text}
    procurement_questions.Натиснути кнопку "Подати" запитання
    Set Global Variable  ${theme}
    Set Global Variable  ${text}


Проста перевірка публікації запитання
    :FOR  ${i}  IN  provider1  viewer
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
	\  procurement_questions.Активувати вкладку "Запитання"
	\  Page Should Contain  ${theme}
	\  Page Should Contain  ${text}