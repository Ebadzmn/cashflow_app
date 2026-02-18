import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../core/widgets/glass_text_field.dart';
import '../../../core/widgets/primary_button.dart';

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal({super.key});

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _dateController = TextEditingController();
  // Additional controllers for Bank Transaction
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();

  int _selectedType = 0; // 0: Income, 1: Expense, 2: Bank Transaction

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _dateController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: const Color(0xFF1F2937), // Dark blue-grey background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented Control
              Row(
                children: [
                  _buildSegmentButton("Income", 0),
                  const SizedBox(width: 12),
                  _buildSegmentButton("Expense", 1),
                  const SizedBox(width: 12),
                  _buildSegmentButton("Bank Transaction", 2),
                ],
              ),
              const SizedBox(height: 24),

              // Amount (Common for all)
              const Text("Amount", style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 4),
              GlassTextField(
                controller: _amountController,
                hintText: "\$ 0.00",
              ),
              const SizedBox(height: 12),

              if (_selectedType == 2) ...[
                // Bank Transaction Fields
                
                // Bank Name
                const Text("Bank Name", style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                GlassTextField(
                  controller: _bankNameController,
                  hintText: "e.g. Chase, Wells Fargo",
                ),
                const SizedBox(height: 12),

                // Account Number (Last 4)
                const Text("Account Number (Last 4)", style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                GlassTextField(
                  controller: _accountNumberController,
                  hintText: "**** 1234",
                ),
                const SizedBox(height: 12),

                // Description / Ref ID
                const Text("Description / Ref ID", style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                GlassTextField(
                  controller: _descriptionController,
                  hintText: "Transaction Ref ID or Description",
                ),
                const SizedBox(height: 12),

              ] else ...[
                // Income & Expense Fields

                // Description
                const Text("Description", style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                GlassTextField(
                  controller: _descriptionController,
                  hintText: "e.g. Chase, Wells Fargo",
                ),
                const SizedBox(height: 12),

                // Category
                const Text("Category", style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                GlassTextField(
                  controller: _categoryController,
                  hintText: "What was this for?",
                ),
                const SizedBox(height: 12),
              ],

              // Date (Common for all)
              const Text("Date", style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 4),
              GlassTextField(
                controller: _dateController,
                hintText: "Select Date",
                // suffixIcon: const Icon(Icons.calendar_today, color: Colors.white70, size: 20),
              ),
              const SizedBox(height: 12),

              // Evidence & Audit (Only for Income/Expense based on request "just Bank Transfer a ata hobe image ar data golo")
              if (_selectedType != 2) ...[
                const Text("EVIDENCE & AUDIT", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    context.push(Routes.SCAN_RECEIPT);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Attach Receipt", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            Text("Take photo or upload PDF", style: TextStyle(color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ] else ...[
                 const SizedBox(height: 8), // Little spacing for Bank Transaction before button
              ],

              // Add Button
              PrimaryButton(
                text: "Add",
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentButton(String text, int index) {
    final isSelected = _selectedType == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Colors.white.withValues(alpha: 0.50)
                  : Colors.white.withValues(alpha: 0.30),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }


}
