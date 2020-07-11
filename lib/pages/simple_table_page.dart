import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertransport/services/service_method.dart';

import '../services/service_method.dart';

class SimpleTablePage extends StatefulWidget {
  @override
  SimpleTablePageState createState() {
    return new SimpleTablePageState();
  }
}

class SimpleTablePageState extends State<SimpleTablePage> {
  Future _re;
  @override
  void initState() {
    super.initState();
    _re = _getTableByDay(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("出货表"),
        ),
        body: FutureBuilder(
          future: _re,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Table> data = snapshot.data;
              return BodyWidget(data: data);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
Future _getTableByDay(DateTime time) async {
  List<Table> tables = [];
  var timeS = '${time.year}-${time.month}-${time.day}';
  await request("simpleTable_byday", timeS).then((val) {
    for (var item in val) {
      Table t = new Table(
          company: item[0].toString(),
          store_type: item[1],
          netweight: item[2].toStringAsFixed(2).toString());
      tables.add(t);
    }
  });
  return tables;
}
Future _getTableByMonth(DateTime time) async {
  List<Table> tables = [];

  var timeS = '${time.year}-${time.month}-${time.day}';
  await request("simpleTable_bymonth", timeS).then((val) {
    for (var item in val) {
      Table t = new Table(
          company: item[0].toString(),
          store_type: item[1],
          netweight: item[2].toStringAsFixed(2).toString());
      tables.add(t);
    }
  });
  return tables;
}
class Table {
  String company;
  String store_type;
  String netweight;

  Table({this.company, this.netweight, this.store_type});
}

class BodyWidget extends StatefulWidget {
  var data;
  BodyWidget({Key key, @required this.data}) : super(key: key);
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  List<Table> table;
  String dateType;
  DateTime _time;
  @override
  void initState() {
    // TODO: implement initState
    dateType = "天";
    table = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: RaisedButton(
            child: Text(_time != null ? "${_time.year}年${_time.month}月${_time.day}日" : "点击选择日期"
            ),
            onPressed: () async {
              await showDatePicker(
                context: context,
                initialDate: _time == null ? DateTime.now():_time,
                firstDate: DateTime.parse("2020-06-07"),
                lastDate: DateTime.now()
              ).then((dateTime) {
                if(dateTime != null) {
                    _time = dateTime;
                    if(dateType == '天') {
                      _getTableByDay(_time).then((val) {
                        setState(() {
                          table = val;
                        });
                      });
                    } else if(dateType == '月') {
                      _getTableByMonth(_time).then((val) {
                        setState(() {
                          table = val;
                        });
                      });
                    }
                }
              });
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: DropdownButtonHideUnderline(
            child: new DropdownButton(
              //设置这个value之后,选中对应位置的item，
              //再次呼出下拉菜单，会自动定位item位置在当前按钮显示的位置处
              hint: Text("点击选择时间"),
              value: dateType,
              items: <DropdownMenuItem<String>>[
                DropdownMenuItem(
                  child: Text(
                    "当天",
                    style: TextStyle(
                        color: dateType == "天" ? Color.fromRGBO(181, 22, 0, 1) : Colors.grey),
                  ),
                  value: "天",
                ),
                DropdownMenuItem(
                  child: Text(
                    "当月",
                    style: TextStyle(
                        color:
                        dateType == "月" ? Color.fromRGBO(181, 22, 0, 1) : Colors.grey),
                  ),
                  value: "月",
                ),
              ],
              onChanged: (T) {
                dateType = T;
                if (T == '天') {
                  _getTableByDay(_time).then((val) {
                    setState(() {
                      table = val;
                    });
                  });
                } else if (T == '月') {
                  _getTableByMonth(_time).then((val) {
                    setState(() {
                      table = val;
                    });
                  });
                }
              },
            ),
          ),
        ),
        Container(
          child: bodyData(table),
        ),
      ],
    );
  }

  Widget bodyData(List<Table> data) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
              onSelectAll: (b) {},
              columnSpacing: 15,
              //sortColumnIndex: 0,
              sortAscending: true,
              columns: <DataColumn>[
                DataColumn(
                  label: Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Text("收货单位"),
                    alignment: Alignment.centerLeft,
                  ),
                  numeric: false,
                  onSort: (i, b) {
                    print("$i $b");
                    setState(() {
                      data.sort((a, b) => a.company.compareTo(b.company));
                    });
                  },
                ),
                DataColumn(
                  label: Container(
                    child: Text("货名"),
                    alignment: Alignment.centerLeft,
                    width: 80,
                  ),
                  numeric: false,
                  onSort: (i, b) {
                    print("$i $b");
                    setState(() {
                      data.sort((a, b) => a.store_type.compareTo(b.store_type));
                    });
                  },
                ),
                DataColumn(
                  label: Container(
                    child: Text("总重量(吨)"),
                    alignment: Alignment.centerLeft,
                    width: 70,
                  ),
                  numeric: false,
                  onSort: (i, b) {
                    print("$i $b");
                    setState(() {
                      data.sort((a, b) => a.netweight.compareTo(b.netweight));
                    });
                  },
                ),
              ],
              rows: data
                  .map(
                    (table) => DataRow(
                      cells: [
                        DataCell(
                          Container(
                              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(table.company)),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Container(
                            width: 80,
                            alignment: Alignment.centerLeft,
                            child: Text(table.store_type),
                          ),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                        DataCell(
                          Container(
                            width: 300,
                            alignment: Alignment.centerLeft,
                            child: Text(table.netweight),
                          ),
                          showEditIcon: false,
                          placeholder: false,
                        ),
                      ],
                    ),
                  )
                  .toList()),
        ),
      );
}
