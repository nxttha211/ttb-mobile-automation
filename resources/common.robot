*** Settings ***
Documentation    Common keywords shared across tests
Library          AppiumLibrary
Library          Process
Resource         ../configs/android_config.robot

*** Keywords ***
Open Test Application
    Open Application    ${APPIUM_SERVER}
    ...    platformName=${PLATFORM_NAME}
    ...    automationName=${AUTOMATION_NAME}
    ...    deviceName=${DEVICE_NAME}
    ...    appPackage=${APP_PACKAGE}
    ...    appActivity=${APP_ACTIVITY}
    Set Appium Timeout    ${TIMEOUT}
    Dismiss Compatibility Dialog

Open Clean Application
    Run Keyword And Ignore Error    Close Application
    Run Process    adb    shell    pm clear ${APP_PACKAGE}
    Open Test Application

Close Test Application
    Run Keyword And Ignore Error    Close Application

Dismiss Compatibility Dialog
    ${visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    id=android:id/button1    5
    IF    ${visible}
        Click Element    id=android:id/button1
    END
