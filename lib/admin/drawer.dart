import 'package:crm/services/google_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawerWidget extends StatelessWidget {
  final String name;
  const NavDrawerWidget({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(context) {
    return Drawer(
      child: Material(
        color: Color.fromRGBO(23, 23, 23, 1.0),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          children: <Widget>[
            const SizedBox(height: 48,),
            MenuItem(
                text: "Dashboard",
                iconData: Icons.dashboard,
                onClick: () => onItemSelected(context, '/admin')
            ),
            MenuItem(
              text: "All Requests",
              iconData: Icons.request_page,
              onClick: () => onItemSelected(context, '/requests')
            ),
            MenuItem(
                text: "Pending Requests",
                iconData: CupertinoIcons.doc_plaintext,
                onClick: () => onItemSelected(context, '/pendingRequests')
            ),
            MenuItem(
                text: "Companies",
                iconData: Icons.workspaces,
                onClick: () => onItemSelected(context, '/companies')
            ),
            MenuItem(
                text: "Clients",
                iconData: Icons.people,
                onClick: () => onItemSelected(context, '/customers')
            ),
            MenuItem(
                text: "Budgets",
                iconData: Icons.work,
                onClick: () => onItemSelected(context, '/budgets')
            ),
            MenuItem(
                text: "RFPs",
                iconData: Icons.request_quote,
                onClick: () => onItemSelected(context, '/rfps')
            ),
            MenuItem(
                text: "Projects",
                iconData: Icons.account_balance,
                onClick: () => onItemSelected(context, '/projects')
            ),
            MenuItem(
                text: "Employees",
                iconData: Icons.emoji_people,
                onClick: () => onItemSelected(context, '/employees')
            ),
            MenuItem(
                text: "Assets",
                iconData: Icons.local_shipping,
                onClick: () => onItemSelected(context, '/assets')
            ),
            MenuItem(
                text: "Data",
                iconData: Icons.dataset,
                onClick: () => onItemSelected(context, '/data')
            ),
            MenuItem(
                text: "Logout",
                iconData: Icons.logout,
                onClick: () => onItemSelected(context, '/login')
            ),
          ],
        ),
      ),
    );
  }

  Widget MenuItem ({
    required String text,
    required IconData iconData,
    required VoidCallback onClick
  }) {
    const color = Colors.white;

    return ListTile(
      leading: Icon(iconData, color: color,),
      title: Text(text, style: const TextStyle(color: color)),
      onTap: onClick,
    );
  }

  void onItemSelected(BuildContext context, String route) async {
    Navigator.pop(context);
    if(name==route) {
      return;
    }
    if(route=='/login') {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      GoogleServices().logout();
    }
      Navigator.pushReplacementNamed(context, route);
  }
}

