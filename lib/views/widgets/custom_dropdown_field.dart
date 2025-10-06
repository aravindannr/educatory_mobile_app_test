import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdownField extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    required this.fieldHeading,
    required this.hintText,
    required this.items,
    this.prefixIcon,
    this.onChanged,
    this.value,
  });

  final String fieldHeading;
  final String hintText;
  final List<String> items;
  final Icon? prefixIcon;
  final String? value;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldHeading,
          style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 5),
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonFormField<String>(
            initialValue: value,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              hintText: hintText,
              hintStyle: GoogleFonts.inter(fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item, style: GoogleFonts.inter(fontSize: 14)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
