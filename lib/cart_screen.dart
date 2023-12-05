import 'dart:convert';
import 'package:e_comm/custom_widget_function.dart';
import 'package:e_comm/themes.dart';
import 'package:e_comm/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<String>? userDetails;
  List lst = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userDetails = Utils.prefs.getStringList('user_detail');

    loadData();
  }

  bool status = false;

  double sum = 0.00;

  Future loadData() async {
    var api = Uri.parse(
        "https://viewy-motors.000webhostapp.com/MyPHP/show_cart.php?id=${userDetails![0]}");
    var response = await http.get(api);

    if (response.statusCode == 200) {
      Map mp = jsonDecode(response.body);

      lst = mp['cart_product_data'];

      print(lst[0][5]);

      // for(int i=0; i<lst.length; i++) {
      //   sum = sum + lst[i][5];
      // }

      setState(() {
        status = true;
      });
    } else {
      await CustomWidgetFunction.snackBar("API not run Successfully.", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.blue,
        elevation: 0.0,
        toolbarHeight: 50.0,
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
      body: Column(
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
                              border:
                                  Border.all(color: MyColors.grey, width: 0.3)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              lst[index][4] == "no"
                                  ? Image.asset("img/product_img.png")
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Image.network(
                                        "https://viewy-motors.000webhostapp.com/MyPHP/${lst[index][4]}",
                                        height: 230,
                                        width: double.infinity,
                                        fit: BoxFit.fitHeight,
                                        filterQuality: FilterQuality.high,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
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
                                      lst[index][3],
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
                                              text: "₹${lst[index][5]}",
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
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                decorationColor: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        text: "In Stock :",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0),
                                        children: [
                                          TextSpan(
                                              text: "17 left",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    RatingBarIndicator(
                                      rating: 2.5,
                                      itemCount: 5,
                                      itemSize: 30.0,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: MyColors.amber,
                                      ),
                                    ),
                                    Text(
                                      lst[index][6],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  OutlinedButton(
                                      onPressed: () {}, child: Text("Buy now")),
                                  IconButton(
                                      onPressed: () async {
                                        CustomWidgetFunction
                                            .loadingIndicatorDialoge(context);

                                        var api = Uri.parse(
                                            "https://viewy-motors.000webhostapp.com/MyPHP/delete_cart_product.php?id=${userDetails![0]}&pid=${lst[index][1]}");
                                        var response = await http.get(api);

                                        Navigator.pop(context);

                                        if (response.statusCode == 200) {
                                          Map mp = jsonDecode(response.body);

                                          if (mp['product_deleted'] == 1) {
                                            CustomWidgetFunction.snackBar(
                                                "Product removed", context);
                                          } else {
                                            await CustomWidgetFunction.snackBar(
                                                "Product not removed. Try again!",
                                                context);
                                          }
                                        } else {
                                          await CustomWidgetFunction.snackBar(
                                              "API not run Successfully.",
                                              context);
                                        }
                                      },
                                      icon: Icon(Icons.delete_outline))
                                ],
                              )
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
          Text("Your pay Amount : ${sum.toDouble()}")
        ],
      ),
    );
  }
}
