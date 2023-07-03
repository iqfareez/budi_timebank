import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'constants.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    super.key,
    required this.imageUrl,
    required this.onUpload,
  });

  final String? imageUrl;
  final void Function(String) onUpload;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
          Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 127, 17, 224),
                shape: BoxShape.circle),
            child: const Center(
              child: Text('No Image'),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 127, 17, 224),
                shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                widget.imageUrl!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () async {
                  // show dialog to select destination where to pick image
                  ImageSource? imgSource = await showDialog(
                      context: context,
                      builder: (_) {
                        return SimpleDialog(
                          children: [
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context, ImageSource.camera);
                              },
                              child: const Text('Camera'),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context, ImageSource.gallery);
                              },
                              child: const Text('Gallery'),
                            ),
                          ],
                        );
                      });

                  // if user cancel picking image
                  if (imgSource == null) return;

                  // pick image from selected source
                  final picker = ImagePicker();
                  final imageFile = await picker.pickImage(
                    source: imgSource,
                    maxWidth: 300,
                    maxHeight: 300,
                  );

                  // if user cancel picking image
                  if (imageFile == null) return;

                  setState(() => _isLoading = true);

                  // upload to storage bucket
                  await _upload(File(imageFile.path));
                },
          child: const Text('Upload'),
        ),
      ],
    );
  }

  Future<void> _upload(File imageFile) async {
    try {
      final userUid = FirebaseAuth.instance.currentUser!.uid;
      final imgReferences =
          FirebaseStorage.instance.ref('avatars/$userUid.png');
      await imgReferences.putFile(imageFile);
      var urlImage = await imgReferences.getDownloadURL();

      widget.onUpload(urlImage);
    } on FirebaseException catch (error) {
      if (mounted) {
        context.showErrorSnackBar(message: error.message.toString());
      }
    } catch (error) {
      if (mounted) {
        context.showErrorSnackBar(message: 'Unexpected error occured');
      }
    }

    setState(() => _isLoading = false);
  }
}
