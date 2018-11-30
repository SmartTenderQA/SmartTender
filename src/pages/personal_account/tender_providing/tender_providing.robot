*** Variables ***


*** Keywords ***
Перевірити сторінку
  Element Should Contain  //h1  Заявки на отримання тендерного забезпечення
  Page Should Contain Element  //img[@src="/Images/Guarantee/guarantee-button.png"]