import 'package:flutter/material.dart';
import 'package:landlordy/models/tenantpayment.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GenChartPage extends StatefulWidget {
  final List<List<TenantPayment>>? tenantPaymentsList;
  final String? datatype;
  final List<String>? tenantNames;
  const GenChartPage(
      {super.key,
      required this.tenantPaymentsList,
      required this.datatype,
      required this.tenantNames});

  @override
  State<GenChartPage> createState() => _GenChartPageState();
}

class _GenChartPageState extends State<GenChartPage> {
  late double screenWidth, screenHeight;
  late TooltipBehavior _tooltipBehavior;
  List<LineSeries<TenantPayment, String>> lineSeriesList = [];

  @override
  void initState() {
    _getData();
    _loadSeries();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  void _getData() {
    for (int i = 0; i < widget.tenantPaymentsList!.length; i++) {
      var lineSeries = LineSeries<TenantPayment, String>(
        dataSource: widget.tenantPaymentsList![i],
        name: widget.tenantNames![i],
        xValueMapper: (TenantPayment payment, _) => payment.monthYear,
        yValueMapper: (TenantPayment payment, _) =>
            double.parse(payment.paymentAmount!),
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        markerSettings: const MarkerSettings(isVisible: true),
      );
      lineSeriesList.add(lineSeries);
    }
  }

  void _loadSeries() {}

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/icons/back_icon.png',
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2)),
        width: screenWidth,
        height: screenHeight,
        child: Expanded(
          child: SfCartesianChart(
            zoomPanBehavior:
                ZoomPanBehavior(enablePanning: true, enablePinching: true),
            trackballBehavior: TrackballBehavior(enable: true),
            title: const ChartTitle(
                text: "Rental Payments",
                textStyle: TextStyle(fontWeight: FontWeight.bold)),
            legend: const Legend(isVisible: true),
            tooltipBehavior: _tooltipBehavior,
            primaryXAxis: const CategoryAxis(
              title: AxisTitle(text: 'Month Year'),
            ),
            primaryYAxis: const NumericAxis(
              labelFormat: '{value}',
              title: AxisTitle(text: 'Payment Amount'),
            ),
            series: lineSeriesList,
          ),
        ),
      ),
    );
  }
}
