import 'package:flutter/material.dart';
import 'package:fluttertransport/services/service_method.dart';

class SimpleTablePage extends StatefulWidget {
  @override
  SimpleTablePageState createState() {
    return new SimpleTablePageState();
  }
}

class SimpleTablePageState extends State<SimpleTablePage> {
  var selectTime;
  Future _re;
  @override
  void initState() {
    super.initState();
    _re = _getTable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("订单表"),
        ),
        body: FutureBuilder(
          future: _re,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              return BodyWidget(data: data);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Future _getTable() async {
    List<List<Table>> tables = [[], []];
    await request("simpleTable", '0 day').then((val) {
      for (var item in val) {
        Table t = new Table(
            company: item[0].toString(),
            store_type: item[1],
            netweight: item[2].toStringAsFixed(2).toString());
        tables[0].add(t);
      }
    });
    _getTableByMonth(tables[1]);
    return tables;
  }

  Future _getTableByMonth(table) async {
    await request("simpleTable1", '1 month').then((val) {
      for (var item in val) {
        Table t = new Table(
            company: item[0].toString(),
            store_type: item[1],
            netweight: item[2].toStringAsFixed(2).toString());
        table.add(t);
      }
    });
    return table;
  }
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
  var selectTime;
  var table;
  @override
  void initState() {
    // TODO: implement initState
    table = widget.data[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        DropdownButtonHideUnderline(
          child: new DropdownButton(
            //设置这个value之后,选中对应位置的item，
            //再次呼出下拉菜单，会自动定位item位置在当前按钮显示的位置处
            hint: Text("点击选择时间"),
            value: selectTime,
            items: <DropdownMenuItem<String>>[
              DropdownMenuItem(
                child: Text(
                  "当天",
                  style: TextStyle(
                      color: selectTime == "0 day" ? Colors.red : Colors.grey),
                ),
                value: "0 day",
              ),
              DropdownMenuItem(
                child: Text(
                  "当月",
                  style: TextStyle(
                      color:
                          selectTime == "1 month" ? Colors.red : Colors.grey),
                ),
                value: "1 month",
              ),
            ],
            onChanged: (T) {
              setState(() {
                selectTime = T;
                if (T == '0 day') {
                  table = widget.data[0];
                } else if (T == '1 month') {
                  table = widget.data[1];
                }
              });
            },
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
