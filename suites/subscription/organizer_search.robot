*** Settings ***
Resource        ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Page Screenshot

*** Variables ***



*** Test Cases ***
Провести пошук по реквізитам та оцінити видачу
    subscription.Вибрати вкладку для підписки та перевірити наявність всіх елементів в блоці категорії  Публічні закупівлі
    subscription.Виконати пошук за реквізитами організатора та перевірити видачу  ТОВ


*** Keywords ***
Precondition
    Open Browser In Grid  ${user}
    Авторизуватися  ${user}
    start_page.Навести мишку на іконку з заголовку  Меню_користувача
    menu-user.Натиснути  Особистий кабінет
    personal_account.Відкрити сторінку за назвою  subscription