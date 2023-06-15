import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../bin/client_user.dart';
import '../bin/common.dart';
import '../components/constants.dart';
import '../custom%20widgets/customHeadline.dart';
import '../custom%20widgets/ratingCardDetails1.dart';
import '../custom%20widgets/theme.dart';
import '../extension_string.dart';

import '../auth pages/account_page.dart';
import '../profile pages/contactIconWidget.dart';
import '../profile pages/emptyCardWidget.dart';
import '../profile pages/listViewContact.dart';

class ProfilePage extends StatefulWidget {
  final bool isMyProfile;
  const ProfilePage({super.key, required this.isMyProfile});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late dynamic profile;
  late List<String> skills;
  late List<dynamic> email;
  late List<dynamic> phone;
  late List<dynamic> twitter;
  late List<dynamic> whatsapp;

  //late final dynamic contacts = [];

  bool isLoad = true;
  @override
  void initState() {
    Future.delayed(Duration.zero, getInstance);
    // TODO: implement initState
    super.initState();
  }

  getInstance() async {
    final user = supabase.auth.currentUser!.id;
    profile = await ClientUser(Common().channel).getProfile1(user);

    //print(profile);
    // print('the type is : ' + profile.user.profile.contacts[0].type.toString());
    skills = [];
    email = [];
    phone = [];
    twitter = [];
    whatsapp = [];
    //print(profile.user.profile.skills);
    for (int i = 0; i < profile.user.profile.skills.length; i++) {
      skills.add(profile.user.profile.skills[i]);
    }
    for (int i = 0; i < profile.user.profile.contacts.length; i++) {
      //print(data['contacts'][i]['type'].toString() == 'Email');
      if (profile.user.profile.contacts[i].type.toString() == 'Email') {
        //print("ui");
        email.add(profile.user.profile.contacts[i].address.toString());
      }
      if (profile.user.profile.contacts[i].type.toString() == 'Phone') {
        phone.add(profile.user.profile.contacts[i].address.toString());
      }
      if (profile.user.profile.contacts[i].type.toString() == 'Twitter') {
        twitter.add(profile.user.profile.contacts[i].address.toString());
      }
      if (profile.user.profile.contacts[i].type.toString() == 'WhatsApp') {
        whatsapp.add(profile.user.profile.contacts[i].address.toString());
      }
    }

    //print(contacts);
    setState(() {
      isLoad = false;
    });
    //print(skills);
  }

  bool isEmpty(stuff) {
    if (stuff.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData2().primaryColor,
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
                      getInstance();
                    },
                  ));
            },
          )
        ],
        title: const Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: isLoad
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: themeData2().primaryColor,
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
                            CustomHeadline(
                                heading: profile.user.profile.name
                                    .toString()
                                    .titleCase()),
                            const SizedBox(height: 10),
                            Text(
                                profile.user.profile.identificationNo.type
                                    .toString()
                                    .capitalize(),
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text(
                                '${profile.user.profile.identificationNo.value}',
                                style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 10),
                            const Text('Gender',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text(
                                profile.user.profile.gender
                                    .toString()
                                    .capitalize(),
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const CustomHeadline(heading: ' Ratings'),
                  RatingCardDetails1(
                      isProvider: true,
                      userRating: profile.user.rating.asProvider),
                  // RatingCardDetails1(
                  //     isProvider: false,
                  //     userRating: profile.user.rating.asRequestor),
                  const CustomHeadline(heading: ' Skill List'),
                  isEmpty(skills)
                      ? const Text('No skills entered')
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
                          containerColor: themeData3().primaryColor,
                          theIcon: const Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          iconColor: Colors.white),
                      isEmpty(email)
                          ? const emptyCardContact()
                          : CustomListviewContact(contactList: email)
                    ],
                  ),
                  Row(
                    children: [
                      ContactWidget(
                          containerColor: themeData3().primaryColor,
                          theIcon: const Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          iconColor: Colors.white),
                      isEmpty(phone)
                          ? const emptyCardContact()
                          : CustomListviewContact(contactList: phone)
                    ],
                  ),
                  Row(
                    children: [
                      ContactWidget(
                          containerColor: themeData3().primaryColor,
                          theIcon: const FaIcon(
                            FontAwesomeIcons.twitter,
                            color: Colors.white,
                          ),
                          iconColor: Colors.white),
                      isEmpty(twitter)
                          ? const emptyCardContact()
                          : CustomListviewContact(contactList: twitter)
                    ],
                  ),
                  Row(
                    children: [
                      ContactWidget(
                          containerColor: themeData3().primaryColor,
                          theIcon: const FaIcon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.white,
                          ),
                          iconColor: Colors.white),
                      isEmpty(whatsapp)
                          ? const emptyCardContact()
                          : CustomListviewContact(contactList: whatsapp)
                    ],
                  ),
                  // RatingCardWidget(
                  //   isProvider: true,
                  //   title: 'Provider Rating',
                  //   iconRating: Icons.emoji_people,
                  //   userRating: profile.user.rating.asProvider,
                  // ),
                  // RatingCardWidget(
                  //   isProvider: false,
                  //   title: 'Requestor Rating',
                  //   iconRating: Icons.handshake,
                  //   userRating: profile.user.rating.asRequestor,
                  // ),
                ],
              ),
      ),
    );
  }
}
