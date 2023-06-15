import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testfyp/bin/client_auth.dart';
import 'package:testfyp/bin/common.dart';
import 'package:testfyp/components/constants.dart';
import 'package:testfyp/custom%20widgets/customHeadline.dart';
import 'package:testfyp/custom%20widgets/theme.dart';
import 'package:testfyp/extension_string.dart';

import '../generated/user.pb.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  bool _redirecting = false;
  bool _passwordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _contactController = TextEditingController();
  final _contactControllerType = TextEditingController();
  final _idController = TextEditingController();
  final _idTypeController = TextEditingController();
  final _genderController = TextEditingController();
  final _skillController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<String> listGender = <String>['male', 'female'];
  List<String> listContactType = <String>[
    'WhatsApp',
    'Email',
    'Phone',
    'Twitter'
  ];
  List<String> idUser = <String>['passport', 'matricno', 'mykad'];

  late NewUserProfile profile;
  late IdentificationNumber _identificationNumber;
  late final StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    profile = NewUserProfile();
    _identificationNumber = IdentificationNumber();

    _genderController.text = listGender[0];
    _contactControllerType.text = listContactType[2];
    _idTypeController.text = idUser[0];

    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => AccountPage()));
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/navigation', (route) => false);
        //Navigator.of(context).pushReplacementNamed('/navigation');
      }
    });

    super.initState();
  }

  _signUpGrpc(String email, String password, String name, String gender,
      String identificationNum, String idType) async {
    setState(() {
      _isLoading = true;
    });

    _identificationNumber
      ..type = idType
      ..value = identificationNum;

    profile
      ..name = name
      ..gender = gender
      ..identificationNo = _identificationNumber;

    try {
      await ClientAuth(Common().channel).signUpUser(email, password, profile);
      context.showSnackBar(message: 'Check your email for confirmation...');
    } on GrpcError catch (e) {
      context.showErrorSnackBar(message: 'Caught error: ${e.message}');
      print(e);
    } catch (e) {
      context.showErrorSnackBar(message: e.toString());
    }
  }

  _addskills(String skill) {
    setState(() {
      profile..skills.insert(0, skill);
      //print(profile.skills);
      //skills.insert(0, skill);
    });
  }

  _deleteSkill(String skill) {
    setState(() {
      profile.skills.removeWhere((element) => element == skill);
    });
  }

  _deleteContact(String contact) {
    setState(() {
      profile.contacts.removeWhere((element) => element.address == contact);
    });
  }

  _addcontactgrpc(String type, String address) {
    // Contact contact2 = Contact();
    // contact2.type = type;
    // contact2.address = address;
    var contact2 = Contact()
      ..address = address
      ..type = type;

    setState(() {
      profile..contacts.insert(0, contact2);
      //print(profile);
      //print(profile);
      //contacts.insert(0, contact2);
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Sign Up'),
          backgroundColor: themeData2().primaryColor),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'We will send you an email for confirmation',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Do not close this page when signing up'),
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                  child: CustomHeadline(heading: 'Email'),
                ),
                CustomHeadline(
                  heading: '*',
                  color: Colors.red,
                )
              ],
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter your email'
                  //hintText: 'Email',
                  ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email...';
                }
                return null;
              },
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                  child: CustomHeadline(heading: 'Password'),
                ),
                CustomHeadline(
                  heading: '*',
                  color: Colors.red,
                )
              ],
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Enter your password',
                helperText: 'Password must have at least 6 characters',
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password...';
                } else if (value.length < 6) {
                  return 'Password must have more than 6 characters...';
                }
                return null;
              },
            ),
            Divider(
                //horizontal line
                color: themeData2().primaryColor,
                height: 30,
                thickness: 2,
                indent: 15,
                endIndent: 15),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                  child: CustomHeadline(heading: 'Name'),
                ),
                CustomHeadline(
                  heading: '*',
                  color: Colors.red,
                )
              ],
            ),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name...';
                }
                return null;
              },
            ),

            // TextFormField(
            //   controller: _genderController,
            //   decoration: const InputDecoration(hintText: 'Gender'),
            // ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                      child: CustomHeadline(heading: 'Gender'),
                    ),
                    CustomHeadline(
                      heading: '*',
                      color: Colors.red,
                    )
                  ],
                ),
                Container(
                  //padding: EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width / 3,
                  // margin: EdgeInsets.fromLTRB(9, 0, 0, 0),
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
                    iconEnabledColor: Theme.of(context).primaryColor,
                    value: _genderController.text,
                    items: listGender.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(
                          //alignment: Alignment.centerRight,
                          value: e,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8, 0, 8),
                  child: CustomHeadline(heading: 'Identification'),
                ),
                CustomHeadline(
                  heading: '*',
                  color: Colors.red,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    iconEnabledColor: Theme.of(context).primaryColor,
                    value: _idTypeController.text,
                    items: idUser.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(
                          value: e,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
            // Divider(
            //     //horizontal line
            //     color: Theme.of(context).primaryColor,
            //     height: 30,
            //     thickness: 2,
            //     indent: 15,
            //     endIndent: 15),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: CustomHeadline(heading: 'Skill'),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text('(Optional)'),
            // ),
            // TextFormField(
            //   controller: _skillController,
            //   decoration: InputDecoration(
            //       border: OutlineInputBorder(),
            //       hintText: 'Add Skills',
            //       //hintText: 'Skill',
            //       suffixIcon: TextButton(
            //         onPressed: () {
            //           if (_skillController.text.length == 0) {
            //             context.showErrorSnackBar(
            //                 message: 'You have not entered any skills..');
            //           } else {
            //             try {
            //               _addskills(_skillController.text);
            //               _skillController.clear();
            //               context.showSnackBar(message: 'Skill added!');
            //               setState(() {
            //                 _isSkillsEmpty(profile.skills);
            //               });
            //             } catch (e) {
            //               context.showErrorSnackBar(
            //                   message: 'Unable to add skill');
            //             }
            //           }
            //         },
            //         child: const Icon(Icons.add),
            //       )),
            // ),
            // //SizedBox(height: 8),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text('Your Skills: '),
            // ),
            // _isSkillsEmpty(profile.skills)
            //     ? Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Text('You have not entered any skills...'),
            //       )
            //     : SizedBox(
            //         height: 60,
            //         child: ListView.builder(
            //           physics: const BouncingScrollPhysics(),
            //           scrollDirection: Axis.horizontal,
            //           shrinkWrap: true,
            //           itemCount: profile.skills.length,
            //           itemBuilder: (context, index) {
            //             return Card(
            //               child: Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Row(
            //                   children: [
            //                     Text(profile.skills[index]
            //                         .toString()
            //                         .capitalize()),
            //                     SizedBox(
            //                       height: 5,
            //                     ),
            //                     IconButton(
            //                         onPressed: () {
            //                           _deleteSkill(
            //                               profile.skills[index].toString());
            //                         },
            //                         icon: Icon(
            //                           Icons.remove_circle_outline,
            //                           color: Colors.red,
            //                         ))
            //                   ],
            //                 ),
            //               ),
            //             );
            //           },
            //         )),
            // Divider(
            //     //horizontal line
            //     color: Theme.of(context).primaryColor,
            //     height: 30,
            //     thickness: 2,
            //     indent: 15,
            //     endIndent: 15),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: CustomHeadline(heading: 'Contact'),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text('(Optional)'),
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextFormField(
            //         controller: _contactController,
            //         decoration: InputDecoration(
            //           border: OutlineInputBorder(),
            //           hintText: 'Add your contacts',
            //           //hintText: 'Contact',
            //         ),
            //         // validator: (value) {
            //         //   if (value == null || value.isEmpty) {
            //         //     return 'Please enter contacts';
            //         //   }
            //         //   return null;
            //         // },
            //       ),
            //     ),
            //     TextButton(
            //       onPressed: () {
            //         if (_contactController.text.length == 0) {
            //           context.showErrorSnackBar(
            //               message: 'You have not entered any contact');
            //         } else {
            //           try {
            //             _addcontactgrpc(_contactControllerType.text,
            //                 _contactController.text);
            //             _contactController.clear();
            //             context.showSnackBar(message: 'Contact Added!');
            //           } catch (e) {
            //             context.showErrorSnackBar(
            //                 message: 'Unable to add contact');
            //           }
            //         }
            //       },
            //       child: Icon(Icons.add),
            //     ),
            //     Container(
            //       //padding: EdgeInsets.all(8),
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(15),
            //           border: Border.all(
            //             color: Theme.of(context).primaryColor,
            //             width: 2,
            //           )),
            //       child: DropdownButton<String>(
            //         underline: Container(
            //           height: 0,
            //         ),
            //         iconEnabledColor: Theme.of(context).primaryColor,
            //         value: _contactControllerType.text,
            //         items: listContactType.map<DropdownMenuItem<String>>((e) {
            //           return DropdownMenuItem<String>(
            //               value: e,
            //               child: Padding(
            //                 padding: const EdgeInsets.symmetric(horizontal: 10),
            //                 child: Text(
            //                   e,
            //                   style: TextStyle(
            //                       color: Theme.of(context).primaryColor,
            //                       fontWeight: FontWeight.bold,
            //                       fontSize: 15),
            //                 ),
            //               ));
            //         }).toList(),
            //         onChanged: (value) {
            //           setState(() {
            //             _contactControllerType.text = value.toString();
            //           });
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text('Your Contacts: '),
            // ),
            // _isContactsEmpty(profile.contacts)
            //     ? Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Text('You have not entered any contacts...'),
            //       )
            //     : SizedBox(
            //         height: 60,
            //         child: ListView.builder(
            //           physics: const BouncingScrollPhysics(),
            //           scrollDirection: Axis.horizontal,
            //           shrinkWrap: true,
            //           itemCount: profile.contacts.length,
            //           itemBuilder: (context, index) {
            //             return Card(
            //               child: Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Row(
            //                   //mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     Column(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(profile.contacts[index].type
            //                             .toString()
            //                             .capitalize()),
            //                         Text(profile.contacts[index].address
            //                             .toString()),
            //                       ],
            //                     ),
            //                     SizedBox(
            //                       height: 5,
            //                     ),
            //                     IconButton(
            //                         onPressed: () {
            //                           _deleteContact(profile
            //                               .contacts[index].address
            //                               .toString());
            //                           //print(contacts[index].address.toString());
            //                         },
            //                         icon: Icon(
            //                           Icons.remove_circle_outline,
            //                           color: Colors.red,
            //                         ))
            //                   ],
            //                 ),
            //               ),
            //             );
            //           },
            //         )),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                // Iterable<String> newSkills;
                // skills.map((e) => return )
                if (_formKey.currentState!.validate()) {
                  _signUpGrpc(
                      _emailController.text,
                      _passwordController.text,
                      _usernameController.text,
                      _genderController.text,
                      _idController.text,
                      _idTypeController.text);
                }
              },
              child: Text(_isLoading ? 'Loading' : 'Sign Up'),
            ),
            // ElevatedButton(
            //     onPressed: (() {
            //       Navigator.of(context).pushReplacementNamed('/navigation');
            //     }),
            //     child: Text('Skip (for developers)'))
          ],
        ),
      ),
    );
  }
}
