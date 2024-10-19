import 'package:flutter/material.dart';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[200],
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Título blanco para "Pending Tasks" y "Completed Tasks"
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Texto de las tareas completadas en negro
          ),
        ),
      ),
      home: PendingTasksScreen(),
    );
  }
}

class Task {
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });
}

class PendingTasksScreen extends StatefulWidget {
  @override
  _PendingTasksScreenState createState() => _PendingTasksScreenState();
}

class _PendingTasksScreenState extends State<PendingTasksScreen> {
  List<Task> pendingTasks = [];
  List<Task> completedTasks = [];

  // Open Task Creation Form
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

  // Complete Task
  void _completeTask(int index) {
    setState(() {
      Task task = pendingTasks.removeAt(index);
      task.isCompleted = true;
      completedTasks.add(task);
    });
  }

  // Uncomplete a task - remove immediately from completed tasks
  void _uncompleteTask(int index) {
    setState(() {
      Task task = completedTasks.removeAt(index); // Eliminar inmediatamente de la lista de completadas
      task.isCompleted = false;
      pendingTasks.add(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Tasks', style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CompletedTasksScreen(
                  completedTasks: completedTasks,
                  uncompleteTask: _uncompleteTask,
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
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(task.title, style: Theme.of(context).textTheme.bodyLarge),
              subtitle: Text('${task.description}\nDue: ${task.dueDate.toLocal().toString().split(' ')[0]}'),
              isThreeLine: true, // Esto permite mostrar más de dos líneas en el subtítulo
              trailing: IconButton(
                icon: Icon(Icons.check_circle_outline),
                onPressed: () => _completeTask(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskForm(context),
        backgroundColor: Colors.blue[800], // Botón + en azul oscuro
        child: Icon(Icons.add, color: Colors.white), // Icono blanco
      ),
    );
  }
}

class CompletedTasksScreen extends StatelessWidget {
  final List<Task> completedTasks;
  final Function(int) uncompleteTask;

  CompletedTasksScreen({required this.completedTasks, required this.uncompleteTask});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks', style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Colors.blue[800],
      ),
      body: ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(task.title, style: Theme.of(context).textTheme.bodyLarge),
              subtitle: Text('Completed\n${task.description}', style: TextStyle(color: Colors.black)),
              isThreeLine: true, // Esto permite mostrar más de dos líneas en el subtítulo
              trailing: IconButton(
                icon: Icon(Icons.undo, color: Colors.black),
                onPressed: () => uncompleteTask(index), // Elimina la tarea completada inmediatamente
              ),
            ),
          );
        },
      ),
    );
  }
}

class TaskForm extends StatefulWidget {
  final Function(Task) onSubmit;

  TaskForm({required this.onSubmit});

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDueDate = DateTime.now();

  // Submit new task
  void _submitTask() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    if (title.isEmpty || description.isEmpty) return;

    final newTask = Task(
      title: title,
      description: description,
      dueDate: _selectedDueDate,
    );

    widget.onSubmit(newTask);
    Navigator.of(context).pop();
  }

  // Pick Date
  void _pickDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDueDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Task Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Task Description'),
          ),
          Row(
            children: [
              Expanded(
                child: Text('Due Date: ${_selectedDueDate.toLocal().toString().split(' ')[0]}'),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: _pickDueDate,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _submitTask,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[300], // Cambiado a azul claro
            ),
            child: Text('Add Task', style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
    );
  }
}

