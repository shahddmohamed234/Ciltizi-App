import 'package:flutter_test/flutter_test.dart';
import 'package:ciltizi/core/utils/inci_parser.dart';

void main() {
  group('InciParser Unit Testleri', () {
    test('Virgülle ve yeni satırlarla ayrılmış içerikleri doğru ayrıştırmalıdır', () {
      const raw = '''
        Ingredients: Aqua (Water), Glycerin; Niacinamide • Sodium Hyaluronate
        Phenoxyethanol, Ethylhexylglycerin.
      ''';

      final result = InciParser.parseIngredients(raw);

      expect(result.contains('Aqua (Water)'), isTrue);
      expect(result.contains('Glycerin'), isTrue);
      expect(result.contains('Niacinamide'), isTrue);
      expect(result.contains('Sodium Hyaluronate'), isTrue);
      expect(result.contains('Phenoxyethanol'), isTrue);
      expect(result.contains('Ethylhexylglycerin'), isTrue);
    });

    test('Normalize fonksiyonu parantezleri ve büyük/küçük harf farkını temizlemelidir', () {
      expect(InciParser.normalize('Aqua (Water)'), equals('aqua'));
      expect(InciParser.normalize('PARFÜM / Fragrance'), equals('parfum / fragrance'));
    });

    test('İçerik eşleşmelerini doğru tespit etmelidir', () {
      final ingredients = ['Aqua', 'Glycerin', 'Alcohol Denat.', 'Parfum'];
      final targets = ['Parfum', 'Linalool', 'Alcohol Denat'];

      final matches = InciParser.findMatches(ingredients, targets);

      expect(matches, contains('Parfum'));
      expect(matches, contains('Alcohol Denat'));
      expect(matches, isNot(contains('Linalool')));
    });
  });
}
