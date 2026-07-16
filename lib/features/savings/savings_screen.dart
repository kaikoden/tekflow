import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../shared/providers/app_providers.dart';
import '../../shared/widgets/app_card.dart';
import '../../data/models/savings_goal_model.dart';

class SavingsScreen extends ConsumerStatefulWidget {
  const SavingsScreen({super.key});

  @override
  ConsumerState<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends ConsumerState<SavingsScreen> {
  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(savingsProvider);
    final settings = ref.watch(settingsProvider);
    final symbol = settings.currencySymbol;
    final activeGoals = goals.where((g) => !g.isCompleted).toList();
    final completedGoals = goals.where((g) => g.isCompleted).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Savings Goals',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showAddGoalDialog(context),
                      icon: const Icon(Icons.add_rounded),
                      color: const Color(0xFF00D4FF),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
            ),
            if (activeGoals.isEmpty && completedGoals.isEmpty)
              SliverToBoxAdapter(
                child: _EmptyState(
                  onAdd: () => _showAddGoalDialog(context),
                ),
              ),
            if (activeGoals.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'Active Goals',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final goal = activeGoals[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _SavingsGoalCard(
                          goal: goal,
                          symbol: symbol,
                          onTap: () => _showGoalDetail(context, goal),
                          onDelete: () => _deleteGoal(goal),
                        ),
                      );
                    },
                    childCount: activeGoals.length,
                  ),
                ),
              ),
            ],
            if (completedGoals.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'Completed 🎉',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ).animate(delay: 200.ms).fadeIn(duration: 300.ms),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final goal = completedGoals[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _SavingsGoalCard(
                          goal: goal,
                          symbol: symbol,
                          isCompleted: true,
                          onTap: () => _showGoalDetail(context, goal),
                          onDelete: () => _deleteGoal(goal),
                        ),
                      );
                    },
                    childCount: completedGoals.length,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showAddGoalDialog(BuildContext context) async {
    final result = await showDialog<SavingsGoal>(
      context: context,
      builder: (ctx) => const _AddGoalDialog(),
    );
    if (result != null && mounted) {
      await ref.read(savingsProvider.notifier).add(result);
    }
  }

  Future<void> _showGoalDetail(BuildContext context, SavingsGoal goal) async {
    final result = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _GoalDetailSheet(goal: goal),
    );
    if (result != null && result > 0 && mounted) {
      await ref.read(savingsProvider.notifier).addContribution(goal.id, result);
    }
  }

  Future<void> _deleteGoal(SavingsGoal goal) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Goal?'),
        content: Text('Are you sure you want to delete "${goal.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE8365D),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await ref.read(savingsProvider.notifier).delete(goal.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal deleted')),
      );
    }
  }
}

class _SavingsGoalCard extends StatelessWidget {
  final SavingsGoal goal;
  final String symbol;
  final bool isCompleted;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SavingsGoalCard({
    required this.goal,
    required this.symbol,
    this.isCompleted = false,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(goal.colorValue);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  goal.iconEmoji ?? '🎯',
                  style: const TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    if (goal.deadline != null)
                      Text(
                        'Target: ${DateFormat('MMM d, yyyy').format(goal.deadline!)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                isCompleted
                    ? '✅ Done'
                    : '${(goal.progress * 100).toStringAsFixed(0)}%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isCompleted
                      ? const Color(0xFF00B87C)
                      : color,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                color: Colors.grey[400],
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 8,
                width: MediaQuery.of(context).size.width * 0.7 * goal.progress,
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFF00B87C) : color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$symbol${goal.currentAmount.toStringAsFixed(0)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Text(
                '$symbol${goal.targetAmount.toStringAsFixed(0)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.flag_outlined,
              size: 64,
              color: Color(0xFF00D4FF),
            ),
            const SizedBox(height: 16),
            Text(
              'No Savings Goals Yet',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start saving for your dreams!',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Savings Goal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4FF),
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddGoalDialog extends ConsumerStatefulWidget {
  const _AddGoalDialog();

  @override
  ConsumerState<_AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends ConsumerState<_AddGoalDialog> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _deadline;
  String _iconEmoji = '🎯';
  Color _selectedColor = const Color(0xFF00D4FF);

  final List<String> _emojis = [
    '🎯', '🏠', '🚗', '✈️', '💼', '🎓', '🏖️', '💎', '🤑', '🌟'
  ];

  final List<Color> _colors = [
    const Color(0xFF00D4FF),
    const Color(0xFF00B87C),
    const Color(0xFFFF6B6B),
    const Color(0xFFFFB300),
    const Color(0xFF6C63FF),
    const Color(0xFFE8365D),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Create Savings Goal'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Goal Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Target Amount',
                prefixText: '₱ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Deadline'),
              subtitle: Text(
                _deadline != null
                    ? DateFormat('MMM d, yyyy').format(_deadline!)
                    : 'Set a deadline',
              ),
              trailing: const Icon(Icons.calendar_today_rounded),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                );
                if (picked != null) {
                  setState(() => _deadline = picked);
                }
              },
            ),
            const SizedBox(height: 12),
            const Text('Icon', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _emojis.map((emoji) {
                return GestureDetector(
                  onTap: () => setState(() => _iconEmoji = emoji),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _iconEmoji == emoji
                          ? const Color(0xFF00D4FF).withValues(alpha: 0.2)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      border: _iconEmoji == emoji
                          ? Border.all(color: const Color(0xFF00D4FF))
                          : null,
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            const Text('Color', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _colors.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: _selectedColor == color
                          ? Border.all(color: Colors.black, width: 2)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text.trim();
            final amount = double.tryParse(_amountController.text);
            if (name.isEmpty || amount == null || amount <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid name and amount')),
              );
              return;
            }
            final goal = SavingsGoal(
              name: name,
              targetAmount: amount,
              deadline: _deadline,
              iconEmoji: _iconEmoji,
              colorValue: _selectedColor.toARGB32(),
            );
            Navigator.pop(context, goal);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00D4FF),
            foregroundColor: Colors.black,
          ),
          child: const Text('Create Goal'),
        ),
      ],
    );
  }
}

class _GoalDetailSheet extends ConsumerStatefulWidget {
  final SavingsGoal goal;

  const _GoalDetailSheet({required this.goal});

  @override
  ConsumerState<_GoalDetailSheet> createState() => _GoalDetailSheetState();
}

class _GoalDetailSheetState extends ConsumerState<_GoalDetailSheet> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final symbol = settings.currencySymbol;
    final goal = widget.goal;
    final color = Color(goal.colorValue);
    final isCompleted = goal.isCompleted;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1A1F3A)
            : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(goal.iconEmoji ?? '🎯', style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (goal.deadline != null)
                        Text(
                          'Target: ${DateFormat('MMM d, yyyy').format(goal.deadline!)}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Progress',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      '${(goal.progress * 100).toStringAsFixed(1)}%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Saved',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      '$symbol${goal.currentAmount.toStringAsFixed(0)}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Target',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      '$symbol${goal.targetAmount.toStringAsFixed(0)}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Container(
                  height: 12,
                  width: MediaQuery.of(context).size.width * 0.8 * goal.progress,
                  decoration: BoxDecoration(
                    color: isCompleted ? const Color(0xFF00B87C) : color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
            if (!isCompleted) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        hintText: 'Amount to add',
                        prefixText: '$symbol ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final amount = double.tryParse(_amountController.text);
                      if (amount == null || amount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Enter a valid amount')),
                        );
                        return;
                      }
                      Navigator.pop(context, amount);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF00B87C).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.celebration_rounded, color: Color(0xFF00B87C)),
                    const SizedBox(width: 8),
                    Text(
                      '🎉 Goal Achieved! Congratulations! 🎉',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00B87C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}