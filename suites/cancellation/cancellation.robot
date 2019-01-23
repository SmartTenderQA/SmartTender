*** Settings ***
Resource  ../../src/src.robot

Suite Setup     Precondition
Suite Teardown  Close All Browsers
Test Setup      Stop The Whole Test Execution If Previous Test Failed
Test Teardown   Run Keyword If Test Failed  Run Keywords
...                                         Log Location  AND
...                                         Capture Page Screenshot

*** Variables ***
${multilot}                                False



#  robot --consolecolors on -L TRACE:INFO -d test_output -e cancel_lot -v multilot:False suites/cancellation/cancellation.robot
*** Test Cases ***
Створити тендер
	Завантажити сесію для  ${tender_owner}
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


Дочекатися статусу тендера "Закупівля відмінена"
    Go to  ${data['tender_href']}
    procurement_tender_detail.Дочекатися статусу тендера  Закупівля відмінена


Перевірити збереження даних в ЦБД
    Отримати дані з cdb та зберегти їх у файл
    procurement_tender_detail.Відкрити вікно "Причина відміни" детальніше
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['cancellations'][0]['reason']
    procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['cancellations'][0]['documents'][0]['title']
    Run Keyword If  '${multilot}' == 'True'  Run Keywords
    ...  procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['cancellations'][1]['reason']  AND
    ...  procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['cancellations'][1]['documents'][0]['title']


Перевірити скасування на сторінці користувачами
    :FOR  ${i}  IN  ${tender_owner}  ${viewer}
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
    \  procurement_tender_detail.Відкрити вікно "Причина відміни" детальніше
    \  procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['cancellations'][0]['reason']
    \  procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['cancellations'][0]['documents'][0]['title']
    \  Run Keyword If  '${multilot}' == 'True'  Run Keywords
    \  ...  procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['cancellations'][1]['reason']  AND
    \  ...  procurement_tender_detail.Порівняти введені дані з даними в ЦБД  ['cancellations'][1]['documents'][0]['title']



*** Keywords ***
Precondition
	Set Global Variable         ${tender_owner}  Bened
    Set Global Variable         ${viewer}        test_viewer
    Додати першого користувача  ${tender_owner}
    Додати користувача          ${viewer}


Адаптувати словник data
    ${new dict}  Evaluate  ${data['cancellations'][0]}.copy()
    Append to list         ${data['cancellations']}  ${new dict}


Отримати дані з cdb та зберегти їх у файл
    [Tags]  create_tender
    ${id}  procurement_tender_detail.Отритами дані зі сторінки  ['id']
    ${cdb}  Отримати дані тендеру з cdb по id  ${id}
    Set Global Variable  ${cdb}
    actions.Зберегти словник у файл  ${cdb}  cdb
