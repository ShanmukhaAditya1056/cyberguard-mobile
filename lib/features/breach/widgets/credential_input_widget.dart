import 'package:flutter/material.dart';

import '../../../shared/widgets/cyber_text_field.dart';

class CredentialInputWidget extends StatelessWidget {
  const CredentialInputWidget({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CyberTextField(
      controller: controller,
      hintText: 'Enter email or phone',
      labelText: 'Credential',
      prefixIcon: Icons.lock_outline,
    );
  }
}
