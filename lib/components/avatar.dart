import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testfyp/components/constants.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    super.key,
    required this.imageUrl,
    required this.onUpload,
  });

  final String? imageUrl;
  final void Function(String) onUpload;

  @override
  _AvatarState createState() => _AvatarState();
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
          onPressed: _isLoading ? null : _upload,
          child: const Text('Upload'),
        ),
      ],
    );
  }

  Future<void> _upload() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      await supabase.storage.from('avatars').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: imageFile.mimeType),
          );
      final imageUrlResponse = await supabase.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
      widget.onUpload(imageUrlResponse);
    } on StorageException catch (error) {
      if (mounted) {
        context.showErrorSnackBar(message: error.message);
      }
    } catch (error) {
      if (mounted) {
        context.showErrorSnackBar(message: 'Unexpected error occured');
      }
    }

    setState(() => _isLoading = false);
  }
}
