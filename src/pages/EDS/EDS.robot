*** Settings ***
Resource  keywords.robot


*** Keywords ***
Підписати ЕЦП
	${iframe status}  Натиснути підписати ЕЦП
	Run Keyword If  ${iframe status}
	...  Підписати ЕЦП iframe
	...  ELSE
	...  Підписати ЕЦП no iframe

