import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'add_task_page.dart';
import 'task_detail_page.dart';

// Page de la liste des tâches
class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> _filteredTasks = [];
  Set<String> _selectedFilters = {'Todo'};

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Chargement des tâches depuis la base de données
  _loadTasks() async {
    final tasks = await DatabaseHelper().getTasks();
    setState(() {
      _tasks = tasks;
      _applyFilters();
    });
  }

  // Application des filtres sur les tâches
  void _applyFilters() {
    setState(() {
      _filteredTasks = _tasks
          .where((task) => _selectedFilters.contains(task['status'] ?? 'Todo'))
          .toList();
    });
  }

  // Méthode pour obtenir la couleur en fonction du statut
  Color _getColorForStatus(String status) {
    switch (status) {
      case 'Todo':
        return Colors.grey;
      case 'In progress':
        return Colors.blue;
      case 'Done':
        return Colors.green;
      case 'Bug':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Méthode pour obtenir la couleur de la barre de progression en fonction du statut
  Color _getProgressBarColor(String status) {
    switch (status) {
      case 'Todo':
        return Colors.white;
      case 'In progress':
        return Colors.lightBlueAccent;
      case 'Done':
        return Colors.lightGreenAccent;
      case 'Bug':
        return Colors.orangeAccent;
      default:
        return Colors.white;
    }
  }

  // Affichage de la boîte de dialogue de filtre
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Filter par'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: ['Todo', 'In progress', 'Done', 'Bug'].map((String status) {
                  return CheckboxListTile(
                    title: Text(status),
                    value: _selectedFilters.contains(status),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedFilters.add(status);
                        } else {
                          _selectedFilters.remove(status);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _applyFilters();
                  },
                  child: Text('Appliquer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Suppression d'une tâche
  _deleteTask(int index) async {
    setState(() {
      _tasks.removeAt(index);
      _applyFilters();
    });
    await DatabaseHelper().deleteTask(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SimpleBlog'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _filteredTasks.isEmpty
          ? Center(child: Text('No tasks found.'))
          : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                final task = _filteredTasks[index];
                final taskStatus = task['status'] ?? 'Todo'; // Valeur par défaut si null
                final taskProgressColor = _getProgressBarColor(taskStatus);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 4,
                    color: _getColorForStatus(taskStatus),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        task['title'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.0),
                          // Barre de progression pour indiquer l'état de la tâche
                          LinearProgressIndicator(
                            value: _getProgressValue(taskStatus),
                            backgroundColor: Colors.black12,
                            valueColor: AlwaysStoppedAnimation<Color>(taskProgressColor),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTask(index),
                      ),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailPage(task: task),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            _tasks[index] = result;
                          });
                          await DatabaseHelper().insertTask(result);
                          _applyFilters();
                        }
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
          if (result == true) {
            _loadTasks();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Méthode pour obtenir la valeur de la barre de progression en fonction du statut
  double _getProgressValue(String status) {
    switch (status) {
      case 'Todo':
        return 0.2;
      case 'In progress':
        return 0.5;
      case 'Done':
        return 1.0;
      case 'Bug':
        return 0.0;
      default:
        return 0.0;
    }
  }
}
