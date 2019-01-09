*** Settings ***
Resource  ../../src/src.robot

Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot


#  robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None -e get_tender suites/other/cancel_tender_check_doc.robot
*** Test Cases ***
Підготувати користувачів
    Додати першого користувача  Bened           tender_owner
    Додати користувача          test_viewer     viewer


Створити тендер
	[Tags]  create_tender
	Завантажити сесію для  tender_owner
	test_open_trade.Створити тендер  Відкриті торги
    test_open_trade.Отримати дані тендера та зберегти їх у файл


Скасувати тендер
    webclient_elements.Натиснути кнопку "Скасування тендеру"
    ${reason}  Вказати причину скасування тендера
    Set To Dictionary  ${data['cancellations'][0]}  reason  ${reason}
    Вибрати "Тип скасування"
    ${name}  Вкласти документ "Протокол скасування"
    Set To Dictionary  ${data['cancellations'][0]['documents'][0]}  title  ${name}
    webclient_elements.Натиснути OkButton
    validation.Закрити валідаційне вікно (Так/Ні)  Ви дійсно бажаєте відмінити тендер  Так


Перевірити скасування тендеру та наявність протоколу скасування
    Go to  ${data['tender_href']}
    procurement_tender_detail.Дочекатися статусу тендера  Закупівля відмінена
    :FOR  ${i}  IN  tender_owner  viewer
	\  Завантажити сесію для  ${i}
	\  Go To  ${data['tender_href']}
    \  procurement_tender_detail.Відкрити вікно "Причина відміни" детальніше
    \  ${reason block}  Get Text  //*[@data-qa="reason"]
    \  Should Contain  ${reason block}  ${data['title']}
    \  Should Contain  ${reason block}  ${data['cancellations'][0]['reason']}
    \  Should Contain  ${reason block}  ${data['cancellations'][0]['documents'][0]['title']}







*** Keywords ***
Вказати причину скасування тендера
    ${input}  Set Variable  //*[@data-name="reason"]//textarea
    ${text}  create_sentence  5
    Element Text Should Be
    ...  //span[contains(@class, "headerText") and contains(@id, "ModalMode")]
    ...  Скасування тендеру
    Input Text  ${input}  ${text}
    [Return]  ${text}


Вкласти документ "Протокол скасування"
    Click Element  //div[@title="Додати"]
    Дочекатись закінчення загрузки сторінки(webclient)
    Wait Until Page Contains Element  xpath=//*[@type='file'][1]
    ${doc}=  create_fake_doc
    ${path}  Set Variable  ${doc[0]}
    ${name}  Set Variable  ${doc[1]}
    Choose File  xpath=//*[@type='file'][1]  ${path}
    Click Element  xpath=(//span[.='ОК'])[1]
    Дочекатись закінчення загрузки сторінки(webclient)
    Page Should Contain  ${name}
    [Return]  ${name}


Вибрати "Тип скасування"
    Click Element  //*[text()="Тип скасування"]/following-sibling::table
    Wait Until Element Is Visible  //*[text()="Торги відмінені"]
    Click Element  //*[text()="Торги відмінені"]