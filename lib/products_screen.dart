import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_comm/utility.dart';
import 'package:http/http.dart' as http;
import 'package:e_comm/custom_widget_function.dart';
import 'package:e_comm/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductPage extends StatefulWidget {
  int index;

  ProductPage(this.index);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<String> images = [
    "https://viewy-motors.000webhostapp.com/MyPHP/product_image/Fridge2023819201654.jpg",
    "https://viewy-motors.000webhostapp.com/MyPHP/product_image/Headphones202381920954.jpg",
    "https://viewy-motors.000webhostapp.com/MyPHP/product_image/TV2023819201823.jpg",
  ];

  List<Widget> indicator(length, currentIndex) {
    return List.generate(
      length,
      (index) {
        return Container(
          margin: EdgeInsets.all(3),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              color: currentIndex == index ? Colors.black : Colors.black26,
              shape: BoxShape.circle),
        );
      },
    );
  }

  int activePage = 1;

  List<String>? userDetails;
  String? imgPath;

  bool status = false;
  List lst = [];

  Future loadData() async {
    var url =
        "https://viewy-motors.000webhostapp.com/MyPHP/show_all_product.php";
    var response = await Dio().get(url);

    Map mp = jsonDecode(response.data);
    lst = mp['product_data'];

    print(lst);

    setState(() {
      status = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // scrollController.addListener(() {
    //   if (scrollController.position.userScrollDirection ==
    //       ScrollDirection.forward) {
    //     widget.showNevigation();
    //   } else {
    //     widget.hideNevigation();
    //   }
    // });

    userDetails = Utils.prefs.getStringList('user_detail');
    print("userDetails (SharedPreference) ----------- $userDetails");

    imgPath = userDetails![5];

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.blue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 300,
                child: PageView.builder(
                    itemCount: images.length,
                    pageSnapping: true,
                    onPageChanged: (page) {
                      setState(() {
                        activePage = page;
                      });
                    },
                    itemBuilder: (context, pagePosition) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: Image.network(
                          images[pagePosition],
                          fit: BoxFit.fitHeight,
                        ),
                      );
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: indicator(images.length, activePage),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Earphones"),
                        Row(
                          children: [
                            Text("4.08"),
                            RatingBarIndicator(
                              rating: 2.5,
                              itemCount: 5,
                              itemSize: 30.0,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: MyColors.amber,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [Icon(Icons.tiktok), Text("Boho Decor")],
                    ),
                    Text(
                        "Boho Decor Plant Hanger For Home Wall\nDecoration Macrame Wall Hanging Shelf"),
                    Text("data"),
                    RichText(
                      text: TextSpan(
                        text: "₹41",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: "M.R.P. 48.32"),
                          TextSpan(text: "(17.86%)"),
                        ],
                      ),
                    ),
                    Text("Inclusive of all taxes"),
                    Row(
                      children: [Icon(Icons.discount_outlined), Text("Offers")],
                    ),
                    SizedBox(
                      height: 170.0,
                      width: double.infinity,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            height: 170.0,
                            width: 270.0,
                            margin: EdgeInsets.only(right: 10.0),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border:
                                  Border.all(color: Colors.black, width: 1.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("No Cose EMI"),
                                Text(
                                    "Upto ₹50 EMI interest savings on select Credit card"),
                                Spacer(),
                                Text("2 offers >"),
                              ],
                            ),
                          ),
                          Container(
                            height: 170.0,
                            width: 270.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border:
                                  Border.all(color: Colors.black, width: 1.0),
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Bank offer"),
                                Text(
                                    "Upto ₹50 EMI interest savings on select Credit card"),
                                Spacer(),
                                Text("16 offers >"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text("In stock : 131"),
                    Container(
                      height: 45.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      alignment: Alignment.center,
                      child: Text("Qty : 1"),
                    ),
                    InkWell(
                      onTap: () async {
                        CustomWidgetFunction
                            .loadingIndicatorDialoge(
                            context);

                        var api = Uri.parse(
                            "https://viewy-motors.000webhostapp.com/MyPHP/add_to_cart.php");

                        Map mp = {
                          'pid': lst[widget.index][0],
                          'id': userDetails![0],
                          'pname': lst[widget.index][2],
                          'pimage': lst[widget.index][3],
                          'price': lst[widget.index][4],
                          'description': lst[widget.index][5],
                        };

                        var response =
                        await http.post(api, body: mp);

                        Navigator.pop(context);

                        if (response.statusCode == 200) {
                          Map mp =
                          jsonDecode(response.body);

                          print(mp);
                          print(mp);
                          if (mp['data_exist_status'] ==
                              -1) {
                            if (mp['data_insert_status'] ==
                                1) {
                              await CustomWidgetFunction
                                  .snackBar("Items Added",
                                  context);
                            } else {
                              await CustomWidgetFunction
                                  .snackBar(
                                  "Items not Added",
                                  context);
                            }
                          } else {
                            await CustomWidgetFunction
                                .snackBar(
                                "Items already Added.",
                                context);
                          }
                        } else {
                          await CustomWidgetFunction.snackBar(
                              "API not run Successfully.",
                              context);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(30.0)),
                        alignment: Alignment.center,
                        child: Text("Add to Cart"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(30.0)),
                      alignment: Alignment.center,
                      child: Text("Buy now"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
