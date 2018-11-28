*** Keywords ***
Перевірити заголовок RIALTO
  ${should}  Set variable  Торги RIALTO
  ${is}  Get Text  ${torgy top/bottom tab}(1) ${torgy count tab}(5)
  Should Be Equal  ${is}  ${should}


Порахувати кількість торгів RIALTO
  ${count}  Get Element Count  ${auction active items}
  Run Keyword if  '${count}' == '0'  Fail  Як це нема торгів?!


