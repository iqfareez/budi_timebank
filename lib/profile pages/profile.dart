import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../custom%20widgets/customHeadline.dart';
import '../custom%20widgets/theme.dart';
import '../extension_string.dart';

import '../auth pages/account_page.dart';
import '../model/contact.dart';
import '../model/profile.dart';
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
  late Future<Profile> futureProfile;
  List<String> skills = [];
  List<String> email = [];
  List<String> phone = [];
  List<String> twitter = [];
  List<String> whatsapp = [];

  @override
  void initState() {
    super.initState();
    futureProfile = getProfile();
  }

  Future<Profile> getProfile() async {
    final userUid = FirebaseAuth.instance.currentUser!.uid;

    var snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();

    var snapshotData = snapshot.data()!['profile'];

    var profile = Profile.fromJson(snapshotData);

    return profile;
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
                      getProfile();
                    },
                  ));
            },
          )
        ],
        title: const Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder(
            future: futureProfile,
            builder: (context, AsyncSnapshot<Profile> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              skills = snapshot.data!.skills;
              for (int i = 0; i < snapshot.data!.contacts.length; i++) {
                if (snapshot.data!.contacts[i].contactType ==
                    ContactType.email) {
                  email.add(snapshot.data!.contacts[i].value);
                }
                if (snapshot.data!.contacts[i].contactType ==
                    ContactType.phone) {
                  phone.add(snapshot.data!.contacts[i].value);
                }
                if (snapshot.data!.contacts[i].contactType ==
                    ContactType.twitter) {
                  twitter.add(snapshot.data!.contacts[i].value);
                }
                if (snapshot.data!.contacts[i].contactType ==
                    ContactType.email) {
                  email.add(snapshot.data!.contacts[i].value);
                }
              }
              return Column(
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
                                heading:
                                    snapshot.data!.name.toString().titleCase()),
                            const SizedBox(height: 10),
                            Text(
                                snapshot.data!.identification.identificationType
                                    .name
                                    .toString()
                                    .capitalize(),
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text(snapshot.data!.identification.value,
                                style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 10),
                            const Text('Gender',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text(
                                snapshot.data!.gender.name
                                    .toString()
                                    .capitalize(),
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const CustomHeadline(heading: ' Ratings'),
                  // RatingCardDetails1(
                  //     isProvider: true,
                  //     userRating: profile.user.rating.asProvider),
                  // RatingCardDetails1(
                  //     isProvider: false,
                  //     userRating: profile.user.rating.asRequestor),
                  const CustomHeadline(heading: ' Skill List'),
                  skills.isEmpty
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
                      email.isEmpty
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
                      phone.isEmpty
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
                      twitter.isEmpty
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
                      whatsapp.isEmpty
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
              );
            }),
      ),
    );
  }
}
