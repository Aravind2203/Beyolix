import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'dart:core';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  static const routeName = '/get-started';

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  File? selectedImage;
  var responseString;
  var responseData;
  var drugName;

  void getImage() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    ) as PickedFile;

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    } else if(pickedFile == null){
      return;
    }
  }

  Future getResult(File imageFile) async {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse("http://207.154.218.143/uploadfile/");

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);

    var response = await request.send();

    responseData = await response.stream.toBytes();
    responseString = String.fromCharCodes(responseData);
    print(responseString);

    return responseString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          'Get Started',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      image: DecorationImage(
                          image: selectedImage == null
                              ? const AssetImage(
                                  'assets/images/defaultimage.png')
                              : FileImage(selectedImage!) as ImageProvider)),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 40,
                width: 120,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    getImage();
                  },
                  child: const Text(
                    'Choose File',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              selectedImage == null
                  ? Container(
                      child: const Center(
                        child: Text(
                          'Please select an image',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      margin: const EdgeInsets.all(20),
                      child: FutureBuilder(
                          future: getResult(selectedImage!),
                          builder: (context, snapshot) {
                            try {
                              if (snapshot.hasData) {
                                var data = json.decode(snapshot.data);
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data['symptoms'].length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Drug name -",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              " ${data['symptoms'][index]['drug']}",
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            )
                                          ],
                                        ),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: (data['symptoms'][index]
                                                    ['symptoms'])
                                                .length,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                children: [
                                                  const Text(
                                                    "Symptom -",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    "${data['symptoms'][index]['symptoms'][index]}",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  )
                                                ],
                                              );
                                            }),
                                        const SizedBox(height: 6),
                                      ],
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return const Center(
                                    child: Text(
                                        'Some Error has been occured while processing.!!'));
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            } catch (error) {
                              return Column(
                                children: [
                                  Image.asset('assets/images/cartoon-sad.png'),
                                  const SizedBox(height: 8),
                                  const Text('An error occured'),
                                ],
                              );
                            }
                          }),
                    )
            ]),
      ),
    );
  }
}
