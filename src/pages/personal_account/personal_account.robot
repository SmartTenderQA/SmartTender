*** Settings ***
Resource    	keywords.robot


*** Variables ***


*** Keywords ***
Відкрити сторінку за назвою
    [Documentation]  ${item name} == analytics|calendar|new_tender_page...
    [Arguments]  ${item name}
    Розкрити меню в особистому кабінеті за необхідністю
    Розкрити під-меню в особистому кабінеті за необхідністю  ${item name}
    Натиснути на елемент в меню  ${item name}
    Дочекатись закінчення загрузки сторінки
    Run Keyword  ${item name}.Перевірити сторінку