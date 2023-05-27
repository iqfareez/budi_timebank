import 'package:flutter/material.dart';

class CustomOngoingTask extends StatefulWidget {
  //const CustomOngoingTask({Key? key}) : super(key: key);
  final List<dynamic> list;
  const CustomOngoingTask(this.list, {super.key});

  @override
  State<CustomOngoingTask> createState() => _CustomOngoingTaskState();
}

class _CustomOngoingTaskState extends State<CustomOngoingTask> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      //width: 80,
      //margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        itemCount: widget.list.length,
        //shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          return Text(widget.list[index]);
        },
        // children: [
        //   Text('Service 1'),
        //   Text('Service 2'),
        //   Text('Service 3'),
        //   Text('Service 4'),
        //   Text('Service 5'),
        //   Text('Service 6'),
        //   Text('Service 7'),
        // ],
      ),
    );
  }
}
