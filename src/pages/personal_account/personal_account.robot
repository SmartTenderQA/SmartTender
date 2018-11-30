*** Settings ***
Resource    	keywords.robot


*** Variables ***


*** Keywords ***
Відкрити сторінку за назвою
    [Documentation]  ${item} == analytics|calendar|new_tender_page...
    [Arguments]  ${item}
    Розкрити меню в особистому кабінеті за необхідністю
    Розкрити під-меню в особистому кабінеті за необхідністю  ${item}
    Click Element  ${${item}}
    Дочекатись закінчення загрузки сторінки
    Run Keyword  ${item}.Перевірити сторінку