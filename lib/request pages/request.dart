import 'package:flutter/material.dart';
import 'request_form.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Color.fromARGB(255, 127, 17, 224),
          title: const Text('Request'),
        ),
        body: const Center(
          child: Text('Your request is empty, try adding a request...'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color.fromARGB(255, 127, 17, 224),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RequestForm(),
                ));
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Request'),
        ));
  }
}
