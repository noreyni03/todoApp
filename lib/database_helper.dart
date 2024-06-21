import 'package:localstorage/localstorage.dart';

class DatabaseHelper {
  // Singleton pattern pour s'assurer qu'il n'y a qu'une seule instance de DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  // Instance de LocalStorage pour gérer les tâches
  final LocalStorage storage = LocalStorage('tasks');

  // Constructeur interne
  DatabaseHelper._internal();

  // Méthode pour récupérer les tâches stockées
  Future<List<Map<String, dynamic>>> getTasks() async {
    await storage.ready;
    var items = storage.getItem('tasks') ?? [];
    return List<Map<String, dynamic>>.from(items);
  }

  // Méthode pour insérer une nouvelle tâche
  Future<void> insertTask(Map<String, dynamic> task) async {
    await storage.ready;
    var items = await getTasks();
    items.add(task);
    await storage.setItem('tasks', items);
  }

  // Méthode pour supprimer une tâche par index
  Future<void> deleteTask(int index) async {
    await storage.ready;
    var items = await getTasks();
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      await storage.setItem('tasks', items);
    }
  }
}
