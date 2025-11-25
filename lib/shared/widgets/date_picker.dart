import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invengo/core/constant/app_color.dart';

class DatePickerFormField extends StatefulWidget {
  final TextEditingController controller;

  const DatePickerFormField({super.key, required this.controller});

  @override
  State<DatePickerFormField> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true, // biar user gak bisa ngetik manual
      decoration: InputDecoration(
        hintText: 'Pilih tanggal',
        prefixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.borderLight),
        ),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          setState(() {
            widget.controller.text = DateFormat(
              'dd/MM/yyyy',
            ).format(pickedDate);
          });
        }
      },
    );
  }
}
