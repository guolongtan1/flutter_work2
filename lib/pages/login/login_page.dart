import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertransport/routers/application.dart';
import 'package:fluttertransport/services/service_method.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  String name;
  String pass;
  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _appBar() {
    return AppBar(
      leading: Center(
        child: Text(
          "登录",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildPhoneEdit() {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      child: TextField(
        controller: phoneController,
        decoration: InputDecoration(
          hintText: '请输入手机号',
        ),
        maxLength: 11,
        maxLines: 1,
        keyboardType: TextInputType.phone,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  Widget _buildPasswordEdit() {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      child: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(hintText: '请输入密码'),
        maxLines: 1,
        maxLength: 11,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView(
      children: <Widget>[
        _buildPhoneEdit(),
        _buildPasswordEdit(),
        _buildBtn(),
      ],
    );
  }

  Widget _buildBtn() {
    return Container(
      margin: EdgeInsets.all(30),
      width: 300,
      height: 50,
      child: RaisedButton(
        color: Colors.blue,
        onPressed: () {
          setState(() {
            _getUser(phoneController.text).then((val) {
              if (passwordController.text != val) {
                Fluttertoast.showToast(
                    msg: '密码不正确，请重试',
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16);
              } else {
                Application.router
                    .navigateTo(context, "/index", clearStack: true);
              }
            });
          });
        },
        child: Text(
          '登录',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        child: _buildList(),
      ),
    );
  }

  Future _getUser(String name) async {
    var passwd;
    await request("login", name).then((val) {
      passwd = val[0][0];
    });
    return passwd;
  }
}
