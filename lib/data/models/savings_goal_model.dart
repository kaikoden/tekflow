import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'savings_goal_model.g.dart';

@HiveType(typeId: 9)
class SavingsGoal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double targetAmount;

  @HiveField(3)
  double currentAmount;

  @HiveField(4)
  DateTime? deadline;

  @HiveField(5)
  String? iconEmoji;

  @HiveField(6)
  int colorValue;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  bool isCompleted;

  SavingsGoal({
    String? id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.deadline,
    this.iconEmoji = '🎯',
    required this.colorValue,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  double get progress => targetAmount > 0
      ? (currentAmount / targetAmount).clamp(0.0, 1.0)
      : 0.0;

  double get remainingAmount => (targetAmount - currentAmount).clamp(0.0, double.infinity);

  bool get isAchieved => currentAmount >= targetAmount;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'targetAmount': targetAmount,
        'currentAmount': currentAmount,
        'deadline': deadline?.toIso8601String(),
        'iconEmoji': iconEmoji,
        'colorValue': colorValue,
        'createdAt': createdAt.toIso8601String(),
        'isCompleted': isCompleted,
      };

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    return SavingsGoal(
      id: json['id'] as String,
      name: json['name'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      iconEmoji: json['iconEmoji'] as String? ?? '🎯',
      colorValue: json['colorValue'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  SavingsGoal copyWith({
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    String? iconEmoji,
    int? colorValue,
    bool? isCompleted,
  }) {
    return SavingsGoal(
      id: id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      colorValue: colorValue ?? this.colorValue,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}