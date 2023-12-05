import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_comm/themes.dart';
import 'package:e_comm/utility.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({Key? key}) : super(key: key);

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  bool status = false;
  List lst = [];

  Future loadData() async {
    List<String>? userDetails;
    userDetails = Utils.prefs.getStringList('user_detail');

    var url =
        "https://viewy-motors.000webhostapp.com/MyPHP/show_seller_product.php?id=${userDetails![0]}";
    var response = await Dio().get(url);

    Map mp = jsonDecode(response.data);
    lst = mp['product_data'];

    print(lst);

    setState(() {
      status = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.grey,
        elevation: 0.0,
        toolbarHeight: 65.0,
        title: SearchBar(
          constraints: BoxConstraints.loose(const Size.fromHeight(50.0)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(color: Colors.white, width: 1.3),
            ),
          ),
          leading: Icon(Icons.search_outlined, color: MyColors.grey),
          backgroundColor: MaterialStatePropertyAll(Colors.grey[200]),
          hintText: "Search",
          hintStyle: const MaterialStatePropertyAll(
              TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
          elevation: const MaterialStatePropertyAll(10.0),
          textStyle: const MaterialStatePropertyAll(
            TextStyle(fontSize: 17.0),
          ),
          padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 13.0, vertical: 0.0)),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, 'profile_page');
            },
            icon: const Icon(
              Icons.person_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return loadData();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            status
                ? Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
                        childAspectRatio: 2 / 5,
                      ),
                      itemCount: lst.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                    color: MyColors.grey, width: 0.3)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                lst[index][3] == "no"
                                    ? Image.asset("img/product_img.png")
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        child: Image.network(
                                          "https://viewy-motors.000webhostapp.com/MyPHP/${lst[index][3]}",
                                          height: 230,
                                          width: double.infinity,
                                          fit: BoxFit.fitHeight,
                                          filterQuality: FilterQuality.high,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Container(
                                              height: 180.0,
                                              width: 180.0,
                                              alignment: Alignment.center,
                                              child: CircularProgressIndicator(
                                                color: Colors.red,
                                                backgroundColor: Colors.white70,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Text("Failed!"),
                                        ),
                                      ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        lst[index][2],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Roboto"),
                                      ),
                                      RichText(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          text: "-75% ",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500),
                                          children: [
                                            TextSpan(
                                                text: "₹${lst[index][4]}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 20.0)),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          text: "M.R.P.: ",
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 13.0),
                                          children: [
                                            TextSpan(
                                              text: "₹888.00",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w700,
                                                  decorationStyle:
                                                      TextDecorationStyle.solid,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  decorationColor:
                                                      Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        lst[index][5],
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Lottie.asset(
                      "anim/loading.json",
                      fit: BoxFit.fill,
                      height: 100.0,
                      width: 100.0,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
