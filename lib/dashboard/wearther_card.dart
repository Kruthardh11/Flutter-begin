import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final double humidity;
  final double temperature;
  final double windSpeed;

  WeatherCard({
    required this.humidity,
    required this.temperature,
    required this.windSpeed,
  });

  // Define a function to choose the weather icon based on temperature
  IconData _getWeatherIcon(double temperature) {
    if (temperature >= 30.0) {
      return Icons.wb_sunny; // Hot weather
    } else if (temperature >= 20.0) {
      return Icons.wb_cloudy; // Moderate weather
    } else {
      return Icons.ac_unit; // Cold weather
    }
  }

  @override
  Widget build(BuildContext context) {
    final IconData weatherIcon = _getWeatherIcon(temperature);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.blueGrey[100], // Light grey-blue background color
      child: Container(
        width: 300,
        height: 150,
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon representing temperature on the left
            Icon(
              weatherIcon,
              size: 60,
              color: Colors.orange, // Customize the color as needed
            ),
            SizedBox(width: 16), // Add spacing between icon and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Humidity: ${humidity.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Temperature: ${temperature.toStringAsFixed(2)} °C',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  'Wind Speed: ${windSpeed.toStringAsFixed(2)} m/s',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
