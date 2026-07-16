import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'transaction_model.dart';

part 'recurring_transaction_model.g.dart';

enum RecurringFrequency {
  daily,
  weekly,
  monthly,
  yearly,
}

@HiveType(typeId: 10)
class RecurringTransaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double amount;

  @HiveField(3)
  TransactionType type;

  @HiveField(4)
  String categoryId;

  @HiveField(5)
  String? accountId;

  @HiveField(6)
  RecurringFrequency frequency;

  @HiveField(7)
  DateTime startDate;

  @HiveField(8)
  DateTime? endDate;

  @HiveField(9)
  int dayOfMonth; // For monthly

  @HiveField(10)
  int dayOfWeek; // For weekly (1=Monday, 7=Sunday)

  @HiveField(11)
  bool isActive;

  @HiveField(12)
  DateTime createdAt;

  @HiveField(13)
  DateTime? lastExecuted;

  RecurringTransaction({
    String? id,
    required this.name,
    required this.amount,
    required this.type,
    required this.categoryId,
    this.accountId,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.dayOfMonth = 1,
    this.dayOfWeek = 1,
    this.isActive = true,
    DateTime? createdAt,
    this.lastExecuted,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  String get frequencyLabel {
    switch (frequency) {
      case RecurringFrequency.daily:
        return 'Daily';
      case RecurringFrequency.weekly:
        return 'Weekly';
      case RecurringFrequency.monthly:
        return 'Monthly';
      case RecurringFrequency.yearly:
        return 'Yearly';
    }
  }

  String get nextExecutionDate {
    final now = DateTime.now();
    DateTime nextDate;

    switch (frequency) {
      case RecurringFrequency.daily:
        nextDate = DateTime(now.year, now.month, now.day);
        break;
      case RecurringFrequency.weekly:
        final daysUntil = (dayOfWeek - now.weekday + 7) % 7;
        nextDate = now.add(Duration(days: daysUntil));
        break;
      case RecurringFrequency.monthly:
        if (now.day <= dayOfMonth) {
          nextDate = DateTime(now.year, now.month, dayOfMonth);
        } else {
          final nextMonth = now.month == 12
              ? DateTime(now.year + 1, 1, dayOfMonth)
              : DateTime(now.year, now.month + 1, dayOfMonth);
          nextDate = nextMonth;
        }
        break;
      case RecurringFrequency.yearly:
        nextDate = DateTime(now.year, now.month, now.day);
        break;
    }

    return DateFormat('MMM d, yyyy').format(nextDate);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'amount': amount,
        'type': type.name,
        'categoryId': categoryId,
        'accountId': accountId,
        'frequency': frequency.name,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'dayOfMonth': dayOfMonth,
        'dayOfWeek': dayOfWeek,
        'isActive': isActive,
        'createdAt': createdAt.toIso8601String(),
        'lastExecuted': lastExecuted?.toIso8601String(),
      };

  factory RecurringTransaction.fromJson(Map<String, dynamic> json) {
    return RecurringTransaction(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.expense,
      ),
      categoryId: json['categoryId'] as String,
      accountId: json['accountId'] as String?,
      frequency: RecurringFrequency.values.firstWhere(
        (e) => e.name == json['frequency'],
        orElse: () => RecurringFrequency.monthly,
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      dayOfMonth: json['dayOfMonth'] as int? ?? 1,
      dayOfWeek: json['dayOfWeek'] as int? ?? 1,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      lastExecuted: json['lastExecuted'] != null
          ? DateTime.parse(json['lastExecuted'] as String)
          : null,
    );
  }
}