import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recurring_transaction_model.dart';

class RecurringRepository {
  static const String _boxName = 'recurring_transactions';

  Box<RecurringTransaction> get _box => Hive.box<RecurringTransaction>(_boxName);

  List<RecurringTransaction> getAll() {
    final list = _box.values.toList();
    list.sort((a, b) => a.startDate.compareTo(b.startDate));
    return list;
  }

  List<RecurringTransaction> getActive() {
    return getAll().where((r) => r.isActive).toList();
  }

  RecurringTransaction? getById(String id) {
    return _box.get(id);
  }

  Future<void> add(RecurringTransaction recurring) async {
    await _box.put(recurring.id, recurring);
  }

  Future<void> update(RecurringTransaction recurring) async {
    await _box.put(recurring.id, recurring);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> toggleActive(String id) async {
    final recurring = _box.get(id);
    if (recurring != null) {
      recurring.isActive = !recurring.isActive;
      await recurring.save();
    }
  }

  Future<void> markExecuted(String id) async {
    final recurring = _box.get(id);
    if (recurring != null) {
      recurring.lastExecuted = DateTime.now();
      await recurring.save();
    }
  }

  Future<void> deleteAll() async {
    await _box.clear();
  }

  ValueListenable<Box<RecurringTransaction>> get listenable => _box.listenable();
}