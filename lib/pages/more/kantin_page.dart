import 'package:faunty/components/custom_chip.dart';
import 'package:flutter/material.dart';
import 'package:faunty/tools/translation_helper.dart';
import 'package:faunty/components/custom_snackbar.dart';

class KantinPage extends StatefulWidget {
  const KantinPage({super.key});

  @override
  State<KantinPage> createState() => _KantinPageState();
}

class _KantinPageState extends State<KantinPage> {
  double debt = 0.0;

  void _changeDebt(double value) {
    if (debt + value > 999) {
      showCustomSnackBar(context, 'Bro pay your debt first');
      return;
    }
    setState(() {
      debt += value;
      debt = double.parse(debt.toStringAsFixed(2));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonWidth = MediaQuery.of(context).size.width * 0.18;
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context: context, 'Kantin')),
        centerTitle: true,
      ),
      body: Column(
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
                      onPressed: () => _changeDebt(-1.0),
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
                      onPressed: () => _changeDebt(-0.5),
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
                    onTap: () async {
                      final controller = TextEditingController(text: debt.toStringAsFixed(2).replaceAll('.', ','));
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
                                  showCustomSnackBar(context, 'Bo pay your debt first');
                                  Navigator.pop(context); // Dialog schließen, auch wenn ungültig
                                  return;
                                }
                                Navigator.pop(context, parsed);
                              } else {
                                Navigator.pop(context); // Dialog schließen, auch wenn ungültig
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
                                    showCustomSnackBar(context, 'Bo pay your debt first');
                                    Navigator.pop(context); // Dialog schließen, auch wenn ungültig
                                    return;
                                  }
                                  Navigator.pop(context, value);
                                } else {
                                  Navigator.pop(context); // Dialog schließen, auch wenn ungültig
                                }
                              },
                              child: Text(translation(context: context, 'Save')),
                            ),
                          ],
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          debt = double.parse(result.toStringAsFixed(2));
                        });
                      }
                    },
                    child: Text(
                        debt.toStringAsFixed(2).replaceAll('.', ','),
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
                      onPressed: () => _changeDebt(1.0),
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
                      onPressed: () => _changeDebt(0.5),
                      child: const Text('+0,5', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Produktchips (Dummy-Liste für spätere Firebase-Anbindung)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final product in _dummyProducts)
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _changeDebt(product['price'] as double),
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
        ],
      ),
    );
  }

  // Dummy-Produkte für die Chips
  final List<Map<String, dynamic>> _dummyProducts = [
    {'name': 'Eis', 'price': 1.0},
    {'name': 'Spezi', 'price': 1.5},
    {'name': 'Cola', 'price': 1.2},
    {'name': 'Wasser', 'price': 0.5},
  ];
}
