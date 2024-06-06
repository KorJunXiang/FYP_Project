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
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  List<BarSeries<TenantPayment, String>> lineSeriesList = [];

  @override
  void initState() {
    _getData();
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    _trackballBehavior = TrackballBehavior(
        enable: true, tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);
    _zoomPanBehavior =
        ZoomPanBehavior(enablePanning: true, enablePinching: true);
    super.initState();
  }

  void _getData() {
    for (int i = 0; i < widget.tenantPaymentsList!.length; i++) {
      var lineSeries = BarSeries<TenantPayment, String>(
        dataSource: widget.tenantPaymentsList![i],
        name: widget.tenantNames![i],
        xValueMapper: (TenantPayment payment, _) => payment.monthYear,
        yValueMapper: (TenantPayment payment, _) =>
            payment.paymentAmount == "RM 0"
                ? null
                : double.parse(payment.paymentAmount!.substring(3)),
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, textStyle: TextStyle(fontSize: 8)),
        markerSettings: const MarkerSettings(
            isVisible: true, shape: DataMarkerType.horizontalLine),
        emptyPointSettings: const EmptyPointSettings(mode: EmptyPointMode.zero),
      );
      lineSeriesList.add(lineSeries);
    }
  }

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
        child: SfCartesianChart(
          title: const ChartTitle(
              text: "Rental Payments",
              textStyle: TextStyle(fontWeight: FontWeight.bold)),
          primaryXAxis: const CategoryAxis(
              title: AxisTitle(
            text: 'Month Year',
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          )),
          primaryYAxis: const NumericAxis(
            labelFormat: 'RM{value}',
            title: AxisTitle(
              text: 'Payment Amount',
              textStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          legend: const Legend(
              isVisible: true,
              borderColor: Colors.black,
              backgroundColor: Colors.white,
              shouldAlwaysShowScrollbar: false),
          tooltipBehavior: _tooltipBehavior,
          zoomPanBehavior: _zoomPanBehavior,
          trackballBehavior: _trackballBehavior,
          series: lineSeriesList,
        ),
      ),
    );
  }
}
