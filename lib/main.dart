import 'package:crm/admin/add_data.dart';
import 'package:crm/admin/admin.dart';
import 'package:crm/admin/assets.dart';
import 'package:crm/admin/budgets.dart';
import 'package:crm/admin/companies.dart';
import 'package:crm/admin/competitor.dart';
import 'package:crm/admin/customers.dart';
import 'package:crm/admin/employees.dart';
import 'package:crm/admin/pending_requests.dart';
import 'package:crm/admin/projects.dart';
import 'package:crm/admin/proposals.dart';
import 'package:crm/admin/requests.dart';
import 'package:crm/admin/rfp.dart';
import 'package:crm/admin/technical_request.dart';
import 'package:crm/engineers/engineers_dashboard.dart';
import 'package:crm/engineers/projects.dart' as engineer_projects;
import 'package:crm/finances/finances_dashboard.dart';
import 'package:crm/it/it_dashboard.dart';
import 'package:crm/login.dart';
import 'package:crm/logistics/dashboard.dart';
import 'package:crm/manager/manager_dashboard.dart';
import 'package:crm/suppliers/suppliers_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin/data_mining.dart';
import 'admin/inventory.dart';
import 'admin/products.dart';

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
        '/budgets' : (context) => const Budgets(),
        '/rfps' : (context) => const Rfp(),
        '/requests' : (context) => const Requests(),
        '/pendingRequests' : (context) => const PendingRequests(),
        '/assets' : (context) => const Assets(),
        '/companies' : (context) => const Companies(),
        '/proposals' : (context) => const Proposals(),

        //Other Dashboards
        '/supplier' : (context) => const SupplierDashboard(),
        '/logistics' : (context) => const LogisticsDashboard(),
        '/finance' : (context) => const FinanceDashboard(),

        //Engineer Dashboard
        '/engineer' : (context) => const EngineersDashboard(),
        '/engineerProjects' : (context) => const engineer_projects.Projects(),

        '/it' : (context) => const ItDashboard(),
        '/manager' : (context) => const ManagerDashboard(),
        '/competitor' : (context) => const Competitor(),
        '/products' : (context) => const Products(),
        '/mining' : (context) => const Mining(),
        '/inventory' : (context) => const Inventory(),
        '/technicalRequest' : (context) => const TechnicalRequest()
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
          child: const Text("NextGlobal", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),),
        ),
      );
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val = prefs.getString('auth-token')==null ? "" : prefs.getString('isLoggedIn');
    switch (val) {
      case "":
        Navigator.pushReplacementNamed(context, "/login");
        break;
      case "Admin":
        Navigator.pushReplacementNamed(context, "/admin");
        break;
      case "Supplier":
        Navigator.pushReplacementNamed(context, "/supplier");
        break;
      case "Logistics":
        Navigator.pushReplacementNamed(context, "/logistics");
        break;
      case "Sales":
        Navigator.pushReplacementNamed(context, "/finance");
        break;
      case "Manager":
        Navigator.pushReplacementNamed(context, "/manager");
        break;
      case "Engineer":
        Navigator.pushReplacementNamed(context, "/engineer");
        break;
      case "IT":
        Navigator.pushReplacementNamed(context, "/it");
        break;
    }
  }
}

