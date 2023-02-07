import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPage extends StatefulWidget {
  const EditPage(this.editData, this.editId, {Key? key}) : super(key: key);
  final String editData;
  final int editId;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();
  SupabaseClient client = Supabase.instance.client;

  @override
  void dispose() {
    titleController.dispose();
    client.dispose();
    super.dispose();
  }

  Future<void> updateData() async {
    if (titleController.text != '') {
      setState(() {
        isLoading = true;
      });
      try {
        await client.from('todo').update({'task': titleController.text}).match(
            {'id': widget.editId});
        Navigator.pop(context);
      } catch (e) {
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
  }

  Future<void> deleteData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await client.from('todo').delete().match({'id': widget.editId});
      Navigator.pop(context);
    } catch (e) {
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
  void initState() {
    titleController.text = widget.editData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
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
                    onPressed: updateData,
                    child: Text("Save Changes"),
                  ),
            Divider(),
            ElevatedButton.icon(
              onPressed: deleteData,
              label: Text("Delete"),
              icon: Icon(Icons.delete),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
