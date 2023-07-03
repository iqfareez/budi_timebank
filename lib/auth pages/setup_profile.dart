import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/constants.dart';
import '../custom widgets/customHeadline.dart';
import '../custom%20widgets/theme.dart';
import '../db_helpers/client_user.dart';
import '../extension_string.dart';
import '../model/contact.dart';
import '../model/identification.dart';
import '../model/profile.dart';

class SetupProfile extends StatefulWidget {
  const SetupProfile({super.key});

  @override
  State<SetupProfile> createState() => _SetupProfileState();
}

class _SetupProfileState extends State<SetupProfile> {
  final _usernameController = TextEditingController();
  final _contactController = TextEditingController();
  final _idController = TextEditingController();
  final _skillController = TextEditingController();
  final _organizationNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<String> skills = [];
  List<Contact> contacts = [];
  List<Gender> listGender = Gender.values;
  List<ContactType> listContactType = ContactType.values;
  List<IdentificationType> idUser = IdentificationType.values;
  ContactType _selectedContactType = ContactType.phone;
  IdentificationType _selectedIdType = IdentificationType.mykad;
  OwnerType _selectedOwnerType = OwnerType.individual;
  Gender _userGender = Gender.male;

  final userId = FirebaseAuth.instance.currentUser!.uid;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initProfile();
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
    var newContact = Contact(contactType: type, value: value);

    setState(() {
      contacts.insert(0, newContact);
    });
  }

  Future<void> _initProfile() async {
    setState(() => _loading = true);

    try {
      // Create user profile
      FirebaseFirestore.instance.collection('users').doc(userId).set({
        'earningsHistory': [],
        'profile': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (error) {
      context.showErrorSnackBar(message: error.message.toString());
      return;
    }

    setState(() => _loading = false);
  }

  /// Called when user taps `Save` button
  Future<void> _saveProfile() async {
    setState(() => _loading = true);
    var userIdentification = Identification(
        identificationType: _selectedIdType, value: _idController.text);
    var orgName = _selectedOwnerType == OwnerType.individual
        ? null
        : _organizationNameController.text;

    var newProfile = Profile(
      name: _usernameController.text,
      skills: skills,
      contacts: contacts,
      identification: userIdentification,
      ownerType: _selectedOwnerType,
      gender: _userGender,
      organizationName: orgName,
    );

    try {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'earningsHistory': [],
        'profile': newProfile.toMap(),
        'updatedAt': DateTime.now().toIso8601String(),
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

    // add points

    await ClientUser.addPoints(
        points: _selectedOwnerType == OwnerType.individual ? 10 : 200);

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _contactController.dispose();
    _idController.dispose();
    _skillController.dispose();
    _organizationNameController.dispose();
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
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomHeadline(heading: 'Owner type'),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.6,
                        //padding: EdgeInsets.all(8),
                        margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: themeData2().primaryColor,
                              width: 2,
                            )),
                        child: DropdownButton<OwnerType>(
                          isExpanded: true,
                          underline: Container(
                            height: 0,
                          ),
                          iconEnabledColor: themeData2().primaryColor,
                          value: _selectedOwnerType,
                          items: OwnerType.values
                              .map<DropdownMenuItem<OwnerType>>((e) {
                            return DropdownMenuItem<OwnerType>(
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
                              _selectedOwnerType = value!;
                              //print(_genderController.text);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_selectedOwnerType == OwnerType.organization) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _organizationNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter organization name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter organization name number...';
                        }
                        return null;
                      },
                    ),
                  ],

                  const Divider(
                      //horizontal line
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
                                          _deleteContact(contacts[index].value);
                                        },
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      await _saveProfile();
                      if (mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/navigation', (route) => false);
                      }
                    },
                    child: Text(_loading ? 'Loading...' : 'Save'),
                  ),
                ],
              ),
            ),
    );
  }
}
