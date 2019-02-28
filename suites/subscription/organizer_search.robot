*** Settings ***
Resource        ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Full Screenshot

*** Variables ***



*** Test Cases ***
Провести пошук по реквізитам та оцінити видачу
    subscription.Вибрати вкладку для підписки та перевірити наявність всіх елементів в блоці категорії  Публічні закупівлі
    Wait Until Keyword Succeeds  20  1  Виконати пошук за реквізитами організатора та перевірити видачу  ТОВ


*** Keywords ***
Precondition
    ${user}  Set Variable If
    ...  '${where}' == 'test'  user1
    ...  'prod' in '${where}'  prod_provider1
    Open Browser In Grid  ${user}
    Авторизуватися  ${user}
    start_page.Навести мишку на іконку з заголовку  Меню_користувача
    menu-user.Натиснути  Особистий кабінет
    personal_account.Відкрити сторінку за назвою  subscription


Виконати пошук за реквізитами організатора та перевірити видачу
    [Arguments]  ${search query}
    subscription.Виконати пошук за реквізитами організатора  ${search query}
    subscription.Перевірити результати пошука за реквізитами організатора  ${search query}
