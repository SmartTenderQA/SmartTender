*** Settings ***
Resource        keywords.robot


*** Variables ***
${participant}            //*[@data-placeid="CRITERIA"]//td[@style="padding-left: 19px"]
${winners}                //*[@data-placeid="BIDS"]//td[contains(@style,"padding-left: 19px")]


*** Keywords ***
Провести прекваліфікацію учасників
    ${count}  Дочекатись появи учасників прекваліфікації та отримати їх кількість
    :FOR  ${i}  IN RANGE  1  ${count}+1
    \  Надати рішення про допуск до аукціону учасника  ${i}
    Закрити валідаційне вікно (Так/Ні)  Розгляд учасників закінчено? Перевести закупівлю на наступну стадію?  Так
    ${status}  Run Keyword And Return Status  Закрити валідаційне вікно (Так/Ні)  протокол  Так
    Run Keyword If  '${status}' == 'False'
    ...  Підтвердити організатором формування протоколу розгляду пропозицій


Дочекатись появи учасників прекваліфікації та отримати їх кількість
    Натиснути кнопку Перечитать (Shift+F4)
    ${count}  Get Element Count  ${participant}
    Run Keyword If  '${count}' == '0'  Run Keywords
    ...  Sleep  30  AND
    ...  Дочекатись появи учасників прекваліфікації та отримати їх кількість
    [Return]  ${count}


Визнати всіх учасників переможцями
    ${count}  Get Element Count  ${winners}
    :FOR  ${i}  IN RANGE  1  ${count}+1
    \  Визначити учасника переможцем  ${i}
    Закрити валідаційне вікно (Так/Ні)  Розгляд учасників закінчено?  Так


Заповнити ціни за одиницю номенклатури для всії переможців
    ${count}  Get Element Count  ${winners}
    :FOR  ${i}  IN RANGE  1  ${count}+1
    \   Вказати ціну за одиницю номенклатури для переможця  ${i}



