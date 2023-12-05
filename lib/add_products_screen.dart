import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart' as badges;
import 'package:dio/dio.dart';
import 'package:e_comm/custom_text_field.dart';
import 'package:e_comm/custom_widget_function.dart';
import 'package:e_comm/themes.dart';
import 'package:e_comm/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddProductsPage extends StatefulWidget {
  const AddProductsPage({Key? key}) : super(key: key);

  @override
  State<AddProductsPage> createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  List<String>? userDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userDetails = Utils.prefs.getStringList('user_detail');
  }

  final TextEditingController _pname = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _description = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_outlined,
                              size: 30.0)),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(children: [Text("Add products")])),
                Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
                    child: badges.Badge(
                        position: badges.BadgePosition.bottomEnd(),
                        badgeAnimation: const badges.BadgeAnimation.scale(
                            animationDuration: Duration(milliseconds: 2000)),
                        badgeContent: InkWell(
                            onTap: () async {
                              await bottomDialoge();
                            },
                            child: const CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.add_a_photo_outlined,
                                    size: 20.0))),
                        child: image == null
                            ? Image.asset("img/product_img.png",
                                height: 200.0, width: 200.0, fit: BoxFit.cover)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.file(image!,
                                    height: 200.0,
                                    width: 200.0,
                                    fit: BoxFit.cover),
                              ))),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: CustomTextField(
                    labelText: "Product name",
                    controller: _pname,
                    prefixIcon: const Icon(Icons.add_sharp),
                    keyboardType: TextInputType.name,
                  ),
                ),
                CustomTextField(
                  labelText: "Price",
                  controller: _price,
                  prefixIcon: const Icon(Icons.currency_rupee_outlined),
                  keyboardType: TextInputType.number,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: CustomTextField(
                    labelText: "Description",
                    controller: _description,
                    prefixIcon: const Icon(Icons.description_outlined),
                    keyboardType: TextInputType.text,
                    maxLines: 5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        CustomWidgetFunction.loadingIndicatorDialoge(context);

                        String pname = _pname.text;
                        String price = _price.text;
                        String descr = _description.text;

                        DateTime dt = DateTime.now();
                        String imgName =
                            "$pname${dt.year}${dt.month}${dt.day}${dt.hour}${dt.minute}${dt.second}.jpg";

                        final FormData formData;

                        if (imgPath != "") {
                          formData = FormData.fromMap({
                            'id': userDetails![0],
                            'pname': pname,
                            'price': price,
                            'description': descr,
                            'imageAvailable': "yes",
                            'file': await MultipartFile.fromFile(imgPath,
                                filename: imgName),
                          });
                        } else {
                          formData = FormData.fromMap({
                            'id': userDetails![0],
                            'pname': pname,
                            'price': price,
                            'description': descr,
                            'imageAvailable': "no",
                          });
                        }

                        String api =
                            "https://viewy-motors.000webhostapp.com/MyPHP/add_product.php";
                        Response response =
                            await Dio().post(api, data: formData);

                        Navigator.pop(context);

                        if (response.statusCode == 200) {
                          Map mp = jsonDecode(response.data);

                          if (mp['data_insert_status'] == 1) {
                            CustomWidgetFunction.snackBar(
                                "Product inserted", context);
                          } else {
                            CustomWidgetFunction.snackBar(
                                "Product not inserted", context);
                          }
                        } else {
                          CustomWidgetFunction.snackBar(
                              "Server Error! try again.", context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(200.0, 50.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                      child: Text("OK")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
