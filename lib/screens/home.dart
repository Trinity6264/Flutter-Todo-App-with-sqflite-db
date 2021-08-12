import 'package:agokansie/models/contact_model.dart';
import 'package:agokansie/services/contact_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = '';
  String number = '';
  String time = '';
  DateTime now = DateTime.now();
  TextEditingController nameText = TextEditingController();
  TextEditingController numberText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ContactService _service = ContactService();
  ContactHelper? _helper;
  void _showModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    Text(
                      'Add New Contact',
                      style: GoogleFonts.aBeeZee(fontSize: 30),
                    ),
                    TextFormField(
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Name',
                        enabled: true,
                        fillColor: Colors.blueGrey.shade200,
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      onChanged: (val) {
                        setState(() {
                          number = val;
                        });
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Number',
                        enabled: true,
                        fillColor: Colors.blueGrey.shade200,
                        filled: true,
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                          child: Text(
                            'Add',
                            style: GoogleFonts.alike(fontSize: 20.0),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final _helper = ContactHelper(
                                name: name.toString(),
                                number: number.toString(),
                                time: DateFormat.MMMMEEEEd().format(now),
                              );
                              setState(() {
                                _service.insertData(helper: _helper).then(
                                    (value) => ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text('Todo add'))));
                                Navigator.of(context).pop();
                                _formKey.currentState!.reset();
                              });
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _updateModalSheet({List? id}) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    Text(
                      'Update Contact',
                      style: GoogleFonts.aBeeZee(fontSize: 30),
                    ),
                    TextFormField(
                      controller: nameText,
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Name',
                        enabled: true,
                        fillColor: Colors.blueGrey.shade200,
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: numberText,
                      onChanged: (val) {
                        setState(() {
                          number = val;
                        });
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Number',
                        enabled: true,
                        fillColor: Colors.blueGrey.shade200,
                        filled: true,
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final _helper = ContactHelper(
                              name: name.toString(),
                              number: number.toString(),
                              time: DateFormat.MMMMEEEEd().format(now),
                            );
                            setState(() {
                              _service.updateData(id!, _helper).then((value) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Note update'))));
                              Navigator.of(context).pop();
                              _formKey.currentState!.reset();
                            });
                          }
                        },
                        child: Text(
                          'Update',
                          style: GoogleFonts.alike(fontSize: 20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  getpic() async {
    ImagePicker _image = ImagePicker();
    XFile? image = await _image.pickImage(source: ImageSource.gallery);
    print(image!.path);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Home Page',
          style: GoogleFonts.abhayaLibre(),
        ),
        actions: [
          IconButton(
            onPressed: getpic,
            icon: Icon(Icons.camera),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _service.fetchData(),
          builder: (_, AsyncSnapshot<List<Map>?> snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              return data!.isEmpty
                  ? Center(
                      child: Text('No Data Found'),
                    )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(parent: ScrollPhysics()),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (_, index) {
                        return Dismissible(
                          dragStartBehavior: DragStartBehavior.start,
                          direction: DismissDirection.horizontal,
                          behavior: HitTestBehavior.deferToChild,
                          background: Container(
                            color: Colors.red,
                          ),
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            setState(() {
                              final id = [data[index]['id']];
                              final _name = data[index]['name'];
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Deleted $_name'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    setState(() {
                                      _service.insertData(
                                          helper: data[index]['name']);
                                    });
                                  },
                                ),
                              ));
                              _service.deleteData(id);
                            });
                          },
                          child: Card(
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  nameText.text = data[index]['name'];
                                  numberText.text = data[index]['number'];
                                  _updateModalSheet(id: [data[index]]);
                                });
                              },
                              leading: CircleAvatar(child: Icon(Icons.person)),
                              title: Text(data[index]['name']),
                              subtitle:
                                  Text('Created on: ' + data[index]['time']),
                            ),
                          ),
                        );
                      },
                    );
            } else {
              return Center(
                child: Text(
                  'NO DATA FOUND',
                  style: GoogleFonts.beVietnam(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showModalSheet,
        child: Icon(Icons.add),
      ),
    );
  }
}
