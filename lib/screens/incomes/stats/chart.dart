import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyChart extends StatelessWidget {
  final Map<String, double> aggregatedIncomes;
  final BuildContext context;

  const MyChart({
    Key? key,
    required this.aggregatedIncomes,
    required this.context,
  }) : super(key: key);

  // Calculate the maximum value from aggregatedIncomes
  double getMaxYValue() {
    return aggregatedIncomes.values.fold<double>(
      0,
      (previousValue, value) => value > previousValue ? value : previousValue,
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        toY: y,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.tertiary,
          ],
          transform: const GradientRotation(pi / 40),
        ),
        width: 20,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          toY: getMaxYValue(), // Use the maximum value for background rod
          color: Colors.grey.shade300,
        ),
      ),
    ]);
  }

  List<BarChartGroupData> showingGroups() {
    final daysOfWeek = aggregatedIncomes.keys.toList();
    return List.generate(daysOfWeek.length, (i) {
      final day = daysOfWeek[i];
      return makeGroupData(i, aggregatedIncomes[day] ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      mainBarData(),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            getTitlesWidget: leftTitles,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      gridData: const FlGridData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;

    if (value.toInt() >= 0 && value.toInt() < aggregatedIncomes.keys.length) {
      text =
          Text(aggregatedIncomes.keys.elementAt(value.toInt()), style: style);
    } else {
      text = const Text('', style: style);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
