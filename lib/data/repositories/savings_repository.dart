import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/savings_goal_model.dart';

class SavingsRepository {
  static const String _boxName = 'savings_goals';

  Box<SavingsGoal> get _box => Hive.box<SavingsGoal>(_boxName);

  List<SavingsGoal> getAll() {
    final list = _box.values.toList();
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  List<SavingsGoal> getActive() {
    return getAll().where((g) => !g.isCompleted).toList();
  }

  List<SavingsGoal> getCompleted() {
    return getAll().where((g) => g.isCompleted).toList();
  }

  SavingsGoal? getById(String id) {
    return _box.get(id);
  }

  Future<void> add(SavingsGoal goal) async {
    await _box.put(goal.id, goal);
  }

  Future<void> update(SavingsGoal goal) async {
    await _box.put(goal.id, goal);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> addContribution(String id, double amount) async {
    final goal = _box.get(id);
    if (goal != null) {
      goal.currentAmount += amount;
      if (goal.currentAmount >= goal.targetAmount) {
        goal.isCompleted = true;
      }
      await goal.save();
    }
  }

  Future<void> deleteAll() async {
    await _box.clear();
  }

  ValueListenable<Box<SavingsGoal>> get listenable => _box.listenable();
}