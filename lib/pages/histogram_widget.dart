import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class HistogramWidget extends StatefulWidget {
  @override
  _HistogramWidgetState createState() => _HistogramWidgetState();
}

class _HistogramWidgetState extends State<HistogramWidget> {
  String _company;
  int _weight;
  //点击柱状图触发的函数
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    setState(() {
      //改变两个显示的数值
      _company = selectedDatum.first.datum.year;
      _weight = selectedDatum.first.datum.sales;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text("年份：$_company"),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text("数值：$_weight"),
                ),
              )
            ],
          ),
          Container(
            width: double.infinity,
            height: 200.0,
            child: charts.BarChart(
              //通过下面获取数据传入
              ChartFlutterBean.createSampleData(),
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
    );
  }
}


class OrdinalSales {
  final String name;
  final int weight;

  OrdinalSales(this.name, this.weight);
}


class ChartFlutterBean {

  static List<charts.Series<OrdinalSales, String>> createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.name,
        measureFn: (OrdinalSales sales, _) => sales.weight,
        data: data,
      )
    ];
  }
}
