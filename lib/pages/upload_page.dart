import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool isLoading = false;
  SupabaseClient client = Supabase.instance.client;

  Future fetchFiles() async {
    final List<FileObject> result = await client.storage
        .from('user-images')
        .list(path: client.auth.currentUser!.id);
    List<Map<String, String>> images = [];

    for (var image in result) {
      final getUrl = client.storage
          .from('user-images')
          .getPublicUrl("${client.auth.currentUser!.id}/${image.name}");
      images.add({
        'name': image.name,
        'url': getUrl,
      });
    }
    return images;
  }

  Future<void> deleteFile(String imageName) async {
    try {
      await client.storage.from('user-images').remove([client.auth.currentUser!.id + '/' + imageName]);
      setState(() {

      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting Image')));
    }
  }

  Future uploadFile() async {
    var pickedFile = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (pickedFile != null) {
      setState(() {
        isLoading = true;
      });
      try {
        File file = File(pickedFile.files.first.path!);
        String fileName = pickedFile.files.first.name;
        String uploadedUrl = await client.storage
            .from('user-images')
            .upload("${client.auth.currentUser!.id}/$fileName", file);
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File uploaded successfully')));
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error while uploading file')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Storage'),
      ),
      body: FutureBuilder(
        future: fetchFiles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return const Center(
                child: Text('No image avaliable'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              padding: EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, index) {
                Map imageData = snapshot.data[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.network(
                        imageData['url'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        deleteFile(imageData['name']);
                      },
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ],
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: isLoading
          ? CircularProgressIndicator()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: uploadFile,
            ),
    );
  }
}
