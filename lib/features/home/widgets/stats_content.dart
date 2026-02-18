import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/primary_button.dart';

class StatsContent extends StatefulWidget {
  const StatsContent({super.key});

  @override
  State<StatsContent> createState() => _StatsContentState();
}

class _StatsContentState extends State<StatsContent> {
  String _selectedFormat = 'PDF'; // Default selection

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Navigate back or to home tab
                    // Since this is a tab content, maybe just switch to home tab?
                    // Or if navigated here, pop.
                    // For now, let's assume it's just a back button visually.
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                ),
                const Expanded(
                  child: Text(
                    'Reports',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 40), // Balance the back button
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Expense by Category',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Bar Chart Card
                  Container(
                    height: 250,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2937), // Dark card background
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 100,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const style = TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                );
                                String text;
                                switch (value.toInt()) {
                                  case 0: text = 'House'; break;
                                  case 1: text = 'Food'; break;
                                  case 2: text = 'Education'; break; // Truncated in chart? Let's use short
                                  case 3: text = 'Travel'; break;
                                  case 4: text = 'Gas'; break;
                                  case 5: text = 'Others'; break;
                                  default: text = '';
                                }
                                return SideTitleWidget(
                                  meta: meta,
                                  child: Text(text, style: style),
                                );
                              },
                              reservedSize: 30,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 10,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}%',
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 10,
                                  ),
                                );
                              },
                              reservedSize: 30,
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 10,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.white.withValues(alpha: 0.1),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          _makeBarGroup(0, 55, const Color(0xFFFF8A80)), // House (Pink)
                          _makeBarGroup(1, 45, const Color(0xFF66BB6A)), // Food (Green)
                          _makeBarGroup(2, 35, const Color(0xFF42A5F5)), // Education (Blue)
                          _makeBarGroup(3, 52, const Color(0xFFAB47BC)), // Travel (Purple)
                          _makeBarGroup(4, 92, const Color(0xFF26A69A)), // Gas (Teal)
                          _makeBarGroup(5, 75, const Color(0xFFFFCA28)), // Others (Yellow)
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Tax Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tax Overview Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2937),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              PieChart(
                                PieChartData(
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 70,
                                  startDegreeOffset: -90,
                                  sections: [
                                    PieChartSectionData(
                                      color: const Color(0xFF03A9F4), // Federal (Blue)
                                      value: 45,
                                      title: '',
                                      radius: 25,
                                    ),
                                    PieChartSectionData(
                                      color: const Color(0xFFE91E63), // State (Pink)
                                      value: 25,
                                      title: '',
                                      radius: 25,
                                    ),
                                    PieChartSectionData(
                                      color: const Color(0xFFCCFF90), // Local (Light Green)
                                      value: 30,
                                      title: '',
                                      radius: 25,
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      '\$4,200',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'TOTAL TAX',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildLegendItem('Federal', '45%', const Color(0xFF03A9F4)),
                            _buildLegendItem('State', '25%', const Color(0xFFE91E63)),
                            _buildLegendItem('Local', '30%', const Color(0xFFCCFF90)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Choose file format',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // File Format Selection
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      children: [
                        _buildRadioItem('PDF (Recommended)', 'PDF'),
                        Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
                        _buildRadioItem('Excel.xlsx', 'Excel'),
                        Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
                        _buildRadioItem('CSV', 'CSV'), // Fixed typo CVS -> CSV
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // Download Button
                  PrimaryButton(
                    text: 'Download Report',
                    onPressed: () {
                      // Handle download
                    },
                  ),
                  
                  const SizedBox(height: 32), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 24, // Wider bars
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100, // Background bar height
            color: Colors.transparent, // Or subtle background
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16253A), // Darker card background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioItem(String title, String value) {
    final isSelected = _selectedFormat == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFormat = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
