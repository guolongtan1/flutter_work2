import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:fluttertransport/pages/home/home_table.dart';
import 'package:fluttertransport/provider/home_provider.dart';
import 'package:fluttertransport/services/service_method.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  Future _futureBuilderFuture;
  String _company;
  double _weight;
  //点击柱状图触发的函数
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    setState(() {
      //改变两个显示的数值
      _company = selectedDatum.first.datum.name;
      _weight = selectedDatum.first.datum.weight;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureBuilderFuture = _getHomeContent();
  }

  var _data = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Center(
            child: Text(
              '首页',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        body: FutureBuilder(
          future: _futureBuilderFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              return ListView(
                children: <Widget>[
                  /*Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("7天内总吨数"),
                      Text(data["passTotalWeight_7day"].toString()),
                    ],
                  ),
                ),*/
                  Container(
                    child: Center(
                      child: Text(
                        "七天内运输量排名前五的公司",
                        style: TextStyle(
                          color: Colors.lightBlue[900],
                          fontSize: 30,
                          height: 2,
                          background: new Paint()..color = Colors.white10,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                    "公司：${(_company == null) ? '点击柱状图获取' : _company}",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 16)),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                    "重量(吨)：${(_weight == null) ? '0' : _weight.toStringAsFixed(0)}",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 16)),
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 200.0,
                          child: charts.BarChart(
                            //通过下面获取数据传入
                            data["companies"],
                            //配置项，以及设置触发的函数
                            selectionModels: [
                              charts.SelectionModelConfig(
                                type: charts.SelectionModelType.info,
                                changedListener: _onSelectionChanged,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        "近期历史数据统计表",
                        style: TextStyle(
                          color: Colors.lightBlue[900],
                          fontSize: 28,
                          height: 2,
                          background: new Paint()..color = Colors.white10,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Hometable(),
                  ),
                  /*Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("7天内经过总车数"),
                      Text(data["carsNum"].toString())
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("7天内每辆车的平均重量"),
                      Text(data["avgWeight"].toStringAsFixed(3).toString()),
                    ],
                  ),
                )*/
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Future _getHomeContent() async {
    var data = {};
    await request("fiveCompany", "7 day").then((val) {
      print(val);
      List<OrdinalSales> companies = [];
      for (var item in val) {
        OrdinalSales s = new OrdinalSales(item[0], item[1]);
        companies.add(s);
      }
      data["companies"] = [
        new charts.Series<OrdinalSales, String>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (OrdinalSales sales, _) => sales.name,
          measureFn: (OrdinalSales sales, _) => sales.weight,
          data: companies,
        )
      ];
    });

    return data;
  }

  bool get wantKeepAlive => true;
}

class OrdinalSales {
  final String name;
  final double weight;

  OrdinalSales(this.name, this.weight);
}
