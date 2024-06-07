import 'package:flutter/material.dart';
import 'package:landlordy/models/tenantpayment.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GenChartPage extends StatefulWidget {
  final List<List<TenantPayment>>? tenantPaymentsList;
  final String? datatype;
  final String? data;
  final List<String>? tenantNames;
  final Map<String, int>? mapQuantities;
  const GenChartPage({
    super.key,
    required this.tenantPaymentsList,
    required this.datatype,
    required this.tenantNames,
    required this.mapQuantities,
    required this.data,
  });

  @override
  State<GenChartPage> createState() => _GenChartPageState();
}

class _GenChartPageState extends State<GenChartPage> {
  late double screenWidth, screenHeight;
  late TooltipBehavior _tooltipBehavior;
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  Map<String, int> propertyQuantities = {};
  List<BarSeries<TenantPayment, String>> lineSeriesList = [];
  List<DoughnutSeries<dynamic, String>> doughnutSeriesList = [];

  @override
  void initState() {
    _getData();
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        canShowMarker: false,
        animationDuration: 100,
        duration: 2000);
    _trackballBehavior = TrackballBehavior(
        enable: true, tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);
    _zoomPanBehavior =
        ZoomPanBehavior(enablePanning: true, enablePinching: true);
    super.initState();
  }

  void _getData() {
    if (widget.datatype == "Property" ||
        widget.datatype == "Tenant" ||
        widget.datatype == "Maintenance") {
      propertyQuantities = widget.mapQuantities!;
      var doughnutSeries = DoughnutSeries<dynamic, String>(
        dataSource: propertyQuantities.entries.toList(),
        explode: true,
        radius: '180',
        innerRadius: '80',
        explodeGesture: ActivationMode.singleTap,
        xValueMapper: (entry, _) => entry.key,
        yValueMapper: (entry, _) => entry.value,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            overflowMode: OverflowMode.shift,
            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            useSeriesColor: true),
      );
      doughnutSeriesList.add(doughnutSeries);
    }
    if (widget.datatype == "Rental Payment") {
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
              isVisible: true,
              textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
          markerSettings: const MarkerSettings(
              isVisible: true, shape: DataMarkerType.horizontalLine),
          emptyPointSettings:
              const EmptyPointSettings(mode: EmptyPointMode.zero),
        );
        lineSeriesList.add(lineSeries);
      }
    }
  }

  Widget _buildChart() {
    if (widget.datatype == "Property" ||
        widget.datatype == "Tenant" ||
        widget.datatype == "Maintenance") {
      return SfCircularChart(
        title: ChartTitle(
            text: widget.data.toString(),
            textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        tooltipBehavior: _tooltipBehavior,
        centerY: '40%',
        legend: const Legend(
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          isVisible: true,
          borderColor: Colors.black,
          backgroundColor: Colors.white,
          shouldAlwaysShowScrollbar: false,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        series: doughnutSeriesList,
      );
    } else if (widget.datatype == "Rental Payment") {
      return SfCartesianChart(
        title: ChartTitle(
            text: widget.datatype.toString(),
            textStyle: const TextStyle(fontWeight: FontWeight.bold)),
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
          height: '8%',
          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          isVisible: true,
          borderColor: Colors.black,
          backgroundColor: Colors.white,
          shouldAlwaysShowScrollbar: false,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        tooltipBehavior: _tooltipBehavior,
        zoomPanBehavior: _zoomPanBehavior,
        trackballBehavior: _trackballBehavior,
        series: lineSeriesList,
      );
    } else {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TABLE NOT EXIST',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
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
        child: _buildChart(),
      ),
    );
  }
}
