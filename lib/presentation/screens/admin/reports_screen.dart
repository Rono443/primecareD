import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics & Reports')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Monthly Revenue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 3),
                        FlSpot(1, 4),
                        FlSpot(2, 3.5),
                        FlSpot(3, 5),
                        FlSpot(4, 4),
                        FlSpot(5, 6),
                      ],
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 4,
                      belowBarData: BarAreaData(show: true, color: AppColors.primary.withOpacity(0.1)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Popular Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(value: 40, title: 'Wash&Fold', color: Colors.blue, radius: 50),
                    PieChartSectionData(value: 30, title: 'Ironing', color: Colors.orange, radius: 50),
                    PieChartSectionData(value: 20, title: 'DryClean', color: Colors.green, radius: 50),
                    PieChartSectionData(value: 10, title: 'Other', color: Colors.grey, radius: 50),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildReportDownloadTile('Daily Sales Report', Icons.picture_as_pdf),
            _buildReportDownloadTile('Inventory Usage Summary', Icons.table_chart),
            _buildReportDownloadTile('Staff Performance Review', Icons.picture_as_pdf),
          ],
        ),
      ),
    );
  }

  Widget _buildReportDownloadTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.download),
      onTap: () {},
    );
  }
}
