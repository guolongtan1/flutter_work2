import 'package:fluttertransport/config/service_url.dart';
import 'package:postgres/postgres.dart';

Future request(operation, time) async {
  var serviceURL = {
    "passTotalWeight": "select Cheak_Total_Weight_By_Time('$time');", //unused
    "fiveCompany": "select * from Total_Weight_Rank_BY_Company('$time');",
    "totalAvgWeight": "select * from Avg_Weight ('$time');", //unused
    "totalWeightByDay": "select * from Total_weight_BY_day('$time');",
    "hometable": "select * from Home_Table_1('1 day') order by total_times;",
    "originalTable":
        "select 流水号,收货单位,车号,货名,净重,皮重时间,客户类型 from orders where 收货单位 != 'Daily test' order by 皮重时间 desc limit $time;",
    "simpleTable": "select * from Total_Group('$time')",
    "simpleTable1": "select * from Total_Group1('$time')",
    "simpleTable_byday":
        "select * from total_group_byday('$time')", //传入格式为 '2020-07-03'
    "simpleTable_bymonth":
        "select * from total_group_bymonth('$time')", //传入格式为 '2020-07-03'
    "login": "select passwd from login where username = '$time'"
  };
  try {
    var connection = new PostgreSQLConnection(db["host"], db["port"], db["db"],
        username: db["user"], password: db["password"]);
    await connection.open();
    List<List<dynamic>> results = await connection.query(serviceURL[operation]);
    return results;
  } catch (e) {
    return print("ERROR====================>$e");
  }
}
