import 'package:flutter/material.dart';
import 'database_helper.dart';

// Définition de la page AddTaskPage comme StatefulWidget
class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

// État de AddTaskPage
class _AddTaskPageState extends State<AddTaskPage> {
  // Clé globale pour identifier le formulaire et valider les champs de saisie
  final _formKey = GlobalKey<FormState>();

  // Variables pour stocker les valeurs du titre, de la description et du statut
  String? _title;
  String? _description;
  String _status = 'Todo'; // Valeur par défaut pour le statut

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un article'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Attribution de la clé du formulaire
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Champ de saisie pour le titre de la tâche
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre'; // Message d'erreur si le champ est vide
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value; // Sauvegarde de la valeur saisie dans la variable _title
                },
              ),
              SizedBox(height: 20),
              // Champ de saisie pour la description de la tâche
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contenu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                maxLines: 8, // Nombre maximum de lignes affichées dans le champ de saisie
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le contenu'; // Message d'erreur si le champ est vide
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value; // Sauvegarde de la valeur saisie dans la variable _description
                },
              ),
              SizedBox(height: 20),
              // Menu déroulant pour sélectionner le statut de la tâche
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                items: ['Todo', 'In progress', 'Done', 'Bug']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(), // Options du menu déroulant
                onChanged: (value) {
                  setState(() {
                    _status = value!; // Mise à jour de la valeur sélectionnée
                  });
                },
              ),
              SizedBox(height: 20),
              // Bouton pour soumettre le formulaire
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Insertion de la nouvelle tâche dans la base de données
                    DatabaseHelper().insertTask({
                      'title': _title,
                      'description': _description,
                      'status': _status,
                    });
                    Navigator.pop(context, true); // Retour à la page précédente
                  }
                },
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
