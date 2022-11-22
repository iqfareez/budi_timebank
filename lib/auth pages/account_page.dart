import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:testfyp/components/avatar.dart';
import 'package:testfyp/components/constants.dart';
import 'package:testfyp/extension_string.dart';
import 'package:testfyp/splash_page.dart';

import '../generated/rating/user.pb.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController();
  final _contactController = TextEditingController();
  final _contactControllerType = TextEditingController();
  final _matricController = TextEditingController();
  final _genderController = TextEditingController();
  final _skillController = TextEditingController();
  // late String _avatarUrl = '';

  late List<dynamic> skills;
  late List<dynamic> contacts;
  List<String> listGender = <String>['male', 'female'];
  List<String> listContactType = <String>[
    'WhatsApp',
    'Email',
    'Phone',
    'Twitter'
  ];
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _genderController.text = listGender[0];
    _contactControllerType.text = listContactType[2];
    //_getProfile();
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
      _matricController.text = (data['matric_number'] ?? '') as String;
      _genderController.text = (data['gender'] ?? '') as String;
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
      }
    } catch (error) {
      context.showErrorSnackBar(message: 'Missing Description');
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
    // final website = _contactController.text;
    final matricNum = _matricController.text;
    final user = supabase.auth.currentUser;
    final gender = _genderController.text;
    // final description = _skillController.text;
    //print(user!.id);
    //final avatar =
    //final skills = _skillsController;
    // print(contacts);
    // print(skills);
    final updates = {
      'user_id': user!.id,
      'name': userName,
      'skills': skills,
      'contacts': contacts,
      'updated_at': DateTime.now().toIso8601String(),
      'matric_number': matricNum,
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
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
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
    _matricController.dispose();
    _genderController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        // backgroundColor: Color.fromARGB(255, 127, 17, 224),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              children: [
                // Avatar(
                //   imageUrl: _avatarUrl,
                //   onUpload: _onUpload,
                // ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'User Name'),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Gender'),
                    Container(
                      //padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          )),
                      child: DropdownButton<String>(
                        underline: Container(
                          height: 0,
                        ),
                        iconEnabledColor: Theme.of(context).primaryColor,
                        value: _genderController.text,
                        items: listGender.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem<String>(
                              value: e,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  e,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
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
                TextFormField(
                  controller: _matricController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Matric Number'),
                ),
                TextFormField(
                  controller: _skillController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Add Skills',
                      labelText: 'Skill',
                      suffixIcon: TextButton(
                        onPressed: () {
                          try {
                            _addskills(_skillController.text);
                            _skillController.clear();
                            context.showSnackBar(message: 'Skill added!');
                          } catch (e) {
                            context.showErrorSnackBar(
                                message: 'Unable to add skill');
                          }
                        },
                        child: const Icon(Icons.add),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter skill';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                Text('Your Skills: '),
                SizedBox(
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
                                Text(skills[index].toString().capitalize()),
                                SizedBox(
                                  height: 5,
                                ),
                                IconButton(
                                    onPressed: () {
                                      _deleteSkill(skills[index].toString());
                                    },
                                    icon: Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                    )),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(
                      hintText: 'Add Contacts',
                      labelText: 'Contact',
                      suffixIcon: SizedBox(
                        width: 190,
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                try {
                                  _addcontact(_contactControllerType.text,
                                      _contactController.text);
                                  _contactController.clear();
                                  context.showSnackBar(
                                      message: 'Contact Added!');
                                } catch (e) {
                                  context.showErrorSnackBar(
                                      message: 'Unable to add contact');
                                }
                              },
                              child: Icon(Icons.add),
                            ),
                            Container(
                              //padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 2,
                                  )),
                              child: DropdownButton<String>(
                                underline: Container(
                                  height: 0,
                                ),
                                iconEnabledColor:
                                    Theme.of(context).primaryColor,
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
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _contactControllerType.text =
                                        value.toString();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter contacts';
                  //   }
                  //   return null;
                  // },
                ),
                Text('Your Contacts: '),
                SizedBox(
                    height: 60,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(contacts[index]['type']
                                        .toString()
                                        .capitalize()),
                                    Text(contacts[index]['address']
                                        .toString()
                                        .capitalize()),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                IconButton(
                                    onPressed: () {
                                      _deleteContact(contacts[index]['address']
                                          .toString());
                                    },
                                    icon: Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                    )),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _updateProfile();
                  },
                  child: Text(_loading ? 'Loading...' : 'Update'),
                ),
                ElevatedButton(
                  onPressed: (() {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) =>
                    //             BottomBarNavigation()));
                  }),
                  child: Text('Go to DashBoard'),
                ),
                TextButton(onPressed: _signOut, child: const Text('Sign Out')),
              ],
            ),
    );
  }
}
