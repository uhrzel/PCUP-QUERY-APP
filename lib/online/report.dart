import 'package:flutter/material.dart';
import 'package:query_app/online/login.dart';
import 'package:query_app/online/settings.dart';
import 'package:query_app/online/leaders_members.dart';
import 'package:query_app/online/accreditation.dart';
import 'package:query_app/online/household.dart';
import 'package:query_app/online/main.dart';

class ReportScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  ReportScreen({required this.userData});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  Widget _buildListTile(BuildContext context, String title, IconData iconData,
      double fontSize, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(
            iconData,
            color: Colors.black,
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: fontSize),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, String routeName) {
    Navigator.of(context).pop(); // Close the sidebar
    switch (routeName) {
      case 'Home':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyHomePageOnline(userData: widget.userData)));
        break;
      case 'Accreditation':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AccreditationScreen(userData: widget.userData)));
        break;
      case 'Leaders and Members':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LeadersScreen(userData: widget.userData)));
        break;
      case 'Household':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    houseHoldScreen(userData: widget.userData)));
        break;
      case 'Report':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReportScreen(userData: widget.userData)));
        break;
      case 'Settings':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SettingsScreen(userData: widget.userData)));
        break;
      case 'Logout':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginScreen(userData: widget.userData)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.userData;
    final userImage = AssetImage('assets/images/avatar.png');
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                      
                            radius: 30,
                            backgroundImage: userImage,
                          ),
                          Text(
                            '${userData['user_name']}',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${userData['user_email']}',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildListTile(
                context, // Pass the context
                'Home',
                Icons.home,
                16, () {
              _navigateToScreen(
                  context, 'Home'); // Pass context to _navigateToScreen
            }),
            _buildListTile(
                context, // Pass the context
                'Accreditation',
                Icons.verified_user,
                16, () {
              _navigateToScreen(context,
                  'Accreditation'); // Pass context to _navigateToScreen
            }),
            _buildListTile(
                context, // Pass the context
                'Leaders and Members',
                Icons.group,
                16, () {
              _navigateToScreen(context,
                  'Leaders and Members'); // Pass context to _navigateToScreen
            }),
            _buildListTile(
                context, // Pass the context
                'Household',
                Icons.home_work,
                16, () {
              _navigateToScreen(
                  context, 'Household'); // Pass context to _navigateToScreen
            }),
            _buildListTile(
                context, // Pass the context
                'Report',
                Icons.list_alt_rounded,
                16, () {
              _navigateToScreen(
                  context, 'Report'); // Pass context to _navigateToScreen
            }),
            _buildListTile(
                context, // Pass the context
                'Settings',
                Icons.settings,
                16, () {
              _navigateToScreen(
                  context, 'Settings'); // Pass context to _navigateToScreen
            }),
            _buildListTile(
                context, // Pass the context
                'Logout',
                Icons.logout,
                16, () {
              _navigateToScreen(
                  context, 'Logout'); // Pass context to _navigateToScreen
            }),
          ],
        ),
      ),
      body: Center(
        child: Text('Report Screen Content'),
      ),
    );
  }
}
