import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_comm/custom_widget_function.dart';
import 'package:e_comm/products_screen.dart';
import 'package:e_comm/themes.dart';
import 'package:e_comm/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AllProductsPage extends StatefulWidget {
  // final VoidCallback showNevigation;
  // final VoidCallback hideNevigation;

  const AllProductsPage({
    Key? key,
    // required this.showNevigation,
    // required this.hideNevigation,
  }) : super(key: key);

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  List<String>? userDetails;
  String? imgPath;

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // scrollController.removeListener(() {
    //   if (scrollController.position.userScrollDirection ==
    //       ScrollDirection.forward) {
    //     widget.showNevigation();
    //   } else {
    //     widget.hideNevigation();
    //   }
    // });
  }

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

  ScrollController scrollController = ScrollController();

  void handlePaymentErrorResponse(PaymentFailureResponse response){
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 3.0, 5.0, 0.0),
        child: RefreshIndicator(
          onRefresh: () {
            return loadData();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              status
                  ? Expanded(
                      child: GridView.builder(
                        controller: scrollController,
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
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ProductPage(index);
                                  },
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: MyColors.grey, width: 0.3)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            loadingBuilder:
                                                (BuildContext context,
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
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.red,
                                                  backgroundColor:
                                                      Colors.white70,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                        TextDecorationStyle
                                                            .solid,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    decorationColor:
                                                        Colors.black),
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
                                                      fontWeight:
                                                          FontWeight.bold)),
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
                                          lst[index][5],
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      OutlinedButton(
                                          onPressed: () {
                                            Razorpay razorpay = Razorpay();
                                            var options = {
                                              'key': "rzp_test_HWcfCqP0xuKojL",
                                              'amount': 100 * 100,
                                              'name': "GHJ Corp.",
                                              'description': "Fine T-Shirt",
                                              'retry': {'enabled': true, 'max_count': 3},
                                              'send_sms_hash': true,
                                              'prefill': {'contact': "8849203464", 'email': "heetgolakiaa9611@gmail.com"},
                                              'external': {
                                                'wallets': ['paytm']
                                              }
                                            };
                                            razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                                            razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                                            razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
                                            razorpay.open(options);
                                          },
                                          child: Text("Buy now")),
                                      IconButton(
                                          onPressed: () async {
                                            CustomWidgetFunction
                                                .loadingIndicatorDialoge(
                                                    context);

                                            var api = Uri.parse(
                                                "https://viewy-motors.000webhostapp.com/MyPHP/add_to_cart.php");

                                            Map mp = {
                                              'pid': lst[index][0],
                                              'id': userDetails![0],
                                              'pname': lst[index][2],
                                              'pimage': lst[index][3],
                                              'price': lst[index][4],
                                              'description': lst[index][5],
                                            };

                                            var response =
                                                await http.post(api, body: mp);

                                            Navigator.pop(context);

                                            if (response.statusCode == 200) {
                                              Map mp =
                                                  jsonDecode(response.body);

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
                                          icon: Icon(
                                              Icons.favorite_border_outlined))
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
            ],
          ),
        ),
      ),
    );
  }
}
