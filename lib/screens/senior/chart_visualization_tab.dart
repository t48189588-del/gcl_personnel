import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

class ChartVisualizationTab extends StatelessWidget {
  const ChartVisualizationTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.chartVisualizations, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _buildChartCard(loc.chartApprovedHours, _buildHoursHistogram(provider, loc)),
                  _buildChartCard(loc.chartWorkedVsApproved, _buildWorkedVsApprovedPie(provider, loc)),
                  _buildChartCard(loc.chartLanguageProficiency, _buildLanguageProficiencyBar(provider, loc)),
                  _buildChartCard(loc.chartCumulativeHours, _buildCumulativeHoursLine(provider, loc)),
                  _buildChartCard(loc.chartAcademicStatus, _buildAcademicStatusBar(provider, loc)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Container(
      width: 400,
      height: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Expanded(child: chart),
        ],
      ),
    );
  }

  Widget _buildHoursHistogram(AppProvider provider, AppLocalizations loc) {
    Map<String, double> hoursPerSlot = {};
    for (var b in provider.blocks.where((b) => b.status == 'approved')) {
      final slot = DateFormat('HH:mm').format(b.startTime);
      hoursPerSlot[slot] = (hoursPerSlot[slot] ?? 0) + 0.5;
    }

    final sortedSlots = hoursPerSlot.keys.toList()..sort();
    if (sortedSlots.isEmpty) return Center(child: Text(loc.noData));

    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < sortedSlots.length; i++) {
      barGroups.add(BarChartGroupData(
        x: i,
        barRods: [BarChartRodData(toY: hoursPerSlot[sortedSlots[i]]!, color: Colors.blue)],
      ));
    }

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < sortedSlots.length) {
                  return Padding(padding: const EdgeInsets.only(top: 8), child: Text(sortedSlots[value.toInt()], style: const TextStyle(fontSize: 10)));
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildWorkedVsApprovedPie(AppProvider provider, AppLocalizations loc) {
    double approvedHours = provider.blocks.where((b) => b.status == 'approved').length * 0.5;
    double workedHours = provider.reports.where((r) => r.isSubmitted).fold(0.0, (sum, r) => sum + r.workedHours);

    if (approvedHours == 0 && workedHours == 0) return Center(child: Text(loc.noData));

    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(value: approvedHours, title: '${loc.approved}\n${approvedHours}h', color: Colors.green.shade300, radius: 80),
          PieChartSectionData(value: workedHours, title: '${loc.workedHours}\n${workedHours.toStringAsFixed(1)}h', color: Colors.blue.shade300, radius: 80),
        ],
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildLanguageProficiencyBar(AppProvider provider, AppLocalizations loc) {
    Map<String, int> counts = {'Basic': 0, 'Intermediate': 0, 'Advanced': 0, 'Native': 0};
    for (var s in provider.staff) {
      for (var skill in s.languageSkills) {
        counts[skill.proficiency] = (counts[skill.proficiency] ?? 0) + 1;
      }
    }
    
    for (var s in provider.staff) {
      if (s.nativeLanguage.isNotEmpty) {
        counts['Native'] = (counts['Native'] ?? 0) + 1;
      }
    }

    final keys = ['Basic', 'Intermediate', 'Advanced', 'Native'];
    final localizedKeys = [loc.basic, loc.intermediate, loc.advanced, loc.native];
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < keys.length; i++) {
      barGroups.add(BarChartGroupData(
        x: i,
        barRods: [BarChartRodData(toY: counts[keys[i]]!.toDouble(), color: Colors.purple)],
      ));
    }

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < localizedKeys.length) {
                  return Padding(padding: const EdgeInsets.only(top: 8), child: Text(localizedKeys[value.toInt()], style: const TextStyle(fontSize: 10)));
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildCumulativeHoursLine(AppProvider provider, AppLocalizations loc) {
    Map<String, Map<DateTime, double>> staffHours = {};
    for (var r in provider.reports.where((r) => r.isSubmitted)) {
      final d = DateTime(r.reportDate.year, r.reportDate.month, r.reportDate.day);
      staffHours.putIfAbsent(r.staffId, () => {});
      staffHours[r.staffId]![d] = (staffHours[r.staffId]![d] ?? 0) + r.workedHours;
    }

    if (staffHours.isEmpty) return Center(child: Text(loc.noData));

    List<LineChartBarData> lineBars = [];
    int colorIndex = 0;
    
    Set<DateTime> allDates = {};
    for (var map in staffHours.values) {
      allDates.addAll(map.keys);
    }
    final sortedDates = allDates.toList()..sort();
    
    for (var entry in staffHours.entries) {
      double cumulative = 0;
      List<FlSpot> spots = [];
      for (int i = 0; i < sortedDates.length; i++) {
        final d = sortedDates[i];
        cumulative += (entry.value[d] ?? 0);
        spots.add(FlSpot(i.toDouble(), cumulative));
      }
      lineBars.add(LineChartBarData(
        spots: spots,
        isCurved: true,
        color: Colors.primaries[colorIndex % Colors.primaries.length],
        barWidth: 2,
        dotData: const FlDotData(show: false),
      ));
      colorIndex++;
    }

    return LineChart(
      LineChartData(
        lineBarsData: lineBars,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < sortedDates.length) {
                  return Padding(padding: const EdgeInsets.only(top: 8), child: Text(DateFormat('MM/dd').format(sortedDates[value.toInt()]), style: const TextStyle(fontSize: 10)));
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildAcademicStatusBar(AppProvider provider, AppLocalizations loc) {
    Map<String, int> counts = {'Bachelors': 0, 'Masters': 0, 'PhD': 0, 'Research': 0};
    for (var s in provider.staff) {
      if (counts.containsKey(s.degree)) {
        counts[s.degree] = counts[s.degree]! + 1;
      }
    }

    final keys = ['Bachelors', 'Masters', 'PhD', 'Research'];
    final localizedKeys = [loc.bachelors, loc.masters, loc.phd, loc.research];
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < keys.length; i++) {
      barGroups.add(BarChartGroupData(
        x: i,
        barRods: [BarChartRodData(toY: counts[keys[i]]!.toDouble(), color: Colors.orange)],
      ));
    }

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < localizedKeys.length) {
                  return Padding(padding: const EdgeInsets.only(top: 8), child: Text(localizedKeys[value.toInt()], style: const TextStyle(fontSize: 10)));
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
