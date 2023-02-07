import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();
  final SupabaseClient client = Supabase.instance.client;

  @override
  void dispose() {
    titleController.dispose();
    client.dispose();
    super.dispose();
  }

  Future insertData() async {
    setState(() {
      isLoading = true;
    });
    try {
      String userId = client.auth.currentUser!.id;
      await client.from('todo').insert({
        'task': titleController.text,
        'user_id': userId,
      });
      Navigator.pop(context);
    } catch (e) {
      print("Error $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "ENTER TITLE",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: insertData,
                    child: Text("Create"),
                  )
          ],
        ),
      ),
    );
  }
}
