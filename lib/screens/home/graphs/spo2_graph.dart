import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class SPO2Graph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.8,
      height: width * 0.8,
      padding: EdgeInsets.symmetric(vertical: width * 0.14),
      child: SfCartesianChart(
        title: ChartTitle(text: "SpO2"),
        //legend: Legend(isVisible: true),
        primaryXAxis: NumericAxis(),
        primaryYAxis: NumericAxis(),
        series: [
          LineSeries(
              dataSource: getData(),
              xValueMapper: (data s, _) => s.x,
              yValueMapper: (data s, _) => s.y)
        ],
      ),
    );
  }
}

class data {
  int x, y;
  data(this.x, this.y);
}

List<data> getData() {
  final List<int> nums = [
    99,
    10,
    94,
    12,
    98,
    9,
    102,
    40,
    90,
    99,
    10,
    94,
    12,
    98,
    9,
    102,
    40,
    90,
    99,
    10,
    94,
    12,
    98,
    9,
    102,
    40,
    90,
  ];
  List<data> foo = [];
  for (int i = 0; i <= nums.length - 1; i++) {
    foo.add(data(i, nums[i]));
  }

  return foo;
}
