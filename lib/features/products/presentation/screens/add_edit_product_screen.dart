import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/services/ocr_service.dart';
import '../../../../core/utils/inci_parser.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_cubit.dart';
import 'ocr_validation_screen.dart';

/// [AddEditProductScreen] sınıfı, yeni kozmetik ürün ekleme veya
/// mevcut bir ürünü düzenleme formunu sunar.
class AddEditProductScreen extends StatefulWidget {
  /// Düzenlenmek istenen ürün (Yeni ürün ise null geçilir)
  final Product? productToEdit;

  const AddEditProductScreen({super.key, this.productToEdit});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _ingredientsController;
  late TextEditingController _paoController;

  DateTime? _expiryDate;
  DateTime? _openedAt;
  String _rawOcrText = '';
  bool _isVerified = true;

  final OcrService _ocrService = OcrService();

  @override
  void initState() {
    super.initState();
    final p = widget.productToEdit;
    _nameController = TextEditingController(text: p?.name ?? '');
    _brandController = TextEditingController(text: p?.brand ?? '');
    _ingredientsController = TextEditingController(
      text: p != null ? p.ingredients.join(', ') : '',
    );
    _paoController = TextEditingController(
      text: p?.paoMonths != null ? p!.paoMonths.toString() : '',
    );
    _expiryDate = p?.expiryDate;
    _openedAt = p?.openedAt;
    _rawOcrText = p?.rawOcrText ?? '';
    _isVerified = p?.isVerified ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _ingredientsController.dispose();
    _paoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final strings = AppStrings.of(context);
    final isEditing = widget.productToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? strings.editProductScreenTitle : strings.addProductScreenTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ürün Adı Giriş Alanı
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: strings.productNameField,
                  hintText: strings.productNameHint,
                  prefixIcon: const Icon(Icons.shopping_bag_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return strings.productNameError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Marka Giriş Alanı
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(
                  labelText: strings.brandField,
                  hintText: strings.brandHint,
                  prefixIcon: const Icon(Icons.business_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // --- OCR İle Tara Butonları Alanı ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceVariant : AppColors.roseSoft,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.roseLight,
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.document_scanner_outlined,
                          color: isDark ? AppColors.roseLight : AppColors.plum,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          strings.ocrCardHeader,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.roseLight : AppColors.plum,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strings.ocrCardDesc,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _handleOcr(ImageSource.camera, strings),
                            icon: const Icon(Icons.camera_alt_outlined, size: 18),
                            label: Text(strings.cameraBtn),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _handleOcr(ImageSource.gallery, strings),
                            icon: const Icon(Icons.photo_library_outlined, size: 18),
                            label: Text(strings.galleryBtn),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // INCI İçerik Listesi Metin Alanı
              TextFormField(
                controller: _ingredientsController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: strings.inciFieldLabel,
                  hintText: strings.inciFieldHint,
                  helperText: strings.inciHelperText,
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Icon(Icons.science_outlined),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return strings.inciFieldError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // PAO ve Tarih Bilgileri Kartı
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.datesHeader,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.roseLight : AppColors.plum,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // PAO (Açıldıktan Sonra Kullanım Süresi Ay)
                      TextFormField(
                        controller: _paoController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: strings.paoFieldLabel,
                          hintText: strings.paoFieldHint,
                          prefixIcon: const Icon(Icons.timelapse_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Açılış Tarihi Seçimi
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_today_outlined, color: AppColors.rose),
                        title: Text(strings.openedDateTile),
                        subtitle: Text(
                          _openedAt != null
                              ? '${_openedAt!.day}.${_openedAt!.month}.${_openedAt!.year}'
                              : strings.notSpecified,
                        ),
                        trailing: TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _openedAt ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                _openedAt = picked;
                              });
                            }
                          },
                          child: Text(strings.pickDateBtn),
                        ),
                      ),

                      // Son Kullanma Tarihi Seçimi
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.event_busy_outlined, color: AppColors.alertRed),
                        title: Text(strings.expiryDateTile),
                        subtitle: Text(
                          _expiryDate != null
                              ? '${_expiryDate!.day}.${_expiryDate!.month}.${_expiryDate!.year}'
                              : strings.notSpecified,
                        ),
                        trailing: TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 365)),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2035),
                            );
                            if (picked != null) {
                              setState(() {
                                _expiryDate = picked;
                              });
                            }
                          },
                          child: Text(strings.pickDateBtn),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Kaydet Butonu
              ElevatedButton.icon(
                onPressed: _saveProduct,
                icon: const Icon(Icons.save_rounded),
                label: Text(
                  isEditing ? strings.saveChangesBtn : strings.saveProductBtn,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// OCR akışını başlatır ve kullanıcıyı doğrulama ekranına yönlendirir
  Future<void> _handleOcr(ImageSource source, AppStrings strings) async {
    final extractedText = await _ocrService.pickAndExtractText(source);
    if (extractedText != null && mounted) {
      // Doğrulama ekranına git (Kullanıcı onayı zorunludur)
      final confirmedText = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => OcrValidationScreen(initialText: extractedText),
        ),
      );

      if (confirmedText != null && mounted) {
        setState(() {
          _rawOcrText = extractedText;
          _ingredientsController.text = confirmedText;
          _isVerified = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(strings.isTr
                ? 'İçerik listesi doğrulandı ve forma aktarıldı.'
                : 'Ingredient list verified and transferred to form.'),
            backgroundColor: AppColors.safeGreen,
          ),
        );
      }
    }
  }

  /// Formu doğrular ve ürünü kaydeder
  void _saveProduct() {
    if (!_formKey.currentState!.validate()) return;

    final parsedIngredients = InciParser.parseIngredients(_ingredientsController.text);
    final pao = int.tryParse(_paoController.text.trim());

    final now = DateTime.now();
    final product = Product(
      id: widget.productToEdit?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      ingredients: parsedIngredients,
      rawOcrText: _rawOcrText,
      isVerified: _isVerified,
      createdAt: widget.productToEdit?.createdAt ?? now,
      updatedAt: now,
      openedAt: _openedAt,
      paoMonths: pao,
      expiryDate: _expiryDate,
    );

    context.read<ProductCubit>().saveProduct(product);
    Navigator.pop(context);
  }
}
