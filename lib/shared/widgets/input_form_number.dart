import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class InputFormNumber extends StatefulWidget {
  const InputFormNumber({
    super.key,
    this.controller,
    this.hint,
    this.validator,
    this.isPrice = false,
  });
  final TextEditingController? controller;
  final String? hint;
  final String? Function(String?)? validator;
  final bool isPrice;

  @override
  State<InputFormNumber> createState() => _InputFormNumberState();
}

class _InputFormNumberState extends State<InputFormNumber> {
  final NumberFormat _formatter = NumberFormat("#,###", "id_ID");

  @override
  void initState() {
    super.initState();

    if (widget.isPrice &&
        widget.controller != null &&
        widget.controller!.text.isNotEmpty) {
      final raw = widget.controller!.text.replaceAll('.', '');
      final number = int.tryParse(raw);
      if (number != null) {
        widget.controller!.text = _formatter.format(number);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: widget.hint,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
        prefixIcon: widget.isPrice
            ? Icon(
                FontAwesomeIcons.rupiahSign,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              )
            : null,
      ),
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUnfocus,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), 
        if (widget.isPrice)
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.text.isEmpty) return newValue;

            final newText = newValue.text.replaceAll('.', '');

            final number = int.tryParse(newText);
            if (number == null) return oldValue;

            final formatted = _formatter.format(number);

            return TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(offset: formatted.length),
            );
          }),
      ],
    );
  }
}
