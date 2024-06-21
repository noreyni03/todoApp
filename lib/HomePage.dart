import 'package:flutter/material.dart';
import 'task_list_page.dart';

// Page d'accueil
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projet flutter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Titre de la section des membres du groupe
            Text(
              'Membres du groupe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Liste des membres du groupe
            Text(
              'Ousmane Mbaye\nElhadj Samba Ba\nOusmane Dramé\nAicha Dramé\nPape Momar Dieng',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            // Bouton pour naviguer vers la page de la liste des tâches
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskListPage()),
                );
              },
              child: Text('Commencer'),
            ),
          ],
        ),
      ),
    );
  }
}
