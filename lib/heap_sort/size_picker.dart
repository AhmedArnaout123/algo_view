import 'package:flutter/material.dart';

class SizePicker extends StatelessWidget {
  final Function onChanged;
  final int value;

  const SizePicker({Key key, this.onChanged, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Size:',
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(
          width: 10,
        ),
        DropdownButton<int>(
          value: value,
          onChanged: onChanged,
          items: List.generate(
            14,
            (index) => DropdownMenuItem(
              value: index + 4,
              child: Text((index + 4).toString(),
                  style: TextStyle(
                    color: Colors.blueAccent,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
