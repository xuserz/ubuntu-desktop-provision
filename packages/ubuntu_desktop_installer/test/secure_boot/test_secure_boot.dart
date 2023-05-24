import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ubuntu_desktop_installer/pages/secure_boot/secure_boot_model.dart';
import 'package:ubuntu_desktop_installer/pages/secure_boot/secure_boot_page.dart';
import 'package:ubuntu_desktop_installer/services.dart';

import 'test_secure_boot.mocks.dart';
export 'test_secure_boot.mocks.dart';

@GenerateMocks([StorageService])
SecureBootModel buildSecureBootModel({
  bool? isFormValid,
  bool? isConfirmationKeyValid,
  bool? areTextFieldsEnabled,
  String? securityKey,
  String? confirmKey,
  SecureBootMode? secureBootMode,
}) {
  final model = MockSecureBootModel();
  when(model.isFormValid).thenReturn(isFormValid ?? false);
  when(model.isConfirmationKeyValid).thenReturn(isConfirmationKeyValid ?? true);
  when(model.areTextFieldsEnabled).thenReturn(areTextFieldsEnabled ?? true);
  when(model.secureBootMode)
      .thenReturn(secureBootMode ?? SecureBootMode.turnOff);
  when(model.securityKey).thenReturn(securityKey ?? '');
  when(model.confirmKey).thenReturn(confirmKey ?? '');
  return model;
}

@GenerateMocks([SecureBootModel])
Widget buildSecureBootPage(SecureBootModel model) {
  return ProviderScope(
    overrides: [secureBootModelProvider.overrideWith((_) => model)],
    child: const SecureBootPage(),
  );
}