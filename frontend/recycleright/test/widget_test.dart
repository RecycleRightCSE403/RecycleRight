import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera/camera.dart';

import 'package:recycleright/main.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    const CameraDescription fakeCamera = CameraDescription(
      name: '0', 
      lensDirection: CameraLensDirection.back, 
      sensorOrientation: 90, 
    );

    await tester.pumpWidget(const MyApp(camera: fakeCamera));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
