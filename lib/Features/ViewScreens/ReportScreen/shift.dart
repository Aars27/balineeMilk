import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../Core/Constant/app_colors.dart';
import '../../../Core/Constant/text_constants.dart';

class ShiftReportWidget extends StatelessWidget {
  const ShiftReportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildShiftBarChart(),
        const SizedBox(height: 20),
        _buildShiftCard(
          title: "Morning Shift",
          time: "06:00 - 12:00",
          intake: "300 L",
          distributed: "250 L",
          returned: "50 L",
          bgColor: Colors.yellow.shade50,
        ),
        const SizedBox(height: 15),
        _buildShiftCard(
          title: "Evening Shift",
          time: "18:00 - 00:00",
          intake: "200 L",
          distributed: "170 L",
          returned: "25 L",
          bgColor: Colors.red.shade50,
        ),
      ],
    );
  }

  Widget _buildShiftBarChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 260,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: BarChart(
          BarChartData(
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    List<String> days = [
                      "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"
                    ];
                    return Text(days[index],
                        style: TextConstants.smallTextStyle);
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles:
                SideTitles(showTitles: true, interval: 5000),
              ),
            ),
            barGroups: [
              _bar(0, 12000, 8000),
              _bar(1, 14000, 9000),
              _bar(2, 16000, 10000),
              _bar(3, 15000, 9000),
              _bar(4, 17000, 11000),
              _bar(5, 16500, 10000),
              _bar(6, 15000, 8000),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData _bar(int x, double intake, double distributed) {
    return BarChartGroupData(
      x: x,
      barsSpace: 4,
      barRods: [
        BarChartRodData(
          toY: intake,
          width: 12,
          color: Colors.orange,
        ),
        BarChartRodData(
          toY: distributed,
          width: 12,
          color: Colors.red,
        ),
      ],
    );
  }


  Widget _buildShiftCard({
    required String title,
    required String time,
    required String intake,
    required String distributed,
    required String returned,
    required Color bgColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextConstants.subHeadingStyle.copyWith(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(time,
                      style: TextConstants.smallTextStyle
                          .copyWith(color: Colors.grey)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _metric("Intake", intake, Colors.black),
                      const SizedBox(width: 20),
                      _metric("Distributed", distributed, Colors.green),
                      const SizedBox(width: 20),
                      _metric("Returned", returned, Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            TextConstants.smallTextStyle.copyWith(color: Colors.grey)),
        Text(
          value,
          style: TextConstants.bodyStyle
              .copyWith(color: color, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
