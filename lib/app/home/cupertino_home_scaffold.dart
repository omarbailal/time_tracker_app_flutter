import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/tab_item.dart';

import 'jobs/jobs_page.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({Key? key, required this.currentTab, required this.onSelectTap}) : super(key: key);
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTap;


  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            _buildItem(TabItem.jobs),
            _buildItem(TabItem.entries),
            _buildItem(TabItem.account),
          ],
          onTap: (index) => onSelectTap(TabItem.values[index]),
        ),
        tabBuilder: (context, index) {
          final item = TabItem.values[index];
          final Map widgetBuilders = _widgetBuilders();
          return CupertinoTabView(
            builder: (context) => widgetBuilders[item](context),
          );
        },
    );
  }
  Map<TabItem, WidgetBuilder>  _widgetBuilders(){
    return{
      TabItem.jobs : (_) => const JobsPage(),
      TabItem.entries : (_) => Container(),
      TabItem.account : (_) => Container(),
    };
  }
  BottomNavigationBarItem _buildItem(TabItem tabItem){
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem ? Colors.indigo : Colors.grey;
    return BottomNavigationBarItem(
        icon: Icon(itemData!.icon, color: color,),
        title: Text(itemData.title, style: TextStyle(color: color),),
    );
  }
}
