// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:my_assistant/applications.dart';

class RandomAppEditing extends StatefulWidget {
  String? name;
  List<dynamic>? items;
  Function callback;
  Function delete;
  RandomAppEditing(
      {Key? key,
      this.name,
      this.items,
      required this.callback,
      required this.delete})
      : super(key: key);

  @override
  _RandomAppEditingState createState() => _RandomAppEditingState();
}

class _RandomAppEditingState extends State<RandomAppEditing> {
  final controller = TextEditingController();
  var selected = names[0];

  @override
  void initState() {
    super.initState();

    widget.items ??= [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Row(children: [
                Text(
                  'Name : ',
                  style: TextStyle(color: Colors.green),
                ),
                Expanded(
                    child: TextField(
                  controller: controller,
                  style: TextStyle(color: Colors.green),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(100, 30, 30, 30),
                      hintText: widget.name,
                      hintStyle: TextStyle(color: Colors.green),
                      suffixIcon: IconButton(
                        onPressed: () => {widget.name = controller.text},
                        icon: Icon(Icons.check),
                        color: Colors.green,
                      )),
                ))
              ]),
              Row(
                children: [
                  Text('Items : ', style: TextStyle(color: Colors.green)),
                  Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.items?.length,
                          itemBuilder: (context, index) {
                            return Text(
                              widget.items?[index],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.green),
                            );
                          }))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Align(
                    alignment: Alignment.bottomRight,
                    child: DropdownButton(
                      value: selected,
                      dropdownColor: Colors.black,
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            selected = value.toString();
                          }
                        });
                      },
                      style: TextStyle(color: Colors.green),
                      items: names.map((String name) {
                        return DropdownMenuItem(
                            value: name,
                            child: Text(
                              name,
                              style: TextStyle(color: Colors.green),
                            ));
                      }).toList(),
                    ),
                  )),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.items!.add(selected);
                      });
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: IconButton(
                          onPressed: () {
                            if (widget.items != null) {
                              if (widget.items!.isNotEmpty) {
                                widget.items!.removeLast();
                                setState(() {});
                              }
                            }
                          },
                          icon: Icon(
                            Icons.horizontal_rule,
                            color: Colors.green,
                          )))
                ],
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    widget.delete(widget.name);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'delete',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              )),
              TextButton(
                onPressed: () {
                  widget.callback(widget.name, widget.items);
                  Navigator.pop(context);
                },
                child: Text(
                  'submit',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          )),
    );
  }
}
