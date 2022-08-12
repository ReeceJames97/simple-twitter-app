import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_twitter_app/screens/sign_up.dart';
import 'package:simple_twitter_app/services/auth_service.dart';
import 'package:simple_twitter_app/utils/colors.dart';
import 'package:simple_twitter_app/utils/strings.dart';
import 'package:simple_twitter_app/utils/toast.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  final AuthService _authService = AuthService();
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
        title: const Text(STRINGS.sign_in),
        automaticallyImplyLeading: false,
        elevation: 8,
      ),
      body: Center(
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
                          // signIn();
                          signInWithUsernameAndPwd();
                        },
                  icon: const Icon(Icons.login),
                  label: const Text(STRINGS.sign_in),
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
                    const Text(STRINGS.not_registered),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()),
                            (Route<dynamic> route) => false);
                      },
                      child: const Text(
                        STRINGS.sign_up,
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
    );
  }

  void signInWithUsernameAndPwd() async {
    String email = emailController.text.toString();
    String password = passwordController.text.toString();

    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      bool isSuccessful = await _authService.signIn(context, email, password);

      if (!isSuccessful) {
        setState(() {
          isLoading = isSuccessful;
        });
        // Navigator.pushNamed(context, '/');
      } else {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/');
      }
    } else {
      showToast(STRINGS.pls_enter_email_and_psw);
    }
  }
}
