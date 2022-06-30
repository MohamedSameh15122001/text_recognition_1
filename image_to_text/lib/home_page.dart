import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = '';
  // ignore: prefer_typing_uninitialized_variables
  var image;
  Future<File>? imageFile;
  ImagePicker? imagePicker;

  pickImageFromGalary() async {
    PickedFile? pickedFile =
        // ignore: deprecated_member_use
        await imagePicker?.getImage(source: ImageSource.gallery);

    image = File(pickedFile!.path);
    setState(() {
      image;
      performImageLabeling();
    });
  }

  captureImageWithCamera() async {
    PickedFile? pickedFile =
        // ignore: deprecated_member_use
        await imagePicker?.getImage(source: ImageSource.camera);

    image = File(pickedFile!.path);
    setState(() {
      image;
      performImageLabeling();
    });
  }

  performImageLabeling() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(image);

    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();

    VisionText visionText = await recognizer.processImage(firebaseVisionImage);

    result = '';

    setState(() {
      for (TextBlock block in visionText.blocks) {
        // ignore: unused_local_variable
        final String txt = block.text;
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            result += "${element.text} ";
          }
        }
        result += "\n\n";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              width: 100,
            ),
            //result
            Container(
              height: 340,
              width: 250,
              margin: const EdgeInsets.only(
                top: 70,
              ),
              padding: const EdgeInsets.only(
                left: 28,
                bottom: 5,
                right: 18,
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/images/note.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    result,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 20,
                right: 140,
              ),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          'lib/images/pin.png',
                          height: 240,
                          width: 240,
                        ),
                      )
                    ],
                  ),
                  Center(
                    // ignore: deprecated_member_use
                    child: FlatButton(
                        onPressed: () {
                          pickImageFromGalary();
                        },
                        onLongPress: () {
                          captureImageWithCamera();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 25,
                          ),
                          child: image != null
                              ? Image.file(
                                  image,
                                  width: 140,
                                  height: 192,
                                  fit: BoxFit.fill,
                                )
                              : const SizedBox(
                                  width: 240,
                                  height: 200,
                                  child: Icon(
                                    Icons.camera_front,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                ),
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
