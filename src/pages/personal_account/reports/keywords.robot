*** Variables ***
${switcher}             css=.ivu-switch


*** Keywords ***
Отримати статус перемикача Тільки обрані звіти
  ${status}  Get Element Attribute  ${switcher} [value]  value
  [Return]  ${status}