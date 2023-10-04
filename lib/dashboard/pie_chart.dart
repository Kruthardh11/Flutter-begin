import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, int> data;

  PieChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    // Check if the data map is empty
    if (data.isEmpty) {
      // Display an empty icon or message when data is empty
      return const Text(
          'Synced and up to date'); // You can replace this with any desired empty icon or widget.
    } else {
      // Show the pie chart when data is available
      return AspectRatio(
        aspectRatio: 1.3,
        child: PieChart(
          dataMap: generatePieChartData(data),
          animationDuration:
              const Duration(seconds: 1), // Set animation duration
          chartLegendSpacing: 24, // Adjust legend spacing as needed
          chartRadius: MediaQuery.of(context).size.width / 2.5,
          chartType: ChartType.disc, // Set chart type to disc
          centerText: "Sport",
          ringStrokeWidth: 24,
          legendOptions: const LegendOptions(
            showLegends: true,
            legendShape: BoxShape.circle,
            legendTextStyle: TextStyle(fontSize: 15),
            legendPosition: LegendPosition.bottom,
            showLegendsInRow: true,
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: true,
          ),
        ),
      );
    }
  }

  Map<String, double> generatePieChartData(Map<String, int> data) {
    Map<String, double> chartData = {};

    data.forEach((sport, count) {
      chartData[sport] = count.toDouble();
    });

    return chartData;
  }
}
