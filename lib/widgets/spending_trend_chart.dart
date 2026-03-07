import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingTrendChart extends StatelessWidget {
  const SpendingTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        height: 180,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 8000,

            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 2000,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 1,
                );
              },
            ),

            borderData: FlBorderData(show: false),

            titlesData: FlTitlesData(
              /// LEFT ₹ AXIS
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 2000,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      "₹${value.toInt()}",
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    );
                  },
                ),
              ),

              /// YEAR + MONTHS
              topTitles: AxisTitles(
                axisNameSize: 32,
                axisNameWidget: const Text(
                  "2026",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 24,
                  getTitlesWidget: (value, meta) {
                    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];

                    if (value.toInt() < 0 || value.toInt() >= months.length) {
                      return const SizedBox();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        months[value.toInt()],
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),

              bottomTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),

            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 1200),
                  FlSpot(1, 3000),
                  FlSpot(2, 5500),
                  FlSpot(3, 4000),
                  FlSpot(4, 6200),
                  FlSpot(5, 7200),
                ],

                isCurved: true,
                color: Color(0xFF2E86FF),
                barWidth: 3,

                dotData: const FlDotData(show: false),

                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2E86FF).withOpacity(0.3),
                      Color(0xFF2E86FF).withOpacity(0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
