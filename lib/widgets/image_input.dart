import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage, {Key? key}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storeImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile != null) {
      setState(() {
        _storeImage = File(imageFile.path);
      });
      final appDir = await syspath.getApplicationDocumentsDirectory();
      final imageFileName = path.basename(imageFile.path);
      final savedImage = await _storeImage!.copy(
        '${appDir.path}/$imageFileName',
      );
      widget.onSelectImage(savedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          child: _storeImage != null
              ? Image.file(
                  _storeImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          height: 8.0,
        ),
        TextButton.icon(
          icon: Icon(Icons.camera),
          onPressed: _takePicture,
          label: Text(
            'Take Picture',
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
