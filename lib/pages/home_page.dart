import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo/pages/create_page.dart';
import 'package:todo/pages/upload_page.dart';

import 'edit_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SupabaseClient client = Supabase.instance.client;
  late Stream<List<Map<String, dynamic>>> _readStream;

  @override
  void initState() {
    _readStream = client
        .from('todo')
        .stream(primaryKey: ['id'])
        .eq('user_id', client.auth.currentUser!.id)
        .order('id', ascending: false);
    super.initState();
  }

  Future<List> fetchData() async {
    final result = await client
        .from('todo')
        .select()
        .eq('user_id', client.auth.currentUser!.id);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UploadPage(),
                ),
              );
            },
            icon: Icon(Icons.upload_file),
          ),
          IconButton(
            onPressed: () async {
              await client.auth.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _readStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Center(
                child: Text('The List is empty'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var data = snapshot.data[index];

                return ListTile(
                  title: Text(data['task']),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditPage(data['task'], data['id']),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePage(),
            ),
          );
        },
      ),
    );
  }
}
