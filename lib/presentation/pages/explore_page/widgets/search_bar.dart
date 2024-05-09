import 'package:flutter/material.dart';

class Searchbar extends StatefulWidget {
  const Searchbar({
    super.key,
    required this.searchController,
    required this.onTextChanged,
  });

  final TextEditingController searchController;
  final Function(String) onTextChanged;

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onTextChanged,
      controller: widget.searchController,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.all(0),
        enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 41, 41, 41)),
            borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(
          Icons.search,
        ),
        hintText: 'Search...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
