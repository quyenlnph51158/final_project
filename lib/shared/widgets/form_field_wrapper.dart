import 'package:flutter/cupertino.dart';

class FormFieldWrapper extends StatelessWidget {
  final Widget child;

  const FormFieldWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: child,
    );
  }
}
