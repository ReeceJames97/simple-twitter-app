import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_twitter_app/screens/sign_in.dart';
import 'package:simple_twitter_app/services/auth_service.dart';
import 'package:simple_twitter_app/utils/colors.dart';
import 'package:simple_twitter_app/utils/strings.dart';
import 'package:simple_twitter_app/utils/toast.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(STRINGS.sign_up),
        automaticallyImplyLeading: false,
        elevation: 8,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ///Lottie
                  Container(
                    child: Lottie.asset('assets/images/twitter.json',
                        width: 100,
                        height: 100,
                        animate: true,
                        repeat: true,
                        fit: BoxFit.fill),
                  ),

                  const SizedBox(height: 20),

                  ///Email
                  TextFormField(
                    controller: emailController,
                    enabled: !isLoading,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: STRINGS.email,
                        prefixIcon: const Icon(Icons.email_outlined)),
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 10),

                  ///Password
                  TextFormField(
                      controller: passwordController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.text,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: STRINGS.password,
                          prefixIcon: const Icon(Icons.key),
                          suffixIcon: IconButton(
                            icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: COLORS.color_tint),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          )),
                      style: const TextStyle(fontSize: 15)),

                  const SizedBox(height: 10),

                  isLoading
                      ? Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(20),
                          child: const CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        )
                      : const SizedBox(),

                  ///Sign Up Btn
                  ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () async {
                            // signUp();
                            signUpWithUsernameAndPwd();
                          },
                    icon: const Icon(Icons.login),
                    label: const Text(STRINGS.sign_up),
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),

                  const SizedBox(height: 10),

                  ///New User Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(STRINGS.already_registered),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => SignIn()),
                              (Route<dynamic> route) => false);

                          // Navigator.pushNamed(context, '/signIn');
                        },
                        child: const Text(
                          STRINGS.sign_in,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUpWithUsernameAndPwd() async {
    String email = emailController.text.toString();
    String password = passwordController.text.toString();

    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      bool isSuccessful = await _authService.signUp(context, email, password);
      if (!isSuccessful) {
        setState(() {
          isLoading = isSuccessful;
        });
      } else {
        Navigator.of(context).pop();
      }
    } else {
      showToast(STRINGS.pls_enter_email_and_psw);
    }
  }
}
