import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  final List<Tab> tabs;
  final List<Widget> tabViews;
  final Color? tabBarColor;
  final Color? tabViewBackgroundColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Color? indicatorColor;

  const Tabs({
    super.key,
    required this.tabs,
    required this.tabViews,
    this.tabBarColor,
    this.tabViewBackgroundColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorColor,
  }) : assert(
          tabs.length == tabViews.length,
          "Tabs and tabViews must have the same length",
        );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          Container(
            color: tabBarColor ?? Colors.blueGrey,
            child: TabBar(
              labelColor: labelColor ?? Colors.white,
              unselectedLabelColor: unselectedLabelColor ?? Colors.black54,
              indicatorColor: indicatorColor ?? Colors.white,
              tabs: tabs,
            ),
          ),
          Expanded(
            child: Container(
              color: tabViewBackgroundColor ?? Colors.white,
              child: TabBarView(
                children: tabViews,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
