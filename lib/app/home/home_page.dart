import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/cupertino_home_scaffold.dart';
import 'package:time_tracker_flutter_course/app/home/tab_item.dart';

import 'account/account_page.dart';
import 'jobs/jobs_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };
  void _select(TabItem value) {
    setState(() {
      _currentTab = value;
    });
  }
  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => const JobsPage(),
      TabItem.entries: (_) => Container(),
      TabItem.account: (_) => const AccountPage(),
    };
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
    );
  }


}
