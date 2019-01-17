*** Settings ***
Resource  ../../src/src.robot

Suite Teardown  Close All Browsers
Test Setup      Stop The Whole Test Execution If Previous Test Failed
Test Teardown   Run Keyword If Test Failed  Run Keywords
...                                         Log Location  AND
...                                         Capture Page Screenshot

*** Variables ***
${multilot}                                False



#  robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None -e cancel_lot suites/cancellation/cancellation.robot
*** Test Cases ***
Підготувати користувачів
    Додати першого користувача  Bened           tender_owner
    Додати користувача          test_viewer     viewer


Створити тендер
	Завантажити сесію для  tender_owner
	Run Keyword If  '${multilot}' == 'True'
	...  test_open_trade.Створити тендер (Мультилот)  Відкриті торги  ELSE
	...  test_open_trade.Створити тендер  Відкриті торги
    test_open_trade.Отримати дані тендера та зберегти їх у файл


Скасувати обидва лоти в тндері
    [Tags]  cancel_lot
    Адаптувати словник data
    :FOR  ${i}  IN  1  2
    \  main_page.Вибрати лот за номером (webclient)  ${i}
    \  actions.Натиснути кнопку "Отмена лота"
    \  ${reason}  cancellation.Вказати причину скасування лота
    \  Set To Dictionary  ${data['cancellations'][${i}-1]}  reason  ${reason}
    \  cancellation.Вибрати "Тип скасування"  Торги відмінені
    \  ${name}  cancellation.Вкласти документ "Протокол скасування"
    \  Set To Dictionary  ${data['cancellations'][${i}-1]['documents'][0]}  title  ${name}
    \  actions.Натиснути OkButton
    \  validation.Закрити валідаційне вікно (Так/Ні)  Ви дійсно бажаєте відмінити лот  Так


Скасувати тендер
    [Tags]  cancel_tender
    actions.Натиснути кнопку "Скасування тендеру"
    ${reason}  cancellation.Вказати причину скасування тендера
    Set To Dictionary  ${data['cancellations'][0]}  reason  ${reason}
    cancellation.Вибрати "Тип скасування"  Торги відмінені
    ${name}  cancellation.Вкласти документ "Протокол скасування"
    Set To Dictionary  ${data['cancellations'][0]['documents'][0]}  title  ${name}
    actions.Натиснути OkButton
    validation.Закрити валідаційне вікно (Так/Ні)  Ви дійсно бажаєте відмінити тендер  Так


Перевірити скасування тендеру та наявність протоколу скасування
    Go to  ${data['tender_href']}
    procurement_tender_detail.Дочекатися статусу тендера  Закупівля відмінена
    :FOR  ${i}  IN  tender_owner  viewer
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
    \  procurement_tender_detail.Відкрити вікно "Причина відміни" детальніше
    \  ${reason block}  Get Text  //*[@data-qa="reason"]
    \  Run Keyword If  '${multilot}' != 'True'  Should Contain  ${reason block}  ${data['title']}
    \  Should Contain  ${reason block}  ${data['cancellations'][0]['reason']}
    \  Should Contain  ${reason block}  ${data['cancellations'][0]['documents'][0]['title']}
    \  Run Keyword If  '${multilot}' == 'True'  Run Keywords
    \  ...  Should Contain  ${reason block}  ${data['cancellations'][1]['reason']}  AND
    \  ...  Should Contain  ${reason block}  ${data['cancellations'][1]['documents'][0]['title']}



*** Keywords ***
Адаптувати словник data
    ${new dict}  Evaluate  ${data['cancellations'][0]}.copy()
    Append to list         ${data['cancellations']}  ${new dict}