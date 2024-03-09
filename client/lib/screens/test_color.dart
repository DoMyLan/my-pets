import 'package:flutter/material.dart';


class ColorSelect extends StatefulWidget {
  @override
  _ColorSelectState createState() => _ColorSelectState();
}

class _ColorSelectState extends State<ColorSelect> {
  List<String> _selectedColors = [];
  List<String> _colors = [
    'Red',
    'Green',
    'Blue',
    'Yellow',
    'Orange',
    'White',
    'Black',
    'Brown',
    'Grey'
  ];

  void _onColorSelected(String? color) {
    setState(() {
      if (color != null) {
        if (_selectedColors.contains(color)) {
          _selectedColors.remove(color);
        } else {
          _selectedColors.add(color);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            // Wrap ListTile with Expanded
            child: ListTile(
              title: Text('Select color'),
              trailing: DropdownButton<String>(
                value: null,
                onChanged: _onColorSelected,
                items: _colors.map((String color) {
                  return DropdownMenuItem<String>(
                    value: color,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 25,
                          height: 10,
                          color: _getColorFromString(color),
                        ),
                        SizedBox(width: 20,),
                        Text(color),
                        if (_selectedColors.contains(color))
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Flexible(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Selected colors',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(
                text: _selectedColors.join(', '),
              ),
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorFromString(String colorString) {
    switch (colorString) {
      case 'Red':
        return Colors.red;
      case 'Green':
        return Colors.green;
      case 'Blue':
        return Colors.blue;
      case 'Yellow':
        return Colors.yellow;
      case 'Orange':
        return Colors.orange;
      case 'White':
        return Color.fromARGB(255, 245, 242, 242);
      case 'Black':
        return Colors.black;
      case 'Brown':
        return Colors.brown;
      case 'Grey':
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }
}
