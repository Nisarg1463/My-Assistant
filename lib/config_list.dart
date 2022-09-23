// ignore_for_file: must_be_immutable, prefer_const_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:my_assistant/applications.dart';

class ConfigList extends StatefulWidget {
  Function callback;
  List startingList;
  ConfigList(this.callback, this.startingList, {Key? key}) : super(key: key);

  @override
  _ConfigListState createState() => _ConfigListState();
}

class _ConfigListState extends State<ConfigList> {
  late List<dynamic> items = widget.startingList;
  String selected = '';
  @override
  void initState() {
    super.initState();
    selected = names[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Items : ', style: TextStyle(color: Colors.green)),
                    Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return Text(
                                items[index],
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
                          items.add(selected);
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
                              if (items != null) {
                                if (items.isNotEmpty) {
                                  items.removeLast();
                                  setState(() {});
                                }
                              }
                            },
                            icon: Icon(
                              Icons.horizontal_rule,
                              color: Colors.green,
                            ))),
                  ],
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      widget.callback(items);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'done',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ))
              ],
            )));
  }
}
