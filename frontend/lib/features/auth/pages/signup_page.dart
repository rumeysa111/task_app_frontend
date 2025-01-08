import 'package:flutter/material.dart';
import 'package:task_app/features/auth/pages/login_page.dart';

class SignupPage extends StatefulWidget {
    static MaterialPageRoute route()=> MaterialPageRoute(builder: (context)=> const SignupPage());

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void signUpUser() {
    if (formKey.currentState!.validate()) {
      
      //store the user Data,
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: formKey, // Form widget'ı ile formKey ilişkilendiriliyor
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sign Up",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Name",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Name field cannot be empty";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Email",
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    !value.contains("@")) { // Buradaki hatayı da düzelttim
                  return "Email field is invalid";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: "Password",
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    value.trim().length <= 6) {
                  return "password field is invalid";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: signUpUser,
              child: const Text(
                "Sign Up",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(LoginPage.route());
              },
              child: RichText(
                text: TextSpan(
                    text: "Already have an account?  ",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      const TextSpan(
                        text: "Sign in ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ]),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

}
