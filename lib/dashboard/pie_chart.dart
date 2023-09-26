import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, int> data;

  PieChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: generatePieChartSections(data),
          borderData: FlBorderData(show: false),
          centerSpaceRadius: 40,
          sectionsSpace: 0,
        ),
      ),
    );
  }

  List<PieChartSectionData> generatePieChartSections(Map<String, int> data) {
    List<PieChartSectionData> sections = [];

    // Define a list of predefined colors
    List<Color> sectionColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      // Add more colors as needed
    ];

    // Loop through the data and assign colors from the predefined list
    int colorIndex = 0;
    data.forEach((sport, count) {
      final double radius = 60;
      sections.add(
        PieChartSectionData(
          title: '$sport\n$count',
          radius: radius,
          value: count.toDouble(),
          color: sectionColors[colorIndex %
              sectionColors.length], // Assign a color from the list
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      colorIndex++;
    });

    return sections;
  }
}
