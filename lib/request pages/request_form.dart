import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({Key? key}) : super(key: key);

  @override
  State<RequestForm> createState() => _RequestFormState();
}

// Future<RequestModel> submitData() async{
//   var response = await http.post(url)
// }

class _RequestFormState extends State<RequestForm> {
  late TextfieldTagsController _controller;
  late double _distanceToField;
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final rateController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var n = 0;
  List reqList = [
    //{'title': '', 'rate': '', 'tag': '', 'location': '', 'description': ''}
    {}
  ];
  //title
  //category
  //rate
  //location
  //description
  void insertData() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
    _controller.dispose();
    titleController.dispose();
    rateController.dispose();
    categoryController.dispose();
    locationController.dispose();
    descriptionController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Request Form'),
          // backgroundColor: Color.fromARGB(255, 127, 17, 224),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                // SizedBox(
                //   height: 20,
                // ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Title'),
                ),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter Title'),
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

                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Category'),
                ),
                TextFieldTags(
                  textfieldTagsController: _controller,
                  //this will show the initial tags https://pub.dev/packages/textfield_tags
                  // initialTags: const [
                  //   'pick',
                  //   'your',
                  //   'favorite',
                  //   'programming',
                  //   'language'
                  // ],
                  textSeparators: const [
                    ' ',
                    ','
                  ], // when user press space or ',', it will enter as a tag
                  letterCase: LetterCase.small,
                  validator: (String tag) {
                    if (tag == 'php') {
                      return 'No, please just no';
                    } else if (_controller.getTags!.contains(tag)) {
                      return 'you already entered that';
                    }
                    return null;
                  },
                  inputfieldBuilder: //build ur own custom  widget
                      (context, tec, fn, error, onChanged, onSubmitted) {
                    return ((context, sc, tags, onTagDelete) {
                      return TextField(
                        controller: tec,
                        focusNode: fn,
                        decoration: InputDecoration(
                          //isDense: true,
                          border: const OutlineInputBorder(
                              // borderSide: BorderSide(
                              //   color: Color.fromARGB(255, 74, 137, 92),
                              //   width: 3.0,
                              // ),
                              ),
                          // focusedBorder: const OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Color.fromARGB(255, 74, 137, 92),
                          //     width: 3.0,
                          //   ),
                          // ),
                          //helperText: 'Enter Categories...',
                          helperStyle: const TextStyle(
                            color: Color.fromARGB(255, 74, 137, 92),
                          ),
                          hintText: _controller.hasTags ? '' : "Enter Category",
                          errorText: error,
                          prefixIconConstraints:
                              BoxConstraints(maxWidth: _distanceToField * 0.74),
                          prefixIcon: tags.isNotEmpty
                              ? SingleChildScrollView(
                                  controller: sc,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: tags.map((String tag) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        color: Color.fromARGB(255, 74, 137, 92),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            child: Text(
                                              '#$tag',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              print("$tag selected");
                                            },
                                          ),
                                          const SizedBox(width: 4.0),
                                          InkWell(
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 14.0,
                                              color: Color.fromARGB(
                                                  255, 233, 233, 233),
                                            ),
                                            onTap: () {
                                              onTagDelete(tag);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList()),
                                )
                              : null,
                        ),
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                      );
                    });
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Location'),
                ),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Location',
                      prefixIcon: Icon(Icons.map)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Description'),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Rate'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: rateController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Rate',
                            helperText: 'Make sure you have enough \$ to pay'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter rate..';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          value.toString();
                          reqList[0][1] = value;
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('\$ time/hour'),
                    ),
                  ],
                ),
                ElevatedButton(
                    // style: OutlinedButton.styleFrom(
                    //   backgroundColor: Colors.black, //<-- SEE HERE
                    // ),
                    //style: ButtonStyle(backgroundColor: ),
                    onPressed: () {
                      // titleController.clear();
                      // rateController.clear();
                      // categoryController.clear();
                      // locationController.clear();
                      // descriptionController.clear();
                      _controller.clearTags();

                      if (_formKey.currentState!.validate()) {
                        //print(reqList[0][1]);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')));
                        //dispose();
                      }
                    },
                    child: const Text('Create Request')),
                // ElevatedButton(
                //     onPressed: () {
                //       print(reqList[0]['Title']);
                //     },
                //     child: const Text('Check List'))
              ],
            ),
          ),
        ));
  }
}
