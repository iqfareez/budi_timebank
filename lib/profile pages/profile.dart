import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/constants.dart';
import '../auth%20pages/account_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _username = '';
  late String _website = '';
  late String _matric = '';
  late String _gender = '';
  late String _desc = '';
  final bool _redirecting = false;
  late final StreamSubscription<AuthState> _authStateSubscription;

  String _avatarUrl = 'asset/girl.png';
  var _loading = false;

  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single() as Map;
      _username = (data['username'] ?? '') as String;
      _website = (data['website'] ?? '') as String;
      _avatarUrl = (data['avatar_url'] ?? '') as String;
      _matric = (data['matricNum'] ?? '') as String;
      _gender = (data['gender'] ?? '') as String;
      _desc = (data['description'] ?? '') as String;
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected exception occured');
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    //_getProfile();
    supabase.auth.onAuthStateChange.listen((data) {
      // final AuthChangeEvent event = data.event;

      // if (_redirecting) return;
      // final session = data.session;
      // if (event == AuthChangeEvent.passwordRecovery) {
      //   // handle signIn
      //   Navigator.of(context).pushReplacementNamed('/passwordReset');
      // }
      // if (session != null) {
      //   _redirecting = true;
      //   Navigator.of(context).pushReplacementNamed('/dashboard');
      // }
    });
    Future.delayed(Duration.zero, _getProfile);
  }

  bool isAvatarEqual() {
    if (_avatarUrl == 'asset/girl.png') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color.fromARGB(255, 127, 17, 224),
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 3,
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          //color: Colors.green,
                          //border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20)),
                      height: 150,
                      width: 150,
                      padding: const EdgeInsets.all(5),
                      child: isAvatarEqual()
                          ? Container(
                              padding: const EdgeInsets.all(7),
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 127, 17, 224),
                                  shape: BoxShape.circle),
                              child: const CircleAvatar(
                                backgroundColor: Colors.grey,
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(7),
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 127, 17, 224),
                                  shape: BoxShape.circle),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(_avatarUrl),
                              ),
                            )),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 219, 216, 233),
                          //border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _username,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Matric Id: $_matric'),
                          const SizedBox(
                            height: 8,
                          ),
                          Text('Gender: $_gender')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Flexible(
              //description
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 219, 216, 233),
                    //border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20)),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Text(
                        'Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text(_desc),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Skilled in',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
                  //style: Theme.of(context).textTheme.headline1,
                  ),
            ),
            Flexible(
              flex: 1,
              child: SizedBox(
                height: 50,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: const [
                    Card(
                      elevation: 5,
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Cooking'),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Programming with fast typing'),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('This is another skill that you should'),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Kill me senpai'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
                //horizontal line
                height: 10,
                thickness: 2,
                indent: 30,
                endIndent: 30),
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  const Flexible(
                    flex: 1,
                    child: Card(
                      elevation: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text('Rating',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Text('4.5')
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Card(
                      elevation: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(_website,
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const Text('2')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
