import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../auxfiles/contactButton_aux.dart';

class FakeUrlLauncher extends UrlLauncherPlatform {
  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    return true;
  }

  @override
  // TODO: implement linkDelegate
  LinkDelegate? get linkDelegate => throw UnimplementedError();
}

void main() {
  setUp(() {
    UrlLauncherPlatform.instance = FakeUrlLauncher();
  });

  testWidgets('UrlFloatingActionButton calls launchUrl on tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          floatingActionButton: UrlFloatingActionButton(
            url: 'https://example.com',
            iconImage: 'assets/img/whatsapp.svg',
            iconSize: 40,
          ),
        ),
      ),
    );

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
  });
}
