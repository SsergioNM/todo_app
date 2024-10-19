import 'package:flutter/material.dart';

// Main entry point of the app
void main() {
  runApp(ToDoApp());
}

// Root of the ToDoApp, a StatelessWidget that defines the overall structure and theme:
class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App', 
      theme: ThemeData(
        primarySwatch: Colors.blue, // Blue theme for the app with light blue background, later with white color for the screen tittles and black for task tittles
        scaffoldBackgroundColor: Colors.blue[200], 
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, 
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, 
          ),
        ),
      ),
      home: PendingTasksScreen(), // Starting screen: PendingTasksScreen
    );
  }
}

// Task model that represents each task with title, description, due date, and completion status
class Task {
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false, // if not completed
  });
}

// Screen to show the list of pending tasks with the list to store the pending & completed tasks
class PendingTasksScreen extends StatefulWidget {
  @override
  _PendingTasksScreenState createState() => _PendingTasksScreenState();
}

class _PendingTasksScreenState extends State<PendingTasksScreen> {
  List<Task> pendingTasks = [];
  List<Task> completedTasks = [];

  // Function to open the task creation form, and latter and Add for the new task to the pending tasks list
  void _openTaskForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TaskForm(onSubmit: (Task task) {
          setState(() {
            pendingTasks.add(task); 
          });
        });
      },
    );
  }

  // Function to mark a task as completed & removing them from pending tasks
  void _completeTask(int index) {
    setState(() {
      Task task = pendingTasks.removeAt(index);
      task.isCompleted = true; 
      completedTasks.add(task); 
    });
  }

  // Function to move a task back to pending tasks from completed tasks
  void _uncompleteTask(int index) {
    setState(() {
      Task task = completedTasks.removeAt(index); 
      task.isCompleted = false; 
      pendingTasks.add(task); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Tasks', style: Theme.of(context).textTheme.headlineSmall), // Title of the screen
        backgroundColor: Colors.blue[800], // Darker blue for the app bar
        actions: [
          IconButton(
            icon: Icon(Icons.check), // Button to navigate to Completed Tasks screen
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CompletedTasksScreen(
                  completedTasks: completedTasks, // Pass the completed tasks
                  uncompleteTask: _uncompleteTask, // Pass the function to undo task completion
                ),
              ));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: pendingTasks.length, 
        itemBuilder: (context, index) {
          final task = pendingTasks[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners for the card
            ),
            child: ListTile(
              title: Text(task.title, style: Theme.of(context).textTheme.bodyLarge), // Display task title & task description with due date
              subtitle: Text('${task.description}\nDue: ${task.dueDate.toLocal().toString().split(' ')[0]}'), 
              isThreeLine: true, 
              trailing: IconButton(
                icon: Icon(Icons.check_circle_outline), 
                onPressed: () => _completeTask(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskForm(context), // Open form to add a new task
        backgroundColor: Colors.blue[800], // Darker blue for the button
        child: Icon(Icons.add, color: Colors.white), // White icon for the button
      ),
    );
  }
}

// Screen to show the list of completed tasks
class CompletedTasksScreen extends StatelessWidget {
  final List<Task> completedTasks;
  final Function(int) uncompleteTask; // Callback function to move task back to pending

  CompletedTasksScreen({required this.completedTasks, required this.uncompleteTask});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks', style: Theme.of(context).textTheme.headlineSmall), // Title of the screen
        backgroundColor: Colors.blue[800], // Darker blue for the app bar
      ),
      body: ListView.builder(
        itemCount: completedTasks.length, // Number of completed tasks
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners for the card
            ),
            child: ListTile(
              title: Text(task.title, style: Theme.of(context).textTheme.bodyLarge), // Display task title 
              subtitle: Text('Completed\n${task.description}', style: TextStyle(color: Colors.black)), 
              isThreeLine: true, 
              trailing: IconButton(
                icon: Icon(Icons.undo, color: Colors.black), // Undo icon to move task back to pending
                onPressed: () => uncompleteTask(index), // Call the function to move task back to pending
              ),
            ),
          );
        },
      ),
    );
  }
}

// Form widget to create a new task
class TaskForm extends StatefulWidget {
  final Function(Task) onSubmit; // Callback to submit the task

  TaskForm({required this.onSubmit});

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _titleController = TextEditingController(); // Controller for task title input
  final _descriptionController = TextEditingController(); // Controller for task description input
  DateTime _selectedDueDate = DateTime.now(); // Default due date is the current date

  // Function to submit a new task
  void _submitTask() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    if (title.isEmpty || description.isEmpty) return; // Ensure title and description are not empty

    final newTask = Task(
      title: title,
      description: description,
      dueDate: _selectedDueDate,
    );

    widget.onSubmit(newTask); // Submit the task using the callback & close it after submission
    Navigator.of(context).pop(); 
  }

  // Function to pick a due date
  void _pickDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default date is today
      firstDate: DateTime.now(), // Minimum date is today
      lastDate: DateTime(2100), // Maximum date far in the future
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDueDate = pickedDate; // Update selected due date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0), // Padding around the form
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch the form to fit the width
        children: [
          TextField(
            controller: _titleController, // Input field for task title
            decoration: InputDecoration(labelText: 'Task Title'), 
          ),
          TextField(
            controller: _descriptionController, // Input field for task description
            decoration: InputDecoration(labelText: 'Task Description'), 
          ),
          Row(
            children: [
              Expanded(
                child: Text('Due Date: ${_selectedDueDate.toLocal().toString().split(' ')[0]}'), // Display selected due date
              ),
              IconButton(
                icon: Icon(Icons.calendar_today), // Calendar icon to pick a date
                onPressed: _pickDueDate,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _submitTask, // Submit the task
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[300], // Light blue button
            ),
            child: Text('Add Task', style: TextStyle(color: Colors.purple)), // Button text in purple
          ),
        ],
      ),
    );
  }
}
