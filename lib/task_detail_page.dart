import 'package:flutter/material.dart';

// Page de détail de la tâche
class TaskDetailPage extends StatefulWidget {
  final Map<String, dynamic> task;

  TaskDetailPage({required this.task});

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  String? _status;

  @override
  void initState() {
    super.initState();
    // Initialisation des variables avec les données de la tâche
    _title = widget.task['title'];
    _description = widget.task['description'];
    _status = widget.task['status'] ?? 'Todo'; // Valeur par défaut si null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Detail'),
        actions: [
          // Widget Dropdown pour changer le statut de la tâche
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  'Status',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: _status,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      _status = newValue;
                    });
                  },
                  items: ['Todo', 'In progress', 'Done', 'Bug']
                      .map<DropdownMenuItem<String>>((String choice) {
                    return DropdownMenuItem<String>(
                      value: choice,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: _getColorForStatus(choice),
                            radius: 5,
                          ),
                          SizedBox(width: 10),
                          Text(choice),
                        ],
                      ),
                    );
                  }).toList(),
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  underline: Container(),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Champ de saisie pour le titre de la tâche
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value;
                },
              ),
              SizedBox(height: 20),
              // Champ de saisie pour la description de la tâche
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: 'Contenu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le contenu';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value;
                },
              ),
              SizedBox(height: 20),
              // Bouton pour sauvegarder les modifications
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context, {
                      'title': _title,
                      'description': _description,
                      'status': _status,
                    });
                  }
                },
                child: Text('Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
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
}
