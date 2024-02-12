
import 'package:assesment/const/color_const.dart';
import 'package:assesment/const/txt_field.dart';
import 'package:assesment/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController mailCtr = TextEditingController();
  TextEditingController pwdCtr = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.headerColor,
        elevation: 0,
        leading: const Icon(
          CupertinoIcons.back,
          color: Colors.black,
        ),
      ),
      backgroundColor: ColorConst.headerColor,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Container(
                width: size.width,
                padding: const EdgeInsets.symmetric(horizontal: 15, ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white
                ),
                margin: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: ColorConst.headerColor,
                          child: Image.asset(
                            'assets/login_icon.png'
                          ),
                        ),
                        const SizedBox(height: 5,),
                        const Text(
                            'Log In',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                          ),
                        ),
                        const SizedBox(height: 25,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15
                              ),
                            ),
                            const SizedBox(height: 10,),
                            TxtField(
                              ctr: mailCtr,
                              hintTxt: 'Enter mail',
                              txtInputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 18,),
                            const Text(
                              'Password',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15
                              ),
                            ),
                            const SizedBox(height: 10,),
                            TxtField(
                              ctr: pwdCtr,
                              icon: Icons.lock,
                              txtInputType: TextInputType.visiblePassword,
                              hintTxt: 'Enter password',
                            ),

                          ],
                        ),
                        const SizedBox(height: 18,),
                        Container(
                          width: size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Text(
                                'Forget Password?',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14
                                ),
                                textAlign: TextAlign.end,
                              ),
                              SizedBox(width: 15,),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22,),
                        InkWell(
                          onTap: () async {
                            //check if it's null or not
                            if(isValid()){
                              //sign in with firebase
                                try {
                                  final user = await _auth.signInWithEmailAndPassword(
                                      email: mailCtr.text, password: pwdCtr.text);
                                  print('====$user');
                                  if (user != null) {
                                    Get.to(()=>const HomeScreen());
                                    // Navigator.pushNamed(context, 'home_screen');
                                  }else{

                                  }
                                } catch (e) {
                                  var snackBar = const SnackBar(content: Text('Please register the email'));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  print(e);
                                }
                            }
                          },
                          child: Container(
                            width: size.width/1.1,
                            padding: const EdgeInsets.symmetric(vertical: 15, ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: ColorConst.btnColor
                            ),
                            child: const Text(
                              'Log In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30,),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25,),
              InkWell(
                onTap: () async {
                  //check if it's null or not
                  if(isValid()){
                    //sign up with firebase
                    try {
                      final newUser = await _auth.createUserWithEmailAndPassword(
                          email: mailCtr.text, password: pwdCtr.text);
                      if (newUser != null) {
                        var snackBar = const SnackBar(content: Text('User registrated successfully'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Get.to(()=>const HomeScreen());
                        // Navigator.pushNamed(context, 'home_screen');
                      }
                    } catch (e) {
                      var snackBar = const SnackBar(content: Text('Something went wrong'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print(e);
                    }
                  }

                },
                child: Container(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Do not have account?',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        'Sign up',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkIfEmailInUse(String emailAddress) async {
    try {
      // Fetch sign-in methods for the email address
      final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailAddress);
      print(list);
      // In case list is not empty
      if (list.isNotEmpty) {
        // Return true because there is an existing
        // user using the email address
        return true;
      } else {
        // Return false because email adress is not in use
        return false;
      }
    } catch (error) {
      // Handle error
      // ...
      return true;
    }
  }

  bool isValidEmail(String mail) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(mail);
  }

  bool isValid(){
    if(mailCtr.text.trim()==''){
      var snackBar = const SnackBar(content: Text('Please enter email'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }else if(isValidEmail(mailCtr.text.trim())==false){
      var snackBar = const SnackBar(content: Text('Please enter valid email'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }else if(pwdCtr.text.trim()==''){
      var snackBar = const SnackBar(content: Text('Please enter password'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return true;
  }
}
