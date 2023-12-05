import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:e_comm/custom_text_field.dart';
import 'package:e_comm/custom_widget_function.dart';
import 'package:e_comm/themes.dart';
import 'package:e_comm/utility.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _pwd = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _uname = TextEditingController();

  bool _passTxtSts = false;
  final List _error = List.filled(4, null);

  File? image;
  String imgPath = "";

  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      final imageTemp = File(image.path);
      imgPath = image.path;
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future bottomDialoge() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 190,
                decoration: BoxDecoration(
                    color: MyColors.brownAccent,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0))),
                width: (MediaQuery.of(context).size.width * 95.0) / 100.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                              height: 45.0,
                              width: 3.5,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20.0))),
                          Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text("Change Photo",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(fontSize: 22.0)))
                        ])),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: InkWell(
                          onTap: () async {
                            await pickImage(ImageSource.camera);
                            Navigator.pop(context);
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  const Icon(Icons.camera,
                                      size: 30.0, color: Colors.black54),
                                  const SizedBox(width: 10.0),
                                  Text("Camera",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w600))
                                ]),
                                const Icon(Icons.navigate_next_outlined,
                                    size: 30.0, color: Colors.black54)
                              ]),
                        )),
                    const Divider(),
                    const SizedBox(height: 10.0),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: InkWell(
                            onTap: () async {
                              await pickImage(ImageSource.gallery);
                              Navigator.pop(context);
                            },
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    const Icon(Icons.photo_album,
                                        size: 30.0, color: Colors.black54),
                                    const SizedBox(width: 10.0),
                                    Text("Gallery",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w600))
                                  ]),
                                  const Icon(Icons.navigate_next_outlined,
                                      size: 30.0, color: Colors.black54)
                                ]))),
                    const Divider(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  loadData (mp) async {
    await Utils.prefs.setBool(
        'log_reg', true);

    await Utils.prefs
        .setStringList(
        'user_detail',
        <String>[
          mp['user_data']
          ['id'],
          mp['user_data']
          ['uname'],
          mp['user_data']
          ['email'],
          mp['user_data']
          ['phone'],
          mp['user_data']
          ['pwd'],
          mp['user_data']
          ['imageurl'],
        ]);

    await Navigator
        .pushReplacementNamed(
        context,
        'home_page');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushReplacementNamed(context, 'login_page');
        return Future.value();
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("img/register.png"),
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
                    onPressed: () async {
                      await Navigator.pushReplacementNamed(
                          context, 'login_page');
                    },
                    color: Colors.white,
                    iconSize: 35.0,
                    icon: const Icon(Icons.arrow_back_outlined),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
                    child: Text(
                      "Sign up",
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
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 0.0, bottom: 25.0),
                            child: badges.Badge(
                              position: badges.BadgePosition.bottomEnd(),
                              badgeAnimation: const badges.BadgeAnimation.scale(
                                  animationDuration:
                                      Duration(milliseconds: 2000)),
                              badgeContent: InkWell(
                                  onTap: () {
                                    bottomDialoge();
                                  },
                                  child: const CircleAvatar(
                                      radius: 20.0,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.add_a_photo_outlined,
                                          size: 20.0))),
                              child: image == null
                                  ? const CircleAvatar(
                                      radius: 90.0,
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          AssetImage("img/user_icon.png"),
                                    )
                                  : CircleAvatar(
                                      radius: 90.0,
                                      backgroundColor: Colors.white,
                                      backgroundImage: FileImage(image!),
                                    ),
                            ),
                          ),
                          CustomTextField(
                            controller: _uname,
                            labelText: "Username",
                            errorText: _error[0],
                            prefixIcon: const Icon(Icons.person_outlined),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 25.0),
                          CustomTextField(
                            controller: _phone,
                            labelText: "Phone no.",
                            errorText: _error[1],
                            prefixIcon: const Icon(Icons.call_outlined),
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16.0),
                          CustomTextField(
                            controller: _email,
                            labelText: "Email",
                            errorText: _error[2],
                            prefixIcon: const Icon(Icons.email_outlined),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 25.0),
                          CustomTextField(
                            controller: _pwd,
                            labelText: "Password",
                            errorText: _error[3],
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
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 20.0),
                                      child: Text(
                                        "Sign up",
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
                                          String phone = _phone.text;
                                          String email = _email.text;
                                          String pwd = _pwd.text;

                                          setState(() {
                                            _error[0] = null;
                                            _error[1] = null;
                                            _error[2] = null;
                                            _error[3] = null;
                                          });

                                          if (uname.isEmpty) {
                                            setState(() {
                                              _error[0] = "Enter Username";
                                            });
                                          } else if (phone.isEmpty) {
                                            _error[1] = "Enter Phone no.";
                                          } else if (phone.length < 10) {
                                            setState(() {
                                              _error[1] =
                                                  "Enter valid Phone no.";
                                            });
                                          } else if (email.isEmpty) {
                                            setState(() {
                                              _error[2] = "Enter Email";
                                            });
                                          } else if (pwd.isEmpty) {
                                            setState(() {
                                              _error[3] = "Enter Password";
                                            });
                                          } else if (pwd.length < 8) {
                                            setState(() {
                                              _error[3] =
                                                  "Enter at least 8 characters";
                                            });
                                          } else {
                                            CustomWidgetFunction
                                                .loadingIndicatorDialoge(
                                                    context);

                                            // ------------------- Following will be provide by Client.----------------------------
                                            // METHOD TYPE :  POST
                                            // API         :  https://www.google.com/search?q=hindi+new+song&rlz=1C1OPNX_enIN1061IN1061&oq=&aqs=chrome.0.0i3i66i143i362l8.98376762j0j15&sourceid=chrome&ie=UTF-8
                                            // Parameter   :  uname,email,phone,pwd
                                            // Description :  1 means db connected, -1 means not connected etc.

                                            DateTime dt = DateTime.now();
                                            String imgName =
                                                "$uname${dt.year}${dt.month}${dt.day}${dt.hour}${dt.minute}${dt.second}.jpg";

                                            final FormData formData;

                                            if (imgPath != "") {
                                              formData = FormData.fromMap({
                                                'uname': uname,
                                                'email': email,
                                                'phone': phone,
                                                'pwd': pwd,
                                                'imageAvailable': "yes",
                                                'file': await MultipartFile
                                                    .fromFile(imgPath,
                                                        filename: imgName),
                                              });
                                            } else {
                                              formData = FormData.fromMap({
                                                'uname': uname,
                                                'email': email,
                                                'phone': phone,
                                                'pwd': pwd,
                                                'imageAvailable': "no",
                                              });
                                            }

                                            // When we work only with data than use http package. and work with file like image than use dio package.

                                            String api =
                                                "https://viewy-motors.000webhostapp.com/MyPHP/register.php";
                                            final response = await Dio()
                                                .post(api, data: formData);

                                            Navigator.pop(context);

                                            if (response.statusCode == 200) {
                                              Map mp =
                                                  jsonDecode(response.data);

                                              if (mp['database_connectivity_status'] ==
                                                  1) {
                                                if (mp['data_insert_status'] ==
                                                    0) {
                                                  CustomWidgetFunction.snackBar(
                                                      "Data already exists.",
                                                      context);
                                                } else if (mp[
                                                        'img_available_status'] ==
                                                    1) {
                                                  if (mp['img_insert_into_folder_status'] ==
                                                      1) {
                                                    if (mp['data_insert_status'] ==
                                                        1) {
                                                      loadData(mp);
                                                    } else {
                                                      CustomWidgetFunction
                                                          .snackBar(
                                                              "Data not Inserted.",
                                                              context);
                                                    }
                                                  } else {
                                                    CustomWidgetFunction.snackBar(
                                                        "Image not Inserted.",
                                                        context);
                                                  }
                                                } else {
                                                  if (mp['data_insert_status'] ==
                                                      1) {
                                                    loadData(mp);
                                                  } else {
                                                    CustomWidgetFunction
                                                        .snackBar(
                                                            "Data not Inserted.",
                                                            context);
                                                  }
                                                }
                                              } else {
                                                CustomWidgetFunction.snackBar(
                                                    "Database not connected.",
                                                    context);
                                              }
                                            } else if (response.statusCode ==
                                                404) {
                                              CustomWidgetFunction.snackBar(
                                                  "API not run Successfully!",
                                                  context);
                                            } else {
                                              CustomWidgetFunction.snackBar(
                                                  "Server Error! try again.",
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
                              ],
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
        ),
      ),
    );
  }
}
