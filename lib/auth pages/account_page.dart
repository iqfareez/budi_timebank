import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:budi_timebank/components/avatar.dart';
import '../components/constants.dart';
import '../custom%20widgets/theme.dart';
import '../extension_string.dart';
import '../splash_page.dart';

import '../custom widgets/customHeadline.dart';
import '../generated/user.pb.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController();
  final _contactController = TextEditingController();
  final _contactControllerType = TextEditingController();
  final _idController = TextEditingController();
  final _idTypeController = TextEditingController();
  final _genderController = TextEditingController();
  final _skillController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late List<dynamic> skills;
  late List<dynamic> contacts;
  List<String> listGender = <String>['male', 'female'];
  List<String> listContactType = <String>[
    'WhatsApp',
    'Email',
    'Phone',
    'Twitter'
  ];
  List<String> idUser = <String>['passport', 'matricno', 'mykad'];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // _genderController.text = listGender[0];
    _contactControllerType.text = listContactType[2];
    // _idTypeController.text = idUser[0];
    Future.delayed(Duration.zero, _getProfile);
  }

  _addskills(String skill) {
    setState(() {
      skills.insert(0, skill);
    });
  }

  _deleteSkill(String skill) {
    setState(() {
      skills.removeWhere((element) => element == skill);
    });
  }

  _deleteContact(String skill) {
    setState(() {
      contacts.removeWhere((element) => element['address'] == skill);
    });
  }

  _addcontact(String type, String address) {
    var contact2 = Contact()
      ..address = address
      ..type = type;
    //print(contact2);
    setState(() {
      contacts.insert(0, contact2.toProto3Json());
      //print(contacts);
    });
  }

  _isSkillsEmpty(dynamic stuff) {
    if (stuff.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  _isContactsEmpty(dynamic stuff) {
    if (stuff.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _getProfile() async {
    skills = [];
    contacts = [];

    setState(() {
      _loading = true;
    });

    try {
      final userId = supabase.auth.currentUser!.id; //map the user ID
      final data = await supabase
          .from('profiles')
          .select()
          .eq('user_id', userId)
          .single() as Map;
      _usernameController.text = (data['name'] ?? '') as String;
      // _contactController.text = (data['website'] ?? '') as String;
      _idController.text = (data['identification_no']['value'] ?? '') as String;
      // print(data['identification_no']['type']);
      // print(data['identification_no']['value'] == 'mykad');
      if (data['identification_no']['type'] == 'mykad') {
        _idTypeController.text = idUser[2];
      } else if (data['identification_no']['type'] == 'matricno') {
        _idTypeController.text = idUser[1];
      } else {
        _idTypeController.text = idUser[0];
      }

      if (data['gender'] == 'male') {
        _genderController.text = listGender[0];
      } else {
        _genderController.text = listGender[1];
      }

      // _idTypeController.text =
      //     (data['identification_no']['type'] ?? '') as String;
      // _genderController.text = (data['gender'] ?? '') as String;
      //print(_idController.text);

      // for (int i = 0; i < data['identification_no'].length; i++) {
      //   if (data['skills'][i] != '') {
      //     skills.add(data['skills'][i]);
      //   }
      // }

      for (int i = 0; i < data['skills'].length; i++) {
        if (data['skills'][i] != '') {
          skills.add(data['skills'][i]);
        }
      }
      for (int i = 0; i < data['contacts'].length; i++) {
        if (data['contacts'][i] != '') {
          contacts.add(data['contacts'][i]);
        }
      }
    } on PostgrestException catch (error) {
      if (_usernameController.text == '') {
        context.showSnackBar(message: 'Welcome to BUDI!');
      } else {
        context.showErrorSnackBar(message: error.message);
        print(error);
      }
    } catch (error) {
      context.showErrorSnackBar(message: 'Missing Description');
      print(error);
    }

    setState(() {
      _loading = false;
    });
  }

  // _updateContact() async{
  //   final user = supabase.auth.currentUser;
  //   final updates = {
  //     'user_id': user!.id,
  //     'skills': skills,
  //     'contacts': contacts,
  //     'updated_at': DateTime.now().toIso8601String(),
  //     // 'avatar_url': _avatarUrl,
  //   };
  //   try {
  //     await supabase.from('profiles').upsert(updates);
  //   } on PostgrestException catch (error) {
  //     context.showErrorSnackBar(message: error.message);
  //   } catch (error) {
  //     context.showErrorSnackBar(message: 'Unable to Update Profile');
  //   }
  // }

  /// Called when user taps `Update` button
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final userName = _usernameController.text;
    // final idnum = _idController.text;
    final user = supabase.auth.currentUser;
    final gender = _genderController.text;
    final idUser = {
      'type': _idTypeController.text,
      'value': _idController.text
    };
    final updates = {
      'user_id': user!.id,
      'name': userName,
      'skills': skills,
      'contacts': contacts,
      'updated_at': DateTime.now().toIso8601String(),
      'identification_no': idUser,
      'gender': gender,
      // 'avatar_url': _avatarUrl,
    };
    try {
      await supabase.from('profiles').upsert(updates);
      if (mounted) {
        context.showSnackBar(message: 'Successfully updated profile!');
        Navigator.of(context).pop();
        // Navigator.of(context).popUntil((route) => route.isFirst);
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => BottomBarNavigation()));
      }
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: 'Unable to Update Profile');
      print(error);
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException {
      context.showErrorSnackBar(message: 'error signing out');
    } catch (error) {
      context.showErrorSnackBar(message: 'Unable to signout');
    }
    if (mounted) {
      //Navigator.of(context).pushReplacementNamed('/');
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const SplashPage()));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _contactController.dispose();
    _idController.dispose();
    _genderController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        backgroundColor: themeData2().primaryColor,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                children: [
                  // Avatar(
                  //   imageUrl: _avatarUrl,
                  //   onUpload: _onUpload,
                  // ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CustomHeadline(heading: 'Name'),
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name...';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomHeadline(heading: 'Gender'),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        //padding: EdgeInsets.all(8),
                        margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: themeData2().primaryColor,
                              width: 2,
                            )),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: Container(
                            height: 0,
                          ),
                          iconEnabledColor: themeData2().primaryColor,
                          value: _genderController.text,
                          items: listGender.map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem<String>(
                                value: e,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    e.titleCase(),
                                    style: TextStyle(
                                        color: themeData2().primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _genderController.text = value.toString();
                              //print(_genderController.text);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 0, 8, 8),
                    child: CustomHeadline(heading: 'Identification'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _idController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter identification number'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter matric number...';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        //padding: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width / 3,
                        margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: themeData2().primaryColor,
                              width: 2,
                            )),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: Container(
                            height: 0,
                          ),
                          iconEnabledColor: themeData2().primaryColor,
                          value: _idTypeController.text,
                          items: idUser.map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem<String>(
                                value: e,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    e.titleCase(),
                                    style: TextStyle(
                                        color: themeData2().primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _idTypeController.text = value.toString();
                              //print(_genderController.text);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(
                      //horizontal line
                      color: themeData2().primaryColor,
                      height: 30,
                      thickness: 2,
                      indent: 15,
                      endIndent: 15),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CustomHeadline(heading: 'Skill'),
                  ),
                  TextFormField(
                    controller: _skillController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Add Skills',
                        //labelText: 'Skill',
                        //suffixIconColor: themeData2().primaryColor,
                        suffixIcon: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: themeData2().primaryColor,
                          ),
                          onPressed: () {
                            if (_skillController.text.isEmpty) {
                              context.showErrorSnackBar(
                                  message: 'You have not entered any skill..');
                            } else {
                              try {
                                _addskills(_skillController.text);
                                _skillController.clear();
                                context.showSnackBar(message: 'Skill added!');
                              } catch (e) {
                                context.showErrorSnackBar(
                                    message: 'Unable to add skill');
                              }
                            }
                          },
                          child: const Icon(Icons.add),
                        )),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Your Skills: '),
                  ),
                  _isSkillsEmpty(skills)
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('You have not entered any skill'),
                        )
                      : SizedBox(
                          height: 60,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: skills.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(skills[index]
                                          .toString()
                                          .capitalize()),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            _deleteSkill(
                                                skills[index].toString());
                                          },
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.red,
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                  Divider(
                      //horizontal line
                      color: themeData2().primaryColor,
                      height: 30,
                      thickness: 2,
                      indent: 15,
                      endIndent: 15),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CustomHeadline(heading: 'Contacts'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _contactController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Add Contacts',
                            //labelText: 'Contact',
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter contacts';
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: themeData2().primaryColor,
                        ),
                        onPressed: () {
                          if (_contactController.text.isEmpty) {
                            context.showErrorSnackBar(
                                message: 'You have not entered any contact..');
                          } else {
                            try {
                              _addcontact(_contactControllerType.text,
                                  _contactController.text);
                              _contactController.clear();
                              context.showSnackBar(message: 'Contact Added!');
                            } catch (e) {
                              context.showErrorSnackBar(
                                  message: 'Unable to add contact');
                            }
                          }
                        },
                        child: const Icon(Icons.add),
                      ),
                      Container(
                        //padding: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: themeData2().primaryColor,
                              width: 2,
                            )),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          //dropdownColor: themeData2().primaryColor,
                          iconEnabledColor: themeData2().primaryColor,
                          underline: Container(
                            height: 0,
                          ),
                          // iconEnabledColor:
                          //     themeData2().primaryColor,
                          value: _contactControllerType.text,
                          items: listContactType
                              .map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem<String>(
                                value: e,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                        color: themeData2().primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _contactControllerType.text = value.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Your Contacts: '),
                  ),
                  _isContactsEmpty(contacts)
                      ? const Text('You have not entered any contacts...')
                      : SizedBox(
                          height: 180,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            //scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(contacts[index]['type']
                                              .toString()
                                              .capitalize()),
                                          Text(contacts[index]['address']
                                              .toString()),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            _deleteContact(contacts[index]
                                                    ['address']
                                                .toString());
                                          },
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.red,
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    // style: ElevatedButton.styleFrom(
                    //   foregroundColor: Colors.white,
                    //   backgroundColor: themeData2().primaryColor,
                    // ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateProfile();
                      }
                    },
                    child: Text(_loading ? 'Loading...' : 'Update'),
                  ),
                  // ElevatedButton(
                  //   onPressed: (() {
                  //     Navigator.of(context).popUntil((route) => route.isFirst);
                  //     // Navigator.pushReplacement(
                  //     //     context,
                  //     //     MaterialPageRoute(
                  //     //         builder: (BuildContext context) =>
                  //     //             BottomBarNavigation()));
                  //   }),
                  //   child: Text('Go to DashBoard'),
                  // ),
                  TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Confirm Sign Out?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _signOut();
                                  },
                                  child: const Text('Sign Out'),
                                ),
                              ],
                            ),
                          ),
                      // onPressed: _signOut,
                      child: const Text('Sign Out')),
                ],
              ),
            ),
    );
  }
}
