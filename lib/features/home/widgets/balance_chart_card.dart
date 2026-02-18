import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BalanceChartCard extends StatelessWidget {
  const BalanceChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF16253A), // Dark card background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$23,480',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildLegendItem(const Color(0xFFEB5757), 'Expenses'),
                  const SizedBox(width: 12),
                  _buildLegendItem(const Color(0xFF56CCF2), 'Income'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.1),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        );
                        String text;
                        switch (value.toInt()) {
                          case 0:
                            text = 'Jan';
                            break;
                          case 1:
                            text = 'Feb';
                            break;
                          case 2:
                            text = 'Mar';
                            break;
                          case 3:
                            text = 'Apr';
                            break;
                          case 4:
                            text = 'May';
                            break;
                          case 5:
                            text = 'Jun';
                            break;
                          case 6:
                            text = 'Jul';
                            break;
                          default:
                            return Container();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(text, style: style),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1500,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        );
                        String text;
                        if (value == 0) {
                          text = '\$0k';
                        } else if (value == 1500) {
                          text = '\$1.5k';
                        } else if (value == 3000) {
                          text = '\$3k';
                        } else if (value == 4500) {
                          text = '\$4.5k';
                        } else if (value == 6000) {
                          text = '\$6k';
                        } else {
                          return Container();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(text, style: style),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 6000,
                lineBarsData: [
                  // Income Line (Cyan)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 4000),
                      FlSpot(1, 3000),
                      FlSpot(2, 2000),
                      FlSpot(3, 2800),
                      FlSpot(4, 2000),
                      FlSpot(5, 2400),
                      FlSpot(6, 3500),
                    ],
                    isCurved: true,
                    color: const Color(0xFF56CCF2),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                  // Expenses Line (Red)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 2400),
                      FlSpot(1, 1500),
                      FlSpot(2, 5500), // Peak
                      FlSpot(3, 4000),
                      FlSpot(4, 5000),
                      FlSpot(5, 4000),
                      FlSpot(6, 4500),
                    ],
                    isCurved: true,
                    color: const Color(0xFFEB5757),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
