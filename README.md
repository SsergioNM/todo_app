# ToDo App

## Overview
This is a simple **ToDo App** built with Flutter that allows users to create and manage tasks.

## Features
- **Add tasks**: Users can create tasks by providing a title, description, and due date.
- **Mark tasks as completed**: Once a task is finished, users can mark it as completed, moving it to the completed list.
- **Move tasks back to pending**: Users can move tasks from the completed list back to the pending list.
- **Responsive design**: The app uses a clean and simple UI with blue-themed colors and buttons, making it user-friendly and easy to navigate.

## How to Run
1. **Clone the repository**:

git clone https://github.com/SsergioNM/todo_app.git
cd todo_app

2. **Install dependencies**: Make sure you have Flutter installed on your system. Then run the following command in the root of the project to install the dependencies: flutter pub get

3. **Run the app**: You can run the app on an emulator or a physical device using: flutter run
  
**APP STRUCTURE**
The app follows a simple structure to separate concerns and keep the code organized:

**main.dart**: Contains the core logic and structure of the app.

**Task model**: Represents the data structure of a task, including title, description, due date, and completion status.

**PendingTasksScreen**: Displays the list of pending tasks and allows users to mark tasks as completed.

**CompletedTasksScreen**: Displays the list of completed tasks and allows users to move them back to the pending list.

**TaskForm**: Provides the form for users to input task details (title, description, due date).

**GIT WORKFLOW**
This project follows good Git practices with meaningful commits:

**1) Initial project setup**: Setting up the Flutter project structure.
**2) Added task model**: Implemented the model for task management.
**3) UI enhancements**: Improved the user interface with colors, fonts, and button styles.
**4) Task completion logic**: Added functionality to mark tasks as completed and move them back to pending.

**KNOWN ISSUES**
When a task is marked as completed, and later moved back to pending from the Completed Tasks page, it works, but the task does not disappear immediately from the Completed Tasks list. It may cause confusion, as it seems like nothing happens, but once you return to the Pending Tasks page, the task is shown there as expected.

**FUTURE IMPROVEMENTS**
1) Add more task filters (e.g., sort by due date).
2) Implement task notifications as due dates approach.

**AUTHOR**
Sergio Nogales Montero
