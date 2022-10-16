import 'package:crm/admin/add_data.dart';
import 'package:crm/admin/admin.dart';
import 'package:crm/admin/assets.dart';
import 'package:crm/admin/companies.dart';
import 'package:crm/admin/customers.dart';
import 'package:crm/admin/employees.dart';
import 'package:crm/admin/pending_requests.dart';
import 'package:crm/admin/projects.dart';
import 'package:crm/admin/requests.dart';
import 'package:crm/admin/shippers.dart';
import 'package:crm/admin/suppliers.dart';
import 'package:crm/engineers/engineers_dashboard.dart';
import 'package:crm/finances/finances_dashboard.dart';
import 'package:crm/it/it_dashboard.dart';
import 'package:crm/login.dart';
import 'package:crm/logistics/dashboard.dart';
import 'package:crm/manager/manager_dashboard.dart';
import 'package:crm/suppliers/suppliers_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'CRM';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      initialRoute: '/',
      routes : {
        //Splash Screen
        '/' : (context) => const SplashScreen(),

        //Login Page
        '/login' : (context) => const LoginPage(),

        //Admin Routes
        '/admin' : (context) => const AdminHome(),
        '/data' : (context) => const AddData(),
        '/customers' : (context) => const Customers(),
        '/projects' : (context) => const Projects(),
        '/employees' : (context) => const Employees(),
        '/requests' : (context) => const Requests(),
        '/pendingRequests' : (context) => const PendingRequests(),
        '/assets' : (context) => const Assets(),
        '/companies' : (context) => const Companies(),

        //Other Dashboards
        '/supplier' : (context) => const SupplierDashboard(),
        '/logistics' : (context) => const LogisticsDashboard(),
        '/finance' : (context) => const FinanceDashboard(),
        '/engineer' : (context) => const EngineersDashboard(),
        '/it' : (context) => const ItDashboard(),
        '/manager' : (context) => const ManagerDashboard()
      }
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  @override
  Widget build(context) {

    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          alignment: Alignment.center,
          child: const Text("Concept Dash", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),),
        ),
      );
  }

  void _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var val = (prefs.getString('auth-token')==null) ? 0 : prefs.getInt('isLoggedIn');
    switch (val) {
      case 0:
        Navigator.pushReplacementNamed(context, "/login");
        break;
      case 1:
        Navigator.pushReplacementNamed(context, "/admin");
        break;
      case 2:
        Navigator.pushReplacementNamed(context, "/supplier");
        break;
      case 3:
        Navigator.pushReplacementNamed(context, "/logistics");
        break;
      case 4:
        Navigator.pushReplacementNamed(context, "/finance");
        break;
      case 5:
        Navigator.pushReplacementNamed(context, "/manager");
        break;
      case 6:
        Navigator.pushReplacementNamed(context, "/engineer");
        break;
      case 7:
        Navigator.pushReplacementNamed(context, "/it");
        break;
    }
  }
}

