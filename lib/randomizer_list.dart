// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_assistant/random_app_editing.dart';

class RandomizerList extends StatefulWidget {
  String name;
  List<dynamic> items;
  Function delete;
  Function save;
  RandomizerList(this.name, this.items, this.delete, this.save, {Key? key})
      : super(key: key);

  @override
  _RandomizerListState createState() => _RandomizerListState();
}

class _RandomizerListState extends State<RandomizerList> {
  void click() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RandomAppEditing(
                  name: widget.name,
                  items: widget.items,
                  callback: callback,
                  delete: widget.delete,
                )));
  }

  void callback(String name, List<dynamic> items) {
    widget.name = name;
    widget.items = items;
    setState(() {});
    widget.save();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.center,
            child: Text(
              widget.name,
              style: TextStyle(color: Colors.green),
            )),
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.items[index],
                  style: TextStyle(color: Colors.green),
                ));
          },
        ),
        Row(
          children: [
            Expanded(
                child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: click,
                icon: Icon(
                  Icons.edit,
                  color: Colors.green,
                ),
              ),
            ))
          ],
        )
      ],
    );
  }
}
