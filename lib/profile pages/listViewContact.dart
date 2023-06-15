import 'package:flutter/material.dart';

import '../custom widgets/theme.dart';

class CustomListviewContact extends StatefulWidget {
  final List<dynamic> contactList;
  const CustomListviewContact({super.key, required this.contactList});

  @override
  State<CustomListviewContact> createState() => _CustomListviewContactState();
}

class _CustomListviewContactState extends State<CustomListviewContact> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50,
        //width: d,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          // physics:
          //     const BouncingScrollPhysics(),
          itemCount: widget.contactList.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: themeData3().primaryColor,
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    widget.contactList[index].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
