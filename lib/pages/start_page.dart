import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final SupabaseClient client = Supabase.instance.client;

  bool signInLoading = false;
  bool signUpLoading = false;
  bool googleSignInLoading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    client.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    "https://seeklogo.com/images/S/supabase-logo-DCC676FFE2-seeklogo.com.png",
                    height: 150,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                    controller: emailController,
                    decoration: const InputDecoration(label: Text("E-mail")),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                    controller: passwordController,
                    decoration: const InputDecoration(label: Text('Password')),
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  signInLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            final isValid = _formKey.currentState?.validate();

                            if (isValid != true) return;

                            setState(() {
                              signInLoading = true;
                            });
                            try {
                              await client.auth.signInWithPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              setState(() {
                                signInLoading = false;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("An error occurred"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              setState(() {
                                signInLoading = false;
                              });
                            }
                          },
                          child: const Text('Sign In'),
                        ),
                  signUpLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : OutlinedButton(
                          onPressed: () async {
                            final isValid = _formKey.currentState?.validate();

                            if (isValid != true) return;

                            setState(() {
                              signUpLoading = true;
                            });
                            try {
                              await client.auth.signUp(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Success! Email send."),
                                ),
                              );
                              setState(() {
                                signUpLoading = false;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("An error occurred"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              setState(() {
                                signUpLoading = false;
                              });
                            }
                          },
                          child: const Text("Sign Up"),
                        ),
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(padding: EdgeInsets.all(15), child: Text('OR'),),
                      Expanded(child: Divider()),
                    ],
                  ),
                  googleSignInLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : OutlinedButton.icon(
                          onPressed: () async {
                            setState(() {
                              googleSignInLoading = true;
                            });
                            try {
                              await client.auth.signInWithOAuth(Provider.google,
                                  redirectTo: kIsWeb
                                      ? null
                                      : 'io.supabase.myflutterapp://login-callback');
                              setState(() {
                                googleSignInLoading = false;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Sign Up Failed'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              setState(() {
                                googleSignInLoading = false;
                              });
                            }
                          },
                          icon: Image.network(
                            "https://img.icons8.com/color/480/google-logo.png",
                            height: 20,
                          ),
                          label: Text('Connect With Google'),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
