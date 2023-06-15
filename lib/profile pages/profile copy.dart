import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testfyp/components/constants.dart';
import 'package:testfyp/auth%20pages/account_page.dart';
import 'package:testfyp/custom%20widgets/customHeadline.dart';
import 'package:testfyp/extension_string.dart';
import 'package:testfyp/profile%20pages/listViewContact.dart';

import '../custom widgets/ratingCardDetails1.dart';
import '../custom widgets/theme.dart';
import 'contactIconWidget.dart';
import 'emptyCardWidget.dart';

//import 'package:testfyp/splash_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
// AS ENUM (
//   'requestor',
//   'provider'
// );

  late String _username = '';
  late String _identificationNumber = '';
  late String _identificationTypeNumber = '';
  late String _gender = '';
  late final userId;
  late dynamic _userRating;
  late double _userRatingProvider = 0;
  late double _userRatingRequestor = 0;
  // late dynamic user;

  final String _avatarUrl = 'asset/girl.png';
  late List<dynamic> skills;
  late List<dynamic> email1;
  late List<dynamic> phone1;
  late List<dynamic> twitter1;
  late List<dynamic> whatsapp1;
  var _loading = true;

  @override
  void initState() {
    super.initState();
    userId = supabase.auth.currentUser!.id;
    supabase.auth.onAuthStateChange.listen((data) {});
    Future.delayed(Duration.zero, _getProfile);
    // _getRating();
  }

  bool isEmpty(stuff) {
    if (stuff.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  _getRating() async {
    // _userRating = await ClientRating(Common().channel)
    //     .getResponseRating('recipient', userId);
    //print(_userRating.toString());
    //calculate rating
    //map((m) => m.ratings['value']!).average;
    for (int i = 0; i < _userRating.ratings.length; i++) {
      if (_userRating.ratings[i].rating_for == 'provider') {
        _userRatingProvider += _userRating.ratings[i].value;
        // _userRatingProvider.add(_userRating.ratings[i]);
      } else if (_userRating.ratings[i].rating_for == 'requestor') {
        _userRatingRequestor += _userRating.ratings[i].value;
        // _userRatingRequestor.add(_userRating.ratings[i]);
      }
      // _userCalculatedRating =
      //     _userCalculatedRating + _userRating.ratings[i].value;
      //print(_userCalculatedRating);
    }
    print('provider: $_userRatingProvider');
    print('requestor: $_userRatingProvider');
    //print(_userCalculatedRating / _userRating.ratings.length);
    //_userCalculatedRating = _userRating.print(_userCalculatedRating.toString());
    //print(_userRating.ratings[2].value);
  }

  Future<void> _getProfile() async {
    skills = [];
    email1 = [];
    phone1 = [];
    twitter1 = [];
    whatsapp1 = [];
    setState(() {
      _loading = true;
    });

    try {
      // final userId = supabase.auth.currentUser!.id;
      final data = await supabase
          .from('profiles')
          .select()
          .eq('user_id', userId)
          .single() as Map;
      //print(data['contacts'].length);
      _username = (data['name'] ?? '') as String;
      _identificationNumber =
          (data['identification_no']['value'] ?? '') as String;
      _identificationTypeNumber =
          (data['identification_no']['type'] ?? '') as String;
      // _website = (data['website'] ?? '') as String;
      // _avatarUrl = (data['avatar_url'] ?? '') as String;
      // _identificationNumber = (data['identification_no'] ?? '') as String;
      _gender = (data['gender'] ?? '') as String;
      for (int i = 0; i < data['skills'].length; i++) {
        if (data['skills'][i] != '') {
          skills.add(data['skills'][i]);
        }
      }
      for (int i = 0; i < data['contacts'].length; i++) {
        //print(data['contacts'][i]['type'].toString() == 'Email');
        if (data['contacts'][i]['type'].toString() == 'Email') {
          //print("ui");
          email1.add(data['contacts'][i]['address'].toString());
        }
        if (data['contacts'][i]['type'].toString() == 'Phone') {
          phone1.add(data['contacts'][i]['address']);
        }
        if (data['contacts'][i]['type'].toString() == 'Twitter') {
          twitter1.add(data['contacts'][i]['address']);
        }
        if (data['contacts'][i]['type'].toString() == 'WhatsApp') {
          whatsapp1.add(data['contacts'][i]['address']);
        }
      }

      //print(email);
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
      //print(error.message.toString());
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected exception occured');
    }

    setState(() {
      _loading = false;
    });
  }

  // bool isAvatarEqual() {
  //   if (_avatarUrl == 'asset/girl.png') {
  //     return true;
  //   } else
  //     return false;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 167, 44),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountPage(),
                  )).then((value) => setState(
                    () {
                      _getProfile();
                    },
                  ));
            },
          )
        ],
        title: const Text('Profile Page'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: themeData1().primaryColor,
                          width: 3,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomHeadline(heading: _username),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                    '${_identificationTypeNumber.capitalize()}: '),
                                Text(_identificationNumber),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('Gender: '),
                                Text('${_gender.capitalize}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const CustomHeadline(heading: ' Rating'),
                  RatingCardDetails1(
                      isProvider: true,
                      userRating: _userRatingProvider.toString()),
                  RatingCardDetails1(
                      isProvider: false,
                      userRating: _userRatingRequestor.toString()),
                  // RatingCardWidget(
                  //   isProvider: true,
                  //   title: 'Provider Rating',
                  //   iconRating: Icons.emoji_people,
                  //   userRating: _userRating,
                  // ),
                  // RatingCardWidget(
                  //   isProvider: false,
                  //   title: 'Requestor Rating',
                  //   iconRating: Icons.handshake,
                  //   userRating: _userRating,
                  // ),
                  const CustomHeadline(heading: ' Skill List'),
                  isEmpty(skills)
                      ? const Text(' You have not entered any skills')
                      : SizedBox(
                          height: 50,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: skills.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(skills[index]
                                          .toString()
                                          .capitalize())),
                                ),
                              );
                            },
                          )),
                  const CustomHeadline(heading: ' Contact List'),
                  Row(
                    children: [
                      ContactWidget(
                          containerColor: themeData1().primaryColor,
                          theIcon: const Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          iconColor: Colors.white),
                      isEmpty(email1)
                          ? const emptyCardContact()
                          : CustomListviewContact(contactList: email1)
                    ],
                  ),
                  Row(
                    children: [
                      ContactWidget(
                          containerColor: themeData1().primaryColor,
                          theIcon: const Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          iconColor: Colors.white),
                      isEmpty(phone1)
                          ? const emptyCardContact()
                          : CustomListviewContact(contactList: phone1)
                    ],
                  ),
                  Row(
                    children: [
                      ContactWidget(
                          containerColor: themeData1().primaryColor,
                          theIcon: const FaIcon(
                            FontAwesomeIcons.twitter,
                            color: Colors.white,
                          ),
                          iconColor: Colors.white),
                      isEmpty(twitter1)
                          ? const emptyCardContact()
                          : CustomListviewContact(contactList: twitter1)
                    ],
                  ),
                  Row(
                    children: [
                      ContactWidget(
                          containerColor: themeData1().primaryColor,
                          theIcon: const FaIcon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.white,
                          ),
                          iconColor: Colors.white),
                      isEmpty(whatsapp1)
                          ? const emptyCardContact()
                          : CustomListviewContact(contactList: whatsapp1)
                    ],
                  ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                ],
              ),
            ),
    );
  }
}
