import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_comm/custom_text_field.dart';
import 'package:e_comm/custom_widget_function.dart';
import 'package:e_comm/themes.dart';
import 'package:e_comm/utility.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _pwd = TextEditingController();
  final TextEditingController _uname = TextEditingController();

  bool _passTxtSts = false;
  final List _error = List.filled(2, null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("img/login.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {},
                  color: Colors.white,
                  iconSize: 35.0,
                  icon: const Icon(Icons.arrow_back_outlined),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 25.0, bottom: 5.0),
                  child: Text(
                    "Welcome\nBack",
                    style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      fontSize: 35.0,
                      fontFamily: "EduSABeginner",
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomTextField(
                            controller: _uname,
                            labelText: "Email or Phone",
                            errorText: _error[0],
                            prefixIcon: const Icon(Icons.person_outlined),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 25.0),
                          CustomTextField(
                            controller: _pwd,
                            labelText: "Password",
                            errorText: _error[1],
                            prefixIcon: const Icon(Icons.security_outlined),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  if (_passTxtSts == false) {
                                    setState(() {
                                      _passTxtSts = true;
                                    });
                                  } else {
                                    setState(() {
                                      _passTxtSts = false;
                                    });
                                  }
                                },
                                icon: _passTxtSts
                                    ? const Icon(Icons.visibility_outlined)
                                    : const Icon(
                                        Icons.visibility_off_outlined)),
                            obscureText: _passTxtSts,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            enableSuggestions: false,
                          ),
                          TextButton(
                              onPressed: () {},
                              child: const Text("Forgot Password",
                                  style: TextStyle(color: Colors.red))),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: MyColors.grey,
                                  radius: 27.5,
                                  child: IconButton(
                                    onPressed: () async {
                                      String uname = _uname.text;
                                      String pwd = _pwd.text;

                                      setState(() {
                                        _error[0] = null;
                                        _error[1] = null;
                                      });

                                      if (uname.isEmpty) {
                                        setState(() {
                                          _error[0] =
                                              "Enter Email or Phone no.";
                                        });
                                      } else if (pwd.isEmpty) {
                                        setState(() {
                                          _error[1] = "Enter Password";
                                        });
                                      } else {
                                        CustomWidgetFunction
                                            .loadingIndicatorDialoge(context);

                                        String api =
                                            "https://viewy-motors.000webhostapp.com/MyPHP/login.php?uname=$uname&pwd=$pwd";
                                        final response = await Dio().get(api);

                                        Navigator.pop(context);

                                        if (response.statusCode == 200) {
                                          Map mp = jsonDecode(response.data);

                                          if (mp['database_connectivity_status'] ==
                                              1) {
                                            if (mp['data_exist_status'] == 1) {
                                              await Utils.prefs
                                                  .setBool('log_reg', true);

                                              await Utils.prefs.setStringList(
                                                  'user_detail', <String>[
                                                mp['user_data']['id'],
                                                mp['user_data']['uname'],
                                                mp['user_data']['email'],
                                                mp['user_data']['phone'],
                                                mp['user_data']['pwd'],
                                                mp['user_data']['imageurl'],
                                              ]);

                                              await Navigator
                                                  .pushReplacementNamed(
                                                      context, 'home_page');
                                            } else {
                                              CustomWidgetFunction.snackBar(
                                                  "Data not exists.", context);
                                            }
                                          } else {
                                            CustomWidgetFunction.snackBar(
                                                "Database not connected.",
                                                context);
                                          }
                                        } else {
                                          CustomWidgetFunction.snackBar(
                                              "API not run Successfully!",
                                              context);
                                        }
                                      }
                                    },
                                    color: Colors.white,
                                    iconSize: 27.5,
                                    tooltip: "Next",
                                    icon: const Icon(
                                        Icons.arrow_forward_outlined),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Sign in with"),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    "img/google.png",
                                    height: 30.0,
                                    width: 30.0,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Image.asset("img/facebook.png",
                                    height: 30.0),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                        style: Theme.of(context).textTheme.titleSmall),
                    TextButton(
                      onPressed: () async {
                        await Navigator.pushReplacementNamed(
                            context, 'register_page');
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
