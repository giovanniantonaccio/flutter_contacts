import 'dart:io';

import 'package:contacts_list/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({Key key, this.contact}) : super(key: key);

  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _userEdited = false;
  Contact _editedContact;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
    print(_editedContact);
    print(_nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? "New contact"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.camera)
                      .then((file) {
                    if (file == null)
                      return;
                    else
                      setState(() {
                        _editedContact.img = file.path;
                      });
                  });
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _editedContact.img != null
                          ? FileImage(File(_editedContact.img))
                          : AssetImage('images/person.png'),
                    ),
                  ),
                ),
              ),
              TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                  controller: _nameController,
                  focusNode: _nameFocus,
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedContact.name = text;
                    });
                  }),
              TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.email = text;
                  }),
              TextField(
                  decoration: InputDecoration(labelText: 'Phone'),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.phone = text;
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Discard changes?'),
              content: Text('Your changes will be lost.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
