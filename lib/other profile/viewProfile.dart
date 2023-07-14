import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../custom widgets/custom_headline.dart';
import '../custom%20widgets/ratingCardDetails1.dart';
import '../custom%20widgets/theme.dart';
import '../db_helpers/client_user.dart';
import '../my_extensions/extension_string.dart';

import '../model/contact.dart';
import '../model/profile.dart';
import '../profile pages/contactIconWidget.dart';
import '../profile pages/emptyCardWidget.dart';
import '../profile pages/listViewContact.dart';

class ViewProfile extends StatefulWidget {
  final String id;
  const ViewProfile({super.key, required this.id});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  late Profile profile;
  late List<String> skills;
  late List<String> email;
  late List<String> phone;
  late List<String> twitter;
  late List<String> whatsapp;

  //late final dynamic contacts = [];

  bool isLoad = true;
  @override
  void initState() {
    getInstance();
    super.initState();
  }

  getInstance() async {
    // profile = await ClientUser(Common().channel).getProfile1(widget.id);
    // TODO: implement get profile
    // print(profile);
    // print('the type is : ' + profile.user.profile.contacts[0].type.toString());
    var myProfile = await ClientUser.getUserProfileById(widget.id);
    skills = [];
    email = [];
    phone = [];
    twitter = [];
    whatsapp = [];
    //print(profile.user.profile.skills);
    for (int i = 0; i < myProfile.skills.length; i++) {
      skills.add(myProfile.skills[i]);
    }
    for (int i = 0; i < myProfile.contacts.length; i++) {
      //print(data['contacts'][i]['type'].toString() == 'Email');
      if (myProfile.contacts[i].contactType.toString() == 'Email') {
        //print("ui");
        email.add(myProfile.contacts[i].value);
      }
      if (myProfile.contacts[i].contactType == ContactType.phone) {
        phone.add(myProfile.contacts[i].value);
      }
      if (myProfile.contacts[i].contactType == ContactType.twitter) {
        twitter.add(myProfile.contacts[i].value);
      }
      if (myProfile.contacts[i].contactType == ContactType.whatsapp) {
        whatsapp.add(myProfile.contacts[i].value);
      }
    }

    //print(contacts);
    setState(() {
      profile = myProfile;
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
        title: const Text('Profile Summary'),
        //backgroundColor: themeData2().primaryColor,
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
                                heading: profile.name.toString().titleCase()),
                            const SizedBox(height: 8),
                            const Text('Gender',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text(profile.gender.name.capitalize(),
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const CustomHeadline(heading: ' Ratings'),
                  // TODO: enable this
                  // RatingCardDetails1(
                  //     isProvider: true,
                  //     userRating: profile.user.rating.asProvider),
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
                ],
              ),
      ),
    );
  }
}
