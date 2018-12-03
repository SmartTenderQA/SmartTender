*** Keywords ***
Створити словник
    [Arguments]  ${name}
    ${dict}  Create Dictionary
    Set Global Variable  ${${name}}  ${dict}


Зберегти словник у файл
    [Arguments]  ${dict}  ${filename}
	${json}  conver dict to json  ${dict}
	Create File  ${OUTPUTDIR}/artifact_${filename}.json  ${json}