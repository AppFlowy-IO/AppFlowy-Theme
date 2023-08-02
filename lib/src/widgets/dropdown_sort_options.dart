import 'package:flutter/material.dart';

class DropDownSortOption extends StatefulWidget {
  const DropDownSortOption({super.key, required this.sort});
  
  final Function(bool, String) sort;

  @override
  State<DropDownSortOption> createState() => _DropDownSortOptionState();
}

class _DropDownSortOptionState extends State<DropDownSortOption> {
  bool _ascending = false;
  String? _selectedOption;

  List<DropdownMenuItem<String>> options = const [
    DropdownMenuItem(value: 'none', child: Text('Sort by', style: TextStyle(color: Colors.white),),),
    DropdownMenuItem(value: 'rating', child: Text('Rating', style: TextStyle(color: Colors.white),),),
    DropdownMenuItem(value: 'name', child: Text('Name', style: TextStyle(color: Colors.white),),),
    DropdownMenuItem(value: 'latest', child: Text('Latest', style: TextStyle(color: Colors.white),),),
    DropdownMenuItem(value: 'download count', child: Text('Download count', style: TextStyle(color: Colors.white),),),
  ];

  @override
  void initState() {
    super.initState();
    _selectedOption = options[0].value;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedOption,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color:Colors.black54),
      iconEnabledColor: Colors.green,
      underline: Container(
        height: 1,
        color: Colors.green[800],
      ),
      onChanged: (String? value) {
        setState(() {
          if(_selectedOption == value){
            _ascending = !_ascending;
          }
          else{
            _ascending = false;
            _selectedOption = value!; //reset state if a different sort category is used
          }
          widget.sort(_ascending, _selectedOption ?? 'none');
        });
      },
      items: options,
      
    );
  }
}