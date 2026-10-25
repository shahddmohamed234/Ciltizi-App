import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/utils/inci_parser.dart';

/// [OcrValidationScreen] sınıfı, OCR ile görselden taranan içerik metninin
/// kullanıcı tarafından incelenmesini, düzeltilmesini ve onaylanmasını sağlar.
/// [project.md] temel ilkeler gereği bu doğrulama olmadan veri kesin kabul edilmez.
class OcrValidationScreen extends StatefulWidget {
  /// OCR tarafından çıkarılan ilk ham metin
  final String initialText;

  const OcrValidationScreen({super.key, required this.initialText});

  @override
  State<OcrValidationScreen> createState() => _OcrValidationScreenState();
}

class _OcrValidationScreenState extends State<OcrValidationScreen> {
  late TextEditingController _textController;
  List<String> _parsedChips = [];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
    _updateParsedChips(widget.initialText);
  }

  void _updateParsedChips(String text) {
    setState(() {
      _parsedChips = InciParser.parseIngredients(text);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final strings = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.ocrValidationTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kullanıcı Bilgilendirme Uyarısı
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.warningAmber.withValues(alpha: 0.18)
                    : AppColors.warningAmber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.warningAmber.withValues(alpha: isDark ? 0.45 : 0.3),
                  width: 1.2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.warningAmber, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      strings.ocrDisclaimer,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: isDark ? Colors.white : const Color(0xFF633A00),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Düzenlenebilir Metin Alanı
            Text(
              strings.editScannedText,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.roseLight : AppColors.plum,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              maxLines: 7,
              onChanged: _updateParsedChips,
              decoration: InputDecoration(
                hintText: strings.ocrInputHint,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),

            // Ayrıştırılan İçerik Önizlemesi (Chips)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${strings.parsedIngredientsTitle} (${_parsedChips.length})',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  strings.preview,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (_parsedChips.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  strings.noParsedIngredients,
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 13,
                  ),
                ),
              )
            else
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _parsedChips.map((chip) {
                  return Chip(
                    label: Text(chip, style: const TextStyle(fontSize: 12)),
                    backgroundColor: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.roseSoft,
                    side: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.roseLight,
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 32),

            // Onaylama Butonu
            ElevatedButton.icon(
              onPressed: () => _confirmAndReturn(strings),
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: Text(
                strings.confirmAndApplyBtn,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Onaylanan metni geri döndürür
  void _confirmAndReturn(AppStrings strings) {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.inciFieldError),
          backgroundColor: AppColors.alertRed,
        ),
      );
      return;
    }
    Navigator.pop(context, text);
  }
}
