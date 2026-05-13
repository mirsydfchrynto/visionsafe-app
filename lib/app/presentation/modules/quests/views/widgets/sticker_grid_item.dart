import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/data/models/sticker_model.dart';

/// Item grid stiker versi Compact (Zero-Scroll Edition).
/// Audit Visual: Menggunakan Expanded/Flexible untuk mencegah RenderFlex overflow.
class StickerGridItem extends StatelessWidget {
  final StickerModel? sticker;

  const StickerGridItem({super.key, this.sticker});

  @override
  Widget build(BuildContext context) {
    final bool isLocked = sticker == null || !sticker!.isUnlocked;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Perbaikan: Batasi ukuran kontainer agar tidak overflow di layar kecil
        Flexible(
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: isLocked ? Colors.grey.shade200 : const Color(0xFFE0EAFC),
              shape: BoxShape.circle,
              border: Border.all(
                color: isLocked ? Colors.black12 : const Color(0xFF003366),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Icon(
                isLocked ? Icons.lock_rounded : Icons.workspace_premium_rounded,
                color: isLocked ? Colors.grey : const Color(0xFF003366),
                size: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isLocked ? "???" : sticker!.title.split(" ").first,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(fontSize: 8, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
