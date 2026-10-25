import 'package:flutter_test/flutter_test.dart';
import 'package:ciltizi/app/app.dart';

void main() {
  testWidgets('ciltİzi uygulaması başlangıç duman (smoke) testi', (WidgetTester tester) async {
    // Uygulamayı başlat
    await tester.pumpWidget(const CiltiziApp());
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    // Üst barda ciltİzi başlığını doğrula
    expect(find.text('ciltİzi'), findsWidgets);

    // Alt gezinme sekmelerini doğrula
    expect(find.text('Ürünlerim'), findsOneWidget);
    expect(find.text('Profilim'), findsOneWidget);
    expect(find.text('Ayarlar'), findsOneWidget);
  });
}
