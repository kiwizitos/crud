import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo/pages/home_page.dart';
import 'package:todo/pages/start_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://nlmbyuvyktjbgvwyyjrc.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5sbWJ5dXZ5a3RqYmd2d3l5anJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzU2OTg3MDEsImV4cCI6MTk5MTI3NDcwMX0.g6LhqjcZvkCZhEcUsSdOW4zlUhJFWWdeds5o4jWrst8');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Flutter Demo',
      home: AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final SupabaseClient client = Supabase.instance.client;
  User? _user;

  @override
  void initState() {
    _getAuth();
    super.initState();
  }

  // Get current user : supabase.auth.currentUser

  Future<void> _getAuth() async {
    setState(() {
      _user = client.auth.currentUser;
    });
    client.auth.onAuthStateChange.listen((event) {
      setState(() {
        _user = event.session?.user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _user == null ? const StartPage() : HomePage();
  }
}
