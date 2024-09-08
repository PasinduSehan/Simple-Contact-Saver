import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'Contact.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  List<Contact> contacts = List.empty(growable: true);

  var selectedindex = -1;
  late SharedPreferences sp;

  @override
  void initState() {
    super.initState();
    getSharedPreferences().then((_) {
      readdata();
    });
  }

  Future<void> getSharedPreferences() async {
    sp = await SharedPreferences.getInstance();
  }

  void savedata() {
    List<String> contactlist =
        contacts.map((contact) => jsonEncode(contact.toJson())).toList();
    sp.setStringList("mydata", contactlist);
  }

  void readdata() {
    List<String>? contactlist = sp.getStringList('mydata');
    if (contactlist != null) {
      setState(() {
        contacts = contactlist
            .map((contact) => Contact.fromJson(jsonDecode(contact)))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Storage",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 39, 62, 73),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getSharedPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Contact Name',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: contactController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Contact Number',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          String name = nameController.text.trim();
                          String contact = contactController.text.trim();
                          if (name.isNotEmpty && contact.isNotEmpty) {
                            setState(() {
                              nameController.text = '';
                              contactController.text = '';
                              contacts
                                  .add(Contact(name: name, contact: contact));
                            });
                            savedata();
                          }
                        },
                        child: Text('Save'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String name = nameController.text.trim();
                          String contact = contactController.text.trim();
                          if (name.isNotEmpty && contact.isNotEmpty) {
                            setState(() {
                              nameController.text = '';
                              contactController.text = '';
                              contacts[selectedindex].name = name;
                              contacts[selectedindex].contact = contact;
                              selectedindex = -1;
                            });
                            savedata();
                          }
                        },
                        child: Text('Update'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  contacts.isEmpty
                      ? Text('No contact')
                      : Expanded(
                          child: ListView.builder(
                            itemCount: contacts.length,
                            itemBuilder: (context, index) => Card(
                              child: ListTile(
                                title: Column(
                                  children: [
                                    Text(contacts[index].name),
                                    Text(contacts[index].contact),
                                  ],
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: index % 2 == 0
                                      ? Colors.deepPurple
                                      : Colors.deepOrange,
                                  foregroundColor: Colors.white,
                                  child: Text(
                                    contacts[index].name[0],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                trailing: SizedBox(
                                  width: 70,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        child: Icon(Icons.edit),
                                        onTap: () {
                                          nameController.text =
                                              contacts[index].name;
                                          contactController.text =
                                              contacts[index].contact;
                                          setState(() {
                                            selectedindex = index;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        child: Icon(Icons.delete),
                                        onTap: () {
                                          setState(() {
                                            contacts.removeAt(index);
                                          });
                                          savedata();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
