import 'package:e_comm/themes.dart';
import 'package:e_comm/utility.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String>? userDetails;
  String? imgPath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userDetails = Utils.prefs.getStringList('user_detail');

    imgPath = userDetails![5];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.black,
                iconSize: 30.0,
                icon: const Icon(Icons.arrow_back_outlined),
              ),
              Card(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                shadowColor: Colors.black54,
                color: MyColors.brownAccent,
                elevation: 10.0,
                child: Container(
                  height: 150.0,
                  width: double.infinity,
                  padding: EdgeInsets.all(10.0),
                  // decoration: BoxDecoration(
                  //   color: MyColors.brownAccent,
                  //   borderRadius: BorderRadius.circular(20.0),
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(userDetails![1]),
                            Text(userDetails![2]),
                            Text(userDetails![3]),
                            Container(
                              height: 50.0,
                              alignment: Alignment.centerLeft,
                              child: Text("View Profile"),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(color: Colors.black54, thickness: .3),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child:  userDetails![5] == "no"
                            ? Image.asset("img/product_img.png")
                            :Image.network(
                          "https://viewy-motors.000webhostapp.com/MyPHP/$imgPath",
                          height: 130.0,
                          width: 130.0,
                          frameBuilder: (context, child, frame,
                              wasSynchronouslyLoaded) {
                            return child;
                          },
                          loadingBuilder:
                              (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                          errorBuilder: (context, error, stackTrace) =>
                          const Text("Failed to load Image!"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 60.0,
                            margin: EdgeInsets.only(top: 10.0, right: 10.0),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: MyColors.brownAccent,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.favorite_border_outlined),
                                Text("Likes")
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 60.0,
                            margin: EdgeInsets.only(top: 10.0, right: 10.0),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: MyColors.brownAccent,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.wallet_outlined),
                                Text("Payments")
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 60.0,
                            margin: EdgeInsets.only(top: 10.0),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: MyColors.brownAccent,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.settings_outlined),
                                Text("Settings")
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await Navigator.pushNamed(
                              context, 'addProducts_page');
                        },
                        child: Text("Add Products"),),ElevatedButton(
                        onPressed: () async {
                          await Utils.prefs.remove('user_detail');
                          await Utils.prefs.remove('log_reg');
                          Navigator.pop(context);
                          await Navigator.pushReplacementNamed(context, 'login_page');
                        },
                        child: Text("Logout"),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
