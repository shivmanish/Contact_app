part of contact_app;

class DashboardTab {
  final String tabName;
  final IconData tabIcon;
  final Widget tabWidget;

  DashboardTab({
    required this.tabName,
    required this.tabIcon,
    required this.tabWidget,
  });
}

class ContactAppDashboard extends StatefulWidget {
  const ContactAppDashboard({super.key});

  @override
  State<ContactAppDashboard> createState() => _ContactAppDashboardState();
}

class _ContactAppDashboardState extends State<ContactAppDashboard>
    with SingleTickerProviderStateMixin {
  // Color to use for inactive tabs.
  final Color inactiveTabColor = Colors.grey.withValues(alpha: 0.2);

  // Tab controller which will emit tab change events.
  TabController? _controller;
  final ContactBloc bloc = ContactBloc();

  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  List<DashboardTab> tabs = [
    DashboardTab(
      tabName: "Contacts",
      tabIcon: Icons.person_rounded,
      tabWidget: Contacts(key: ValueKey('contacts')),
    ),
    DashboardTab(
      tabName: "Favorite Contacts",
      tabIcon: Icons.star_rate_rounded,
      tabWidget: Contacts(key: ValueKey('favorite_contacts'), isFavorite: true),
    ),
  ];

  @override
  void initState() {
    _controller ??= TabController(
      vsync: this,
      length: tabs.length,
      initialIndex: _selectedIndex.value,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: Platform.isAndroid,
        minimum:
            Platform.isMacOS
                ? EdgeInsets.zero
                : const EdgeInsets.only(bottom: 16.0),
        child: DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _controller,
              children: _tabWidgets(),
            ),

            bottomNavigationBar: _bottomNavigationBar(),
            floatingActionButton: _floatingActionButtion(),
          ),
        ),
      ),
    );
  }

  Widget _floatingActionButtion() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateNewContact()),
        );
      },
      tooltip: 'Add Contact',
      child: const Icon(Icons.add),
    );
  }

  void _handleTabChange(int index) {
    if (_selectedIndex.value != index) {
      setState(() {
        _selectedIndex.value = index;
      });
    }
  }

  List<Widget> _tabWidgets() {
    return tabs
        .map(
          (tab) => Container(
            color: Colors.transparent,
            padding: EdgeInsets.zero,
            child: tab.tabWidget,
          ),
        )
        .toList();
  }

  /// Returns bottom navigation bar for dashboard.
  Widget _bottomNavigationBar() {
    return Container(
      color: Colors.white.withValues(alpha: 0.1),
      child: TabBar(
        labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        controller: _controller,
        onTap: _handleTabChange,
        indicator: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        tabs: tabs.map((tab) => Tab(child: _tabIcon(tab))).toList(),
      ),
    );
  }

  /// Returns bottom bar tab icon to use with provided tab name.
  Widget _tabIcon(DashboardTab tab) {
    return Icon(
      tab.tabIcon,
      size: 34.0,
      color:
          _isActive(tab.tabName)
              ? Colors.grey.withValues(alpha: 0.8)
              : inactiveTabColor,
    );
  }

  bool _isActive(String tabName) {
    return _activeTabName() == tabName;
  }

  String _activeTabName() {
    return tabs[_selectedIndex.value].tabName;
  }
}
