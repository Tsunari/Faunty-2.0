import 'package:faunty/components/custom_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faunty/tools/translation_helper.dart';
import 'package:faunty/components/custom_snackbar.dart';
import 'package:faunty/state_management/kantin_provider.dart';
import 'package:faunty/firestore/kantin_firestore_service.dart';
import 'package:faunty/state_management/user_provider.dart';
import 'package:faunty/state_management/user_list_provider.dart';
import 'package:faunty/models/user_roles.dart';


class KantinPage extends ConsumerStatefulWidget {
  const KantinPage({super.key});

  @override
  ConsumerState<KantinPage> createState() => _KantinPageState();
}

class _KantinPageState extends ConsumerState<KantinPage> {
  double _localDebt = 0.0;
  bool _isLoading = false;

  // Dummy-Produkte für die Chips
  final List<Map<String, dynamic>> _dummyProducts = [
    {'name': 'Eis', 'price': 1.0},
    {'name': 'Spezi', 'price': 1.5},
    {'name': 'Cola', 'price': 1.2},
    {'name': 'Wasser', 'price': 0.5},
  ];

  Future<void> _setDebt(double newDebt, String placeId, String userUid) async {
    if (newDebt > 999) {
      showCustomSnackBar(context, 'Bro pay your debt first');
      return;
    }
    setState(() => _isLoading = true);
    await KantinFirestoreService(placeId).updateUserDebt(userUid, newDebt);
    setState(() {
      _localDebt = newDebt;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Get current user and placeId from providers
    final user = ref.watch(userProvider);
    final placeId = user.value?.placeId ?? '';
    final userUid = user.value?.uid ?? '';
    final kantinAsync = ref.watch(kantinProvider(placeId));

    // Get all debts (Map<String, double>)
    final debts = kantinAsync.asData?.value ?? {};
    final currentDebt = debts[userUid] ?? 0.0;

    // For local UI update before Firestore stream updates
    final displayDebt = _isLoading ? _localDebt : currentDebt;

    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context: context, 'Kantin')),
        centerTitle: true,
      ),
      body: kantinAsync.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left buttons (abziehen)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 90,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _isLoading || userUid.isEmpty ? null : () => _setDebt(displayDebt - 1.0, placeId, userUid),
                      child: const Text('-1', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 90,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _isLoading || userUid.isEmpty ? null : () => _setDebt(displayDebt - 0.5, placeId, userUid),
                      child: const Text('-0,5', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 32),
              // Counter
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    translation(context: context, 'Debt'),
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _isLoading || userUid.isEmpty
                        ? null
                        : () async {
                      final controller = TextEditingController(text: displayDebt.toStringAsFixed(2).replaceAll('.', ','));
                      final result = await showDialog<double>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(translation(context: context, 'Debt')),
                          content: TextField(
                            controller: controller,
                            autofocus: true,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: translation(context: context, 'Enter amount'),
                            ),
                            onSubmitted: (value) {
                              final parsed = double.tryParse(value.replaceAll(',', '.'));
                              if (parsed != null) {
                                if (parsed > 999) {
                                  showCustomSnackBar(context, 'Bro pay your debt first');
                                  Navigator.pop(context);
                                  return;
                                }
                                Navigator.pop(context, parsed);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            onTap: () {
                              controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(translation(context: context, 'Cancel')),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final value = double.tryParse(controller.text.replaceAll(',', '.'));
                                if (value != null) {
                                  if (value > 999) {
                                    showCustomSnackBar(context, 'Bro pay your debt first');
                                    Navigator.pop(context);
                                    return;
                                  }
                                  Navigator.pop(context, value);
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(translation(context: context, 'Save')),
                            ),
                          ],
                        ),
                      );
                      if (result != null) {
                        await _setDebt(result, placeId, userUid);
                      }
                    },
                    child: Text(
                        displayDebt.toStringAsFixed(2).replaceAll('.', ','),
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 32),
              // Right buttons (hinzufügen)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 90,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _isLoading || userUid.isEmpty ? null : () => _setDebt(displayDebt + 1.0, placeId, userUid),
                      child: const Text('+1', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 90,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _isLoading || userUid.isEmpty ? null : () => _setDebt(displayDebt + 0.5, placeId, userUid),
                      child: const Text('+0,5', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Produktchips
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final product in _dummyProducts)
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: _isLoading || userUid.isEmpty ? null : () => _setDebt(displayDebt + (product['price'] as double), placeId, userUid),
                  child: CustomChip(
                    label: '${product['name']} ${product['price'].toString().replaceAll('.', ',')}',
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    textColor: theme.colorScheme.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),
          // Other users' debts
          Consumer(
            builder: (context, ref, _) {
              final usersAsync = ref.watch(usersByCurrentPlaceProvider);
              final users = usersAsync.asData?.value ?? [];
              final otherUsers = users.where((u) => u.uid != userUid && (u.role == UserRole.baskan || u.role == UserRole.talebe)).toList();
              final jokes = [
                "Buys snacks like they're stocks.",
                "Thinks cola is a personality trait.",
                "Has a PhD in impulse buying.",
                "Can’t resist a good deal on water.",
                "Eats ice cream for breakfast.",
                "Believes Spezi is the drink of champions.",
                "Always asks for extra napkins.",
                "Thinks every day is treat day.",
                "Has a secret stash of snacks.",
                "Buys more than they can carry.",
                "Knows the vending machine by heart.",
                "Can’t say no to a bargain.",
                "Thinks buying snacks is cardio.",
                "Has a loyalty card for everything.",
                "Snacks are their spirit animal.",
                "Can turn any purchase into a story.",
                "Thinks debt is just snack points.",
                "Always finds a reason to celebrate with food.",
                "Buys drinks for the squad.",
                "Snack shopping: their superpower."
              ];
              random(int seed) => jokes[(DateTime.now().millisecondsSinceEpoch + seed) % jokes.length];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translation(context: context, 'Other users'),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    if (otherUsers.isEmpty)
                      Text(translation(context: context, 'No other users found'))
                    else
                      ...otherUsers.map((user) => Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: CircleAvatar(child: Text(user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : user.uid.substring(0, 2).toUpperCase())),
                              title: Text('${user.firstName} ${user.lastName}'),
                              subtitle: Text(random(user.uid.hashCode)),
                              trailing: Text('${(debts[user.uid] ?? 0.0).toStringAsFixed(2).replaceAll('.', ',')} €', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
                            ),
                          ))
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
