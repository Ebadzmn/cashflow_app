import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/primary_button.dart';
import '../home_controller.dart';
import '../controllers/stats_controller.dart';

class StatsContent extends StatelessWidget {
  const StatsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StatsController>();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (Get.isRegistered<HomeController>()) {
                      Get.find<HomeController>().changeTabIndex(0);
                      return;
                    }

                    if (Get.key.currentState?.canPop() ?? false) {
                      Get.back();
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Reports',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return RefreshIndicator(
                onRefresh: controller.fetchExpenseReport,
                color: const Color(0xFF56CCF2),
                backgroundColor: const Color(0xFF10253F),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.isLoading.value)
                        const Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Center(
                            child: Text(
                              'Loading report...',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      else if (controller.chartData.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Center(
                            child: Text(
                              'No expense data found',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Expense report by category',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              height: 320,
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                20,
                                16,
                                18,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF4F6A8F,
                                ).withValues(alpha: 0.90),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.10),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.22),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: _ExpenseBarChart(
                                chartData: controller.chartData,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Choose file format',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF4F6A8F,
                                ).withValues(alpha: 0.90),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.10),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.22),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Obx(
                                () => Column(
                                  children: [
                                    _FormatOption(
                                      title: 'PDF (Recommended)',
                                      selected:
                                          controller.selectedFormat.value ==
                                          'PDF',
                                      onTap: () =>
                                          controller.setSelectedFormat('PDF'),
                                    ),
                                    const _FormatDivider(),
                                    _FormatOption(
                                      title: 'Excel.xlsx',
                                      selected:
                                          controller.selectedFormat.value ==
                                          'Excel',
                                      onTap: () =>
                                          controller.setSelectedFormat('Excel'),
                                    ),
                                    const _FormatDivider(),
                                    _FormatOption(
                                      title: 'CSV',
                                      selected:
                                          controller.selectedFormat.value ==
                                          'CSV',
                                      onTap: () =>
                                          controller.setSelectedFormat('CSV'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            PrimaryButton(
                              text: 'Download Report',
                              height: 56,
                              borderRadius: 14,
                              onPressed: controller.isDownloading.value
                                  ? null
                                  : () {
                                      final format =
                                          controller.selectedFormat.value;
                                      if (format == 'Excel') {
                                        controller.downloadExcelReport();
                                        return;
                                      }
                                      if (format == 'CSV') {
                                        controller.downloadCsvReport();
                                        return;
                                      }
                                      controller.downloadPdfReport();
                                    },
                              isLoading: controller.isDownloading.value,
                            ),
                            const SizedBox(height: 28),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FormatDivider extends StatelessWidget {
  const _FormatDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.white.withValues(alpha: 0.10),
      height: 1,
      thickness: 1,
    );
  }
}

class _FormatOption extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _FormatOption({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: selected ? 3 : 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 18),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> chartData;

  const _ExpenseBarChart({required this.chartData});

  @override
  Widget build(BuildContext context) {
    if (chartData.isEmpty) {
      return const Center(
        child: Text(
          'No expense data found',
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        maxY: 100,
        minY: 0,
        barTouchData: BarTouchData(enabled: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 10,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withValues(alpha: 0.14),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= chartData.length) {
                  return const SizedBox.shrink();
                }

                final label = chartData[index]['category'] as String;
                return SideTitleWidget(
                  meta: meta,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      label,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              interval: 10,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value > 100) {
                  return const SizedBox.shrink();
                }

                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    '${value.toInt()}%',
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: List.generate(chartData.length, (index) {
          final entry = chartData[index];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: (entry['percentage'] as double).clamp(0, 100),
                color: entry['color'] as Color,
                width: 28,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 100,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
