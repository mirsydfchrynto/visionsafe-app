import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import '../../controllers/quests_controller.dart';

/// Tile tugas pada Quest Map (Compact Vertical Edition).
class QuestTaskTile extends GetView<QuestsController> {
  final Map<String, dynamic> quest;
  final bool isLast;

  const QuestTaskTile({super.key, required this.quest, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final status = quest['status'] as String;
    final isLocked = status == 'locked';
    final isCompleted = status == 'completed';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Row(
            children: [
              _buildStatusIcon(isLocked, isCompleted),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest['title'],
                      style: AppTextStyles.bodyBold.copyWith(
                        color: isLocked ? Colors.grey : const Color(0xFF003366),
                      ),
                    ),
                    Text(
                      quest['subtitle'],
                      style: AppTextStyles.caption.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (status == 'active')
                _buildStartButton()
              else if (isCompleted)
                const Icon(Icons.check_circle_rounded, color: Colors.blue, size: 24),
            ],
          ),
          if (!isLast) _buildStepLine(),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(bool isLocked, bool isCompleted) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: isLocked ? Colors.grey.shade200 : (isCompleted ? Colors.blue.shade100 : Colors.orange.shade100),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF003366), width: 2),
      ),
      child: Icon(
        quest['icon'],
        color: isLocked ? Colors.grey : (isCompleted ? Colors.blue.shade800 : Colors.orange.shade800),
        size: 20,
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        onPressed: () => controller.startTask(quest['id']),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        child: const Text("START", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
      ),
    );
  }

  Widget _buildStepLine() {
    return Container(
      margin: const EdgeInsets.only(left: 22),
      alignment: Alignment.centerLeft,
      child: Container(
        width: 2,
        height: 20,
        color: Colors.grey.shade300,
      ),
    );
  }
}
