import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/constants.dart';
import '../custom%20widgets/theme.dart';
import '../extension_string.dart';
import '../model/contact.dart';
import '../model/identification.dart';
import '../model/profile.dart';
import '../splash_page.dart';

import '../custom widgets/customHeadline.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController();
  final _contactController = TextEditingController();
  final _idController = TextEditingController();
  final _skillController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late List<String> skills;
  late List<Contact> contacts;
  List<Gender> listGender = Gender.values;
  List<ContactType> listContactType = ContactType.values;
  List<IdentificationType> idUser = IdentificationType.values;
  bool _loading = true;

  ContactType _selectedContactType = ContactType.phone;
  IdentificationType _selectedIdType = IdentificationType.mykad;
  Gender? _userGender;

  @override
  void initState() {
    super.initState();
    // _genderController.text = listGender[0];
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

  _deleteContact(String contact) {
    setState(() {
      contacts.removeWhere((element) => element.value == contact);
    });
  }

  _addcontact(ContactType type, String value) {
    throw UnimplementedError('addcontact is not implemented yet');
    // var contact2 = Contact()
    //   ..value = value
    //   ..type = type;
    // //print(contact2);
    // setState(() {
    //   contacts.insert(0, contact2.toProto3Json());
    //   //print(contacts);
    // });
  }

  Future<void> _getProfile() async {
    skills = [];
    contacts = [];

    setState(() {
      _loading = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      final document = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((value) => value.data());

      final data = Profile.fromJson(document!['profile']);

      _usernameController.text = data.name;
      // _contactController.text = (data['website'] ?? '') as String;
      _idController.text = data.identification.value;
      _selectedIdType = data.identification.identificationType;

      _userGender = data.gender;

      // _idTypeController.text =
      //     (data['identification']['type'] ?? '') as String;
      // _genderController.text = (data['gender'] ?? '') as String;
      //print(_idController.text);

      // for (int i = 0; i < data['identification'].length; i++) {
      //   if (data['skills'][i] != '') {
      //     skills.add(data['skills'][i]);
      //   }
      // }

      // assign skills
      skills = data.skills;

      // assign contacts

      contacts = data.contacts;
    } on FirebaseException catch (error) {
      if (_usernameController.text == '') {
        context.showSnackBar(message: 'Welcome to BUDI!');
      } else {
        context.showErrorSnackBar(message: error.message.toString());
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
    final user = FirebaseAuth.instance.currentUser;
    final idUser = {'type': _selectedIdType.name, 'value': _idController.text};
    final contactsUser = contacts
        .map((e) => {
              'type': e.contactType.name,
              'value': e.value,
            })
        .toList();
    final updates = {
      'name': userName,
      'skills': skills,
      'contacts': contactsUser,
      'identification': idUser,
      'gender': _userGender?.name,
      // 'avatar_url': _avatarUrl,
    };
    try {
      FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'profile': updates,
        'updated_at': DateTime.now().toIso8601String(),
      });
      if (mounted) {
        context.showSnackBar(message: 'Successfully updated profile!');
      }
    } on FirebaseException catch (error) {
      context.showErrorSnackBar(message: error.message.toString());
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
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException {
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
                        child: DropdownButton<Gender>(
                          isExpanded: true,
                          underline: Container(
                            height: 0,
                          ),
                          iconEnabledColor: themeData2().primaryColor,
                          value: _userGender,
                          items: listGender.map<DropdownMenuItem<Gender>>((e) {
                            return DropdownMenuItem<Gender>(
                                value: e,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    e.name.titleCase(),
                                    style: TextStyle(
                                        color: themeData2().primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _userGender = value!;
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
                        child: DropdownButton<IdentificationType>(
                          isExpanded: true,
                          underline: Container(
                            height: 0,
                          ),
                          iconEnabledColor: themeData2().primaryColor,
                          value: _selectedIdType,
                          items: idUser
                              .map<DropdownMenuItem<IdentificationType>>((e) {
                            return DropdownMenuItem<IdentificationType>(
                                value: e,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    e.name.titleCase(),
                                    style: TextStyle(
                                        color: themeData2().primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedIdType = value!;
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
                  skills.isEmpty
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
                              _addcontact(_selectedContactType,
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
                        child: DropdownButton<ContactType>(
                          isExpanded: true,
                          //dropdownColor: themeData2().primaryColor,
                          iconEnabledColor: themeData2().primaryColor,
                          underline: Container(
                            height: 0,
                          ),
                          // iconEnabledColor:
                          //     themeData2().primaryColor,
                          value: _selectedContactType,
                          items: listContactType.map((e) {
                            return DropdownMenuItem<ContactType>(
                                value: e,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    e.name.titleCase(),
                                    style: TextStyle(
                                        color: themeData2().primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedContactType = value!;
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
                  contacts.isEmpty
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
                                          Text(contacts[index]
                                              .contactType
                                              .name
                                              .capitalize()),
                                          Text(
                                              contacts[index].value.toString()),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            _deleteContact(
                                                contacts[index].value);
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
