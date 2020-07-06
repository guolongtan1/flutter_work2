import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertransport/pages/home/home_page.dart';
import 'package:fluttertransport/pages/home/home_table.dart';
import 'package:fluttertransport/pages/line_chart_page.dart';
import 'package:fluttertransport/pages/simple_table_page.dart';
import 'package:fluttertransport/pages/table_page.dart';
import 'package:fluttertransport/provider/home_provider.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  List<Widget> _pageList = [
    HomePage(),
    LineChartPage(),
    TablePage(),
    SimpleTablePage(),
  ];

  _buildBottomAppBar() {
    Widget iconButton(String string, IconData icon, int index) {
      return InkWell(
        onTap: () {
          _pageController.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        child: Container(
          width: ScreenUtil().setWidth(100),
          height: ScreenUtil().setHeight(115),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: (_currentIndex == index) ? Colors.amber : Colors.white,
                size: 15,
              ),
              Text(string,
                  style: TextStyle(
                      color: (_currentIndex == index)
                          ? Colors.amber
                          : Colors.white))
            ],
          ),
        ),
      );
    }

    return BottomAppBar(
      color: Colors.blue,
      elevation: 12,
      notchMargin: 4.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          iconButton('首页', Icons.home, 0),
          iconButton('趋势图', Icons.timeline, 1),
          iconButton('数据库', Icons.line_weight, 2),
          iconButton('出货表', Icons.dehaze, 3)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pageList,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }
}
