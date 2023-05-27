import 'package:flutter/material.dart';
import '../custom widgets/custom_headline.dart';
import '../custom widgets/heading2.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({Key? key}) : super(key: key);

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  final rateServiceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color.fromARGB(255, 127, 17, 224),
        title: const Text('Service Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Heading2('Title'),
            const Text('This is the title'),
            const Heading2('Requestor'),
            const Text('John Smith'),
            const Heading2('Category'),
            const Text('Programming, Python, uhh'),
            const Heading2('Location'),
            const Text('IIUM'),
            const Heading2('Description'),
            const Text('This is just a test'),
            const SizedBox(
              height: 15,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomHeadline('Rate'),
                        CustomHeadline('\$1 time/hour'),
                      ],
                    ),
                    TextFormField(
                      controller: rateServiceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: 'Enter Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      // onFieldSubmitted: (value) {
                      //   reqList[0]['Title'] = value;
                      // },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: (() {
                              //Navigator.pop(context, 'Rate');
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')));
                            }),
                            child: const Text('Bid')),
                        TextButton(
                            onPressed: (() {
                              Navigator.pop(context, 'Cancel');
                            }),
                            child: const Text('Cancel'))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
