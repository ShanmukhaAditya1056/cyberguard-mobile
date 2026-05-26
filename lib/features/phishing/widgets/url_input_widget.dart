import 'package:flutter/material.dart';

import '../../../shared/widgets/cyber_text_field.dart';

class UrlInputWidget extends StatelessWidget {
  const UrlInputWidget({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CyberTextField(
      controller: controller,
      hintText: 'Paste URL or message here',
      labelText: 'URL or message',
      prefixIcon: Icons.link,
      maxLines: 3,
    );
  }
}
