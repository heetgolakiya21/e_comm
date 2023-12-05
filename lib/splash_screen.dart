import 'package:e_comm/utility.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  Future loadData() async {
    Utils.prefs = await SharedPreferences.getInstance();

    final bool repeat = Utils.prefs.getBool('log_reg') ?? false;

    await Future.delayed(
      const Duration(milliseconds: 1000),
      () async {
        if (repeat == false) {
          await Navigator.pushReplacementNamed(context, 'login_page');
        } else {
          await Navigator.pushReplacementNamed(context, 'home_page');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "img/logo.png",
          height: MediaQuery.of(context).size.width * 0.7,
        ),
      ),
    );
  }
}
