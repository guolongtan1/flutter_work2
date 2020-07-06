import 'package:flutter/material.dart';
import 'package:fluttertransport/services/service_method.dart';

class Hometable extends StatefulWidget {
  @override
  HometableState createState() {
    return new HometableState();
  }
}

class HometableState extends State<Hometable> {
  Future _re;
  @override
  void initState() {
    super.initState();
    _re = _getTable();
  }

  Widget bodyData(List<Table> data) => DataTable(
      onSelectAll: (b) {},
      columnSpacing: 15,
      //sortColumnIndex: 0,
      sortAscending: true,
      columns: <DataColumn>[
        DataColumn(
          label: Text("时间"),
          numeric: false,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              data.sort((a, b) => a.day.compareTo(b.day));
            });
          },
        ),
        DataColumn(
          label: Text("总重量(吨)"),
          numeric: false,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              data.sort((a, b) => a.company.compareTo(b.company));
            });
          },
        ),
        DataColumn(
          label: Text("总车次"),
          numeric: false,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              data.sort((a, b) => a.licenseplate.compareTo(b.licenseplate));
            });
          },
        ),
        DataColumn(
          label: Text("平均净重(吨)"),
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
                  Text(table.day),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(table.company),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(table.licenseplate),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(table.netweight),
                  showEditIcon: false,
                  placeholder: false,
                ),
              ],
            ),
          )
          .toList());

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      future: _re,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Table> data = snapshot.data;
          return Container(
            child: bodyData(data),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }

  Future _getTable() async {
    var data = {};
    await request("hometable", " ").then((val) {
      data["tw1"] = val[0][0] / 1000;
      data["tt1"] = val[0][1];
      data["aw1"] = val[0][2] / 1000;
      data["tw2"] = val[1][0] / 1000;
      data["tt2"] = val[1][1];
      data["aw2"] = val[1][2] / 1000;
      data["tw3"] = val[2][0] / 1000;
      data["tt3"] = val[2][1];
      data["aw3"] = val[2][2] / 1000;
      data["tw4"] = val[3][0] / 1000;
      data["tt4"] = val[3][1];
      data["aw4"] = val[3][2] / 1000;
      data["tw5"] = val[4][0] / 1000;
      data["tt5"] = val[4][1];
      data["aw5"] = val[4][2] / 1000;
      //print(data);
      //for(var item in val) {
      //Table t = new Table(company: item[0].toString(), licenseplate: item[1].toString(), netweight: item[2].toStringAsFixed(3).toString(),day: );
      //tables.add(t);
      //}
    });
    List<Table> tables = [
      Table(
          company: formatStr(data["tw1"].toString()),
          licenseplate: data['tt1'].toString(),
          netweight: formatStr(data["aw1"].toStringAsFixed(3).toString()),
          day: "当天"),
      Table(
          company: formatStr(data["tw2"].toString()),
          licenseplate: data["tt2"].toString(),
          netweight: formatStr(data["aw2"].toStringAsFixed(3).toString()),
          day: "本周"),
      Table(
          company: formatStr(data["tw3"].toString()),
          licenseplate: data["tt3"].toString(),
          netweight: formatStr(data["aw3"].toStringAsFixed(3).toString()),
          day: "本月"),
      Table(
          company: formatStr(data["tw4"].toString()),
          licenseplate: data["tt4"].toString(),
          netweight: formatStr(data["aw4"].toStringAsFixed(3).toString()),
          day: "本季"),
      Table(
          company: formatStr(data["tw5"].toString()),
          licenseplate: data["tt5"].toString(),
          netweight: formatStr(data["aw5"].toStringAsFixed(3).toString()),
          day: "本年"),
    ];
    return tables;
  }

  formatStr(String str) {
    int end = str.indexOf(".");
    return str.substring(0, end + 2);
  }
}

class Table {
  String company;
  String licenseplate;
  String netweight;
  String day;

  Table({this.company, this.day, this.licenseplate, this.netweight});
}
