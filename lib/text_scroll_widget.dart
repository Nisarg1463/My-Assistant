import 'package:flutter/material.dart';

class TextScrollWidget extends StatefulWidget {
  final List<String> textList;
  const TextScrollWidget(this.textList, {Key? key}) : super(key: key);

  @override
  _TextScrollWidgetState createState() => _TextScrollWidgetState();
}

class _TextScrollWidgetState extends State<TextScrollWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.textList.length,
        itemBuilder: (context, index) {
          return Text(
            widget.textList[index],
            style: const TextStyle(color: Colors.green),
          );
        });
  }
}
