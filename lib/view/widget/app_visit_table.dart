import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tnm_fact/utils/app_color.dart';

class AppVisitChart extends StatelessWidget {
  const AppVisitChart({super.key});

  Future<Map<String, int>> _fetchDailyVisits() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('visits').get();
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
        print('dailyCounts: $dailyCounts');
        final today = DateTime.now();
        print('today: $today');
        final allDates = List.generate(5, (i) {
          final date = today.subtract(Duration(days: 4 - i));
          return DateFormat('yyyy-MM-dd').format(date);
        });
        print('allDates: $allDates');

        final filledCounts = {for (var d in allDates) d: (dailyCounts[d] ?? 0)};

        final sorted = filledCounts.entries.toList();
        final spots = sorted.asMap().entries.map((entry) {
          final idx = entry.key.toDouble();
          final value = entry.value.value.toDouble();
          return FlSpot(idx, value);
        }).toList();

        return Padding(
          padding: EdgeInsets.all(16.w),
          child: SizedBox(
            height: 250.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1, // ✅ 인덱스마다 하나씩 라벨 출력
                      reservedSize: 28.h, // 날짜와 그래프 사이 여백
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= sorted.length)
                          return const Text('');
                        final fullDate = sorted[idx].key; // yyyy-MM-dd
                        final month = fullDate.substring(5, 7);
                        final day = fullDate.substring(8, 10);
                        return Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text("$month/$day",
                              style: const TextStyle(fontSize: 12)),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,    
                      reservedSize: 40.w, // 반응형: 화면 크기에 따라 여백 자동 조절
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: EdgeInsets.only(right: 6.w), // 숫자와 축 사이 간격
                          child: Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)), // ✅ 위쪽 라벨 제거
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    barWidth: 3,
                    color: AppColor.primary,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColor.primary.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
