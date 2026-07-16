import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../shared/providers/app_providers.dart';
import '../../shared/widgets/app_card.dart';
import '../../data/models/recurring_transaction_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/category_model.dart';

class RecurringScreen extends ConsumerStatefulWidget {
  const RecurringScreen({super.key});

  @override
  ConsumerState<RecurringScreen> createState() => _RecurringScreenState();
}

class _RecurringScreenState extends ConsumerState<RecurringScreen> {
  @override
  Widget build(BuildContext context) {
    final recurringList = ref.watch(recurringProvider);
    final activeRecurring = recurringList.where((r) => r.isActive).toList();
    final inactiveRecurring = recurringList.where((r) => !r.isActive).toList();

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
                      'Recurring Transactions',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showAddRecurringDialog(context),
                      icon: const Icon(Icons.add_rounded),
                      color: const Color(0xFF00D4FF),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
            ),
            if (recurringList.isEmpty)
              SliverToBoxAdapter(
                child: _EmptyState(
                  onAdd: () => _showAddRecurringDialog(context),
                ),
              ),
            if (activeRecurring.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'Active',
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
                      final item = activeRecurring[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _RecurringCard(
                          recurring: item,
                          onToggle: () => _toggleRecurring(item),
                          onDelete: () => _deleteRecurring(item),
                        ),
                      );
                    },
                    childCount: activeRecurring.length,
                  ),
                ),
              ),
            ],
            if (inactiveRecurring.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'Inactive',
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
                      final item = inactiveRecurring[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _RecurringCard(
                          recurring: item,
                          onToggle: () => _toggleRecurring(item),
                          onDelete: () => _deleteRecurring(item),
                          isInactive: true,
                        ),
                      );
                    },
                    childCount: inactiveRecurring.length,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ignore: use_build_context_synchronously
  Future<void> _showAddRecurringDialog(BuildContext context) async {
    final result = await showDialog<RecurringTransaction>(
      context: context,
      builder: (ctx) => const _AddRecurringDialog(),
    );
    if (result != null && mounted) {
      await ref.read(recurringProvider.notifier).add(result);
    }
  }

  Future<void> _toggleRecurring(RecurringTransaction item) async {
    await ref.read(recurringProvider.notifier).toggleActive(item.id);
  }

  Future<void> _deleteRecurring(RecurringTransaction item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Recurring?'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
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
      await ref.read(recurringProvider.notifier).delete(item.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recurring transaction deleted')),
      );
    }
  }
}

class _RecurringCard extends StatelessWidget {
  final RecurringTransaction recurring;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final bool isInactive;

  const _RecurringCard({
    required this.recurring,
    required this.onToggle,
    required this.onDelete,
    this.isInactive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = recurring.type == TransactionType.income
        ? const Color(0xFF00B87C)
        : const Color(0xFFE8365D);

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              recurring.type == TransactionType.income
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recurring.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${recurring.frequencyLabel} · ${recurring.isActive ? 'Next: ${recurring.nextExecutionDate}' : 'Inactive'}',
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
            '${recurring.type == TransactionType.expense ? '-' : '+'}₱${recurring.amount.toStringAsFixed(0)}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              recurring.isActive ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 20,
              color: Colors.grey[400],
            ),
            onPressed: onToggle,
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            color: Colors.grey[400],
            onPressed: onDelete,
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
              Icons.repeat_rounded,
              size: 64,
              color: Color(0xFF00D4FF),
            ),
            const SizedBox(height: 16),
            Text(
              'No Recurring Transactions',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set up automatic bills and income',
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
              label: const Text('Add Recurring'),
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

class _AddRecurringDialog extends ConsumerStatefulWidget {
  const _AddRecurringDialog();

  @override
  ConsumerState<_AddRecurringDialog> createState() => _AddRecurringDialogState();
}

class _AddRecurringDialogState extends ConsumerState<_AddRecurringDialog> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  TransactionType _type = TransactionType.expense;
  RecurringFrequency _frequency = RecurringFrequency.monthly;
  String? _categoryId;
  String? _accountId;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  int _dayOfMonth = 1;
  int _dayOfWeek = 1;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    final accounts = ref.watch(accountProvider);

    final expenseCategories = categories.where((c) =>
        c.type == CategoryType.expense || c.type == CategoryType.both).toList();
    final incomeCategories = categories.where((c) =>
        c.type == CategoryType.income || c.type == CategoryType.both).toList();
    final relevantCats = _type == TransactionType.income
        ? incomeCategories
        : expenseCategories;

    if (_categoryId == null && relevantCats.isNotEmpty) {
      _categoryId = relevantCats.first.id;
    }
    if (_accountId == null && accounts.isNotEmpty) {
      _accountId = accounts.first.id;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Add Recurring Transaction'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₱ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _TypeButton(
                    label: 'Expense',
                    selected: _type == TransactionType.expense,
                    color: const Color(0xFFE8365D),
                    onTap: () => setState(() {
                      _type = TransactionType.expense;
                      _categoryId = null;
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TypeButton(
                    label: 'Income',
                    selected: _type == TransactionType.income,
                    color: const Color(0xFF00B87C),
                    onTap: () => setState(() {
                      _type = TransactionType.income;
                      _categoryId = null;
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RecurringFrequency>(
              initialValue: _frequency,
              decoration: const InputDecoration(
                labelText: 'Frequency',
                border: OutlineInputBorder(),
              ),
              items: RecurringFrequency.values.map((f) {
                return DropdownMenuItem(
                  value: f,
                  child: Text(f.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (val) => setState(() => _frequency = val!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _categoryId,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: relevantCats.map((c) {
                return DropdownMenuItem(
                  value: c.id,
                  child: Row(
                    children: [
                      Icon(c.icon, color: c.color, size: 16),
                      const SizedBox(width: 8),
                      Text(c.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) => setState(() => _categoryId = val),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _accountId,
              decoration: const InputDecoration(
                labelText: 'Account',
                border: OutlineInputBorder(),
              ),
              items: accounts.map((a) {
                return DropdownMenuItem(
                  value: a.id,
                  child: Row(
                    children: [
                      Icon(a.icon, color: a.color, size: 16),
                      const SizedBox(width: 8),
                      Text(a.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) => setState(() => _accountId = val),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Start Date'),
              subtitle: Text(DateFormat('MMM d, yyyy').format(_startDate)),
              trailing: const Icon(Icons.calendar_today_rounded),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                );
                if (picked != null) {
                  setState(() => _startDate = picked);
                }
              },
            ),
            if (_frequency == RecurringFrequency.monthly) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Day of Month:'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Slider(
                      value: _dayOfMonth.toDouble(),
                      min: 1,
                      max: 28,
                      divisions: 27,
                      label: _dayOfMonth.toString(),
                      onChanged: (val) => setState(() => _dayOfMonth = val.toInt()),
                    ),
                  ),
                  Text(_dayOfMonth.toString(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      )),
                ],
              ),
            ],
            if (_frequency == RecurringFrequency.weekly) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Day of Week:'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Slider(
                      value: _dayOfWeek.toDouble(),
                      min: 1,
                      max: 7,
                      divisions: 6,
                      label: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][_dayOfWeek - 1],
                      onChanged: (val) => setState(() => _dayOfWeek = val.toInt()),
                    ),
                  ),
                  Text(
                    ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][_dayOfWeek - 1],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Set End Date'),
              value: _endDate != null,
              onChanged: (val) {
                if (val == true) {
                  setState(() => _endDate = DateTime.now().add(const Duration(days: 365)));
                } else {
                  setState(() => _endDate = null);
                }
              },
            ),
            if (_endDate != null)
              ListTile(
                title: const Text('End Date'),
                subtitle: Text(DateFormat('MMM d, yyyy').format(_endDate!)),
                trailing: const Icon(Icons.calendar_today_rounded),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _endDate!,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                  );
                  if (picked != null) {
                    setState(() => _endDate = picked);
                  }
                },
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
            if (_categoryId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a category')),
              );
              return;
            }
            final recurring = RecurringTransaction(
              name: name,
              amount: amount,
              type: _type,
              categoryId: _categoryId!,
              accountId: _accountId,
              frequency: _frequency,
              startDate: _startDate,
              endDate: _endDate,
              dayOfMonth: _dayOfMonth,
              dayOfWeek: _dayOfWeek,
              isActive: true,
            );
            Navigator.pop(context, recurring);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00D4FF),
            foregroundColor: Colors.black,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : Colors.transparent,
          border: Border.all(
            color: selected ? color : Colors.grey.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? color : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}