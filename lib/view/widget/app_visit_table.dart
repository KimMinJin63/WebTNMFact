import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AppVisitChart extends StatelessWidget {
  const AppVisitChart({super.key});

  Future<Map<String, int>> _fetchDailyVisits() async {
    final snapshot = await FirebaseFirestore.instance.collection('visits').get();
    Map<String, int> dailyCounts = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final date = data['date'] ?? '';
      if (date.isNotEmpty) {
        dailyCounts[date] = (dailyCounts[date] ?? 0) + 1;
      }
    }
    return dailyCounts;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: _fetchDailyVisits(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final dailyCounts = snapshot.data!;
        if (dailyCounts.isEmpty) {
          return const Text("📭 방문자 데이터 없음");
        }

        final sorted = dailyCounts.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

        final spots = sorted.asMap().entries.map((entry) {
          final idx = entry.key.toDouble();
          final value = entry.value.value.toDouble();
          return FlSpot(idx, value);
        }).toList();

        return SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= sorted.length) return const Text('');
                      return Text(sorted[idx].key.substring(5)); // MM-DD만 표시
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  barWidth: 3,
                  color: Colors.blue,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
