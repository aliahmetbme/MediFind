import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medifinder/core/components/cards/provider_card.dart';

void main() {
  testWidgets('ProviderCard renders core provider information', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProviderCard(
            name: 'Dr. Test Provider',
            specialty: 'Cardiology',
            city: 'New York',
          ),
        ),
      ),
    );

    expect(find.text('Dr. Test Provider'), findsOneWidget);
    expect(find.text('Cardiology'), findsOneWidget);
    expect(find.text('New York'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsNothing);
  });
}
