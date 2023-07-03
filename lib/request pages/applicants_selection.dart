import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../custom widgets/heading2.dart';
import '../custom widgets/theme.dart';
import '../extension_string.dart';
import '../model/profile.dart';

class ApplicantsSelectionList extends StatelessWidget {
  const ApplicantsSelectionList(
      {super.key,
      required this.applicants,
      required this.onSelectProvider,
      required this.onClickProfile});

  final List<Profile> applicants;
  final Function(int index) onSelectProvider;
  final Function(int index) onClickProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Heading2('Applicants'),
          const Text('Select your applicants: '),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: applicants.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: themeData2().elevatedButtonTheme.style,
                        onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(
                                    'Select ${applicants[index].name.toString().titleCase()}?'),
                                content: Text(
                                    '${applicants[index].name.toString().titleCase()} will be your provider.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => onSelectProvider(index),
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            ),
                        // onPressed: () {
                        //   // print(widget.id);
                        //   // print(
                        //   //     widget.applicants[
                        //   //         index]);
                        //   // print(widget.user);

                        child: Text(
                          '${index + 1}) ${applicants[index].name.titleCase()}',
                        )),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: (() => onClickProfile(index)),
                    icon: FaIcon(
                      FontAwesomeIcons.solidCircleQuestion,
                      color: themeData2().secondaryHeaderColor,
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
