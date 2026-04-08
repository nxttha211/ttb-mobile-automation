*** Settings ***
Documentation    Minimal Todo - Test Cases
Resource         ../resources/common.robot
Resource         ../resources/main_page.robot
Resource         ../resources/add_todo_page.robot
Test Setup       Open Test Application
Test Teardown    Close Test Application

*** Test Cases ***
Add New Todo Item
    [Tags]    No1
    [Documentation]    Verify add a new todo item
    Tap Add Todo Button
    Create New Todo    Test Create Todo Item
    Todo Item Should Be Visible    Test Create Todo Item

Add Todo With Reminder
    [Tags]    No2
    [Documentation]    Verify add a todo with reminder, date and time
    Tap Add Todo Button
    Input Todo Title    Test Create Todo Item at 3pm
    Enable Reminder
    Select Date    10    April    2026
    Select Time    3    00    PM
    Tap Save Button
    Todo Item Should Be Visible    Test Create Todo Item at 3pm

Should Not Allow Past Date Reminder
    [Tags]    No3
    [Documentation]    Verify selecting a past date resets date back to today
    Tap Add Todo Button
    Input Todo Title    Past date task
    Enable Reminder
    Select Past Date In Current Month
    Date Field Should Show Today

Delete Todo By Swipe
    [Tags]    No4
    [Documentation]    Verify user can delete a todo by swiping
    Tap Add Todo Button
    Create New Todo    Task to delete
    Todo Item Should Be Visible    Task to delete
    Swipe To Delete Todo    Task to delete
    Todo Item Should Not Be Visible    Task to delete

Edit Existing Todo
    [Tags]    No5
    [Documentation]    Verify user can edit an existing todo
    Tap Add Todo Button
    Create New Todo    Old task name
    Todo Item Should Be Visible    Old task name
    Tap Todo Item    Old task name
    Input Todo Title    Updated task name
    Tap Save Button
    Todo Item Should Be Visible    Updated task name

Add Todo Without Title
    [Tags]    No6
    [Documentation]    Verify user can save todo without title and continue adding new todo
    Tap Add Todo Button
    Tap Save Button
    Tap Add Todo Button
    Wait Until Element Is Visible    ${NAME_TITLE}    5

Add Multiple Todos
    [Tags]    No7
    [Documentation]    Verify multiple todos are displayed in the list
    Tap Add Todo Button
    Create New Todo    First task
    Tap Add Todo Button
    Create New Todo    Second task
    Tap Add Todo Button
    Create New Todo    Third task
    Todo Item Should Be Visible    First task
    Todo Item Should Be Visible    Second task
    Todo Item Should Be Visible    Third task

Toggle Reminder On Off
    [Tags]    No8
    [Documentation]    Verify reminder section hides when toggle off
    Tap Add Todo Button
    Input Todo Title    Toggle reminder test
    Enable Reminder
    Disable Reminder
    Reminder Section Should Not Be Visible

Navigate Back Without Save
    [Tags]    No9
    [Documentation]    Verify navigating back saves the todo automatically
    Tap Add Todo Button
    Input Todo Title    Auto saved task
    Tap Navigate Back
    Todo Item Should Be Visible    Auto saved task

Empty View Shows When No Todos Exist
    [Tags]    No10
    [Documentation]    Verify empty view with message is shown on fresh app with no todos
    [Setup]    Open Clean Application
    Wait Until Page Contains    You don't have any todos    ${TIMEOUT}

Add Todo With Long Title
    [Tags]    No11
    [Documentation]    Verify todo with long title is created and displayed correctly
    Tap Add Todo Button
    Create New Todo    This is a very long todo title to verify the app can handle lengthy text input properly
    Todo Item Should Be Visible    This is a very long todo title to verify the app can handle lengthy text input properly

Verify Reminder Date Time Display
    [Tags]    No12
    [Documentation]    Verify reminder text is displayed after selecting date and time
    Tap Add Todo Button
    Input Todo Title    Check reminder display
    Enable Reminder
    Select Date    15    April    2026
    Select Time    5    00    PM
    Reminder Text Should Contain    15 Apr
    Reminder Text Should Contain    5:00 PM
