// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:query_app/main.dart';
import 'package:query_app/online/household.dart';
import 'package:query_app/online/leaders_members.dart';
import 'package:query_app/online/main.dart';
import 'package:query_app/online/report.dart';
import 'package:query_app/online/settings.dart';
import 'package:query_app/source/accreditation_data_source.dart';

class AccreditationScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const AccreditationScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<AccreditationScreen> createState() => _AccreditationScreenState();
}

class _AccreditationScreenState extends State<AccreditationScreen> {
  final ROWS_PER_PAGE = 8;

  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> accreditations = [];
  List<String> barangayNames = [];
  String message = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController barangayController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController dateIsusuedController = TextEditingController();
  TextEditingController expirationController = TextEditingController();
  TextEditingController accreditationController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController organizationController = TextEditingController();
  TextEditingController sizeAreaController = TextEditingController();
  TextEditingController classificationController = TextEditingController();
  TextEditingController programsController = TextEditingController();
  TextEditingController probelmsController = TextEditingController();
  TextEditingController officerController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    barangayController.dispose();
    addressController.dispose();
    contactPersonController.dispose();
    dateIsusuedController.dispose();
    expirationController.dispose();
    accreditationController.dispose();
    phoneController.dispose();
    organizationController.dispose();
    sizeAreaController.dispose();
    classificationController.dispose();
    programsController.dispose();
    probelmsController.dispose();
    officerController.dispose();
    remarksController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    userData = widget.userData;

    fetchBarangayNames();
    fetchAccreditations();
  }

  Future<void> fetchAccreditations() async {
    final Uri apiUrl = Uri.parse('https://sweet-salvador.kenkarlo.com/PCUP-API/online/fetch_accreditations.php');
    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          setState(() {
            accreditations = List<Map<String, dynamic>>.from(data);
          });
        } else {
          // Handle the case where the API did not return a JSON array as expected.
          debugPrint('API did not return valid JSON data.');
        }
      } else {
        // Handle non-200 status codes, indicating an API error.
        debugPrint('API Error: Status Code ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions, such as network errors or invalid JSON data.
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> fetchBarangayNames() async {
    final Uri apiUrl = Uri.parse('https://sweet-salvador.kenkarlo.com/PCUP-API/online/fetch_baranggayName.php');
    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          final names = data.map((item) {
            // Extract the "Name" property from each object and convert it to a string
            return item['Name'].toString();
          }).toList();

          setState(() {
            barangayNames.clear();
            barangayNames.addAll(names);
          });
        } else {
          debugPrint('API did not return valid JSON data.');
        }
      } else {
        debugPrint('API Error: Status Code ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching barangay names: $e');
    }
  }

  bool _validateFields() {
/*     print("Name: ${nameController.text}");
    print("Barangay: ${barangayController.text}");
    print("Name: ${addressController.text}");
    print("Contact: ${contactPersonController.text}");
    print("date issued: ${dateIsusuedController.text}");
    print("expiration: ${expirationController.text}");
    print("accreditation number number: ${accreditationController.text}");
    print("phone number: ${phoneController.text}");
    print("programs: ${programsController.text}");
    print("classification: ${classificationController.text}");
    print("size area: ${sizeAreaController.text}");
    print("problems: ${probelmsController.text}");
    print("organization: ${organizationController.text}");
    print("officer: ${officerController.text}");
    print("remarks: ${remarksController.text}"); */

    return nameController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        contactPersonController.text.isNotEmpty &&
        dateIsusuedController.text.isNotEmpty &&
        expirationController.text.isNotEmpty &&
        accreditationController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        organizationController.text.isNotEmpty &&
        sizeAreaController.text.isNotEmpty &&
        classificationController.text.isNotEmpty &&
        probelmsController.text.isNotEmpty &&
        programsController.text.isNotEmpty &&
        officerController.text.isNotEmpty &&
        remarksController.text.isNotEmpty &&
        barangayController.text.isNotEmpty;
  }

  DateTime? selectIssueDate;
  DateTime? selectExpirationDate;
  String? selectRemarks;

  Future<void> _selectIssueDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectIssueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != selectIssueDate) {
      setState(() {
        selectIssueDate = picked;
        dateIsusuedController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectExpirationDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectExpirationDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != selectExpirationDate) {
      setState(() {
        selectExpirationDate = picked;
        expirationController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  Widget _buildModalContent(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Accreditation"),
      content: SingleChildScrollView(
        // Wrap the content in a SingleChildScrollView to make it scrollable
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Input fields
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name of Organization'),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Household Barangay'),
              value: barangayNames.isNotEmpty ? barangayNames[0] : null,
              items: barangayNames.map((String barangayName) {
                return DropdownMenuItem<String>(
                  value: barangayName,
                  child: Text(barangayName),
                );
              }).toList(),
              onChanged: (selectedBarangay) {
                setState(() {
                  barangayController.text = selectedBarangay ?? '';
                });
              },
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: contactPersonController,
              decoration: const InputDecoration(labelText: 'Contact Person'),
            ),
            TextFormField(
              controller: dateIsusuedController,
              decoration: const InputDecoration(
                labelText: 'Date Issued',
                hintText: 'Select date',
                labelStyle: TextStyle(color: Colors.grey),
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onTap: () {
                _selectIssueDate(context);
              },
            ),
            TextFormField(
              controller: expirationController,
              decoration: const InputDecoration(
                labelText: 'Expiration',
                hintText: 'Select date',
                labelStyle: TextStyle(color: Colors.grey),
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onTap: () {
                _selectExpirationDate(context);
              },
            ),
            TextField(
              controller: accreditationController,
              decoration: const InputDecoration(labelText: 'Accreditation Number'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: organizationController,
              decoration: const InputDecoration(labelText: 'Organization President'),
            ),
            TextField(
              controller: sizeAreaController,
              decoration: const InputDecoration(labelText: 'Size Area Of Organization'),
            ),
            TextField(
              controller: classificationController,
              decoration: const InputDecoration(labelText: 'Classification'),
            ),
            TextField(
              controller: programsController,
              decoration: const InputDecoration(labelText: 'Programs Availed'),
            ),
            TextField(
              controller: probelmsController,
              decoration: const InputDecoration(labelText: 'Common Problems'),
            ),
            TextField(
              controller: officerController,
              decoration: const InputDecoration(labelText: 'Accreditation Officer'),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Remarks'),
              value: selectRemarks,
              items: const [
                DropdownMenuItem(
                  value: 'NEW',
                  child: Text('NEW'),
                ),
              ],
              onChanged: (selectedItem) {
                setState(() {
                  selectRemarks = selectedItem;
                  remarksController.text = selectedItem!; // Update leaderPositionController
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            clearTextControllers();
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (_validateFields()) {
              _submitData();
              Navigator.of(context).pop(); // Close the dialog
            } else {
              _showRequiredFieldsAlert(context);
            }
          },
          child: const Text("Insert"),
        ),
      ],
    );
  }

  void clearTextControllers() {
    nameController.clear();
    barangayController.clear();
    addressController.clear();
    contactPersonController.clear();
    dateIsusuedController.clear();
    expirationController.clear();
    accreditationController.clear();
    phoneController.clear();
    organizationController.clear();
    sizeAreaController.clear();
    classificationController.clear();
    programsController.clear();
    probelmsController.clear();
    officerController.clear();
    remarksController.clear();
  }

  Widget _buildEditModalContent(BuildContext context, int index) {
    nameController = TextEditingController(text: accreditations[index]['accreditation_name'].toString());
    barangayController = TextEditingController(text: accreditations[index]['accreditation_barangay'].toString());
    addressController = TextEditingController(text: accreditations[index]['accreditation_address'].toString());
    contactPersonController = TextEditingController(text: accreditations[index]['accreditation_contactperson'].toString());
    dateIsusuedController = TextEditingController(text: accreditations[index]['accreditation_issued'].toString());
    expirationController = TextEditingController(text: accreditations[index]['accreditation_expired'].toString());
    accreditationController = TextEditingController(text: accreditations[index]['accreditation_number'].toString());
    phoneController = TextEditingController(text: accreditations[index]['accreditation_phone'].toString());
    organizationController = TextEditingController(text: accreditations[index]['accreditation_president'].toString());
    sizeAreaController = TextEditingController(text: accreditations[index]['accreditation_area'].toString());
    classificationController = TextEditingController(text: accreditations[index]['accreditation_type'].toString());
    programsController = TextEditingController(text: accreditations[index]['accreditation_programs'].toString());
    probelmsController = TextEditingController(text: accreditations[index]['accreditation_problems'].toString());
    officerController = TextEditingController(text: accreditations[index]['accreditation_coordinator'].toString());
    remarksController = TextEditingController(text: accreditations[index]['accreditation_remarks'].toString());
    selectRemarks = accreditations[index]['accreditation_remarks'].toString();

    return AlertDialog(
      title: const Text("Edit Accreditation"),
      content: SingleChildScrollView(
        // Wrap the content in a SingleChildScrollView to make it scrollable
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Input fields
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name of Organization'),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Household Barangay'),
              value: barangayNames.isNotEmpty ? barangayNames[0] : null,
              items: barangayNames.map((String barangayName) {
                return DropdownMenuItem<String>(
                  value: barangayName,
                  child: Text(barangayName),
                );
              }).toList(),
              onChanged: (selectedBarangay) {
                setState(() {
                  barangayController.text = selectedBarangay ?? '';
                });
              },
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: contactPersonController,
              decoration: const InputDecoration(labelText: 'Contact Person'),
            ),
            TextFormField(
              controller: dateIsusuedController,
              decoration: const InputDecoration(
                labelText: 'Date Issued',
                hintText: 'Select date',
                labelStyle: TextStyle(color: Colors.grey),
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onTap: () {
                _selectIssueDate(context);
              },
            ),
            TextFormField(
              controller: expirationController,
              decoration: const InputDecoration(
                labelText: 'Expiration',
                hintText: 'Select date',
                labelStyle: TextStyle(color: Colors.grey),
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onTap: () {
                _selectExpirationDate(context);
              },
            ),
            TextField(
              controller: accreditationController,
              decoration: const InputDecoration(labelText: 'Accreditation Number'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: organizationController,
              decoration: const InputDecoration(labelText: 'Organization President'),
            ),
            TextField(
              controller: sizeAreaController,
              decoration: const InputDecoration(labelText: 'Size Area Of Organization'),
            ),
            TextField(
              controller: classificationController,
              decoration: const InputDecoration(labelText: 'Classification'),
            ),
            TextField(
              controller: programsController,
              decoration: const InputDecoration(labelText: 'Programs Availed'),
            ),
            TextField(
              controller: probelmsController,
              decoration: const InputDecoration(labelText: 'Common Problems'),
            ),
            TextField(
              controller: officerController,
              decoration: const InputDecoration(labelText: 'Accreditation Officer'),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Remarks'),
              value: selectRemarks,
              items: const [
                DropdownMenuItem(
                  value: 'NEW',
                  child: Text('NEW'),
                ),
                DropdownMenuItem(
                  value: 'APPROVED',
                  child: Text('APPROVED'),
                ),
              ],
              onChanged: (selectedItem) {
                setState(() {
                  selectRemarks = selectedItem;
                  remarksController.text = selectedItem!; // Update leaderPositionController
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            clearTextControllers();
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (_validateFields()) {
              _submitUpdatedData(index);
              Navigator.of(context).pop(); // Close the dialog
            } else {
              _showRequiredFieldsAlert(context);
            }
          },
          child: const Text("Update"),
        ),
      ],
    );
  }

  Widget _buildListTile(String title, IconData iconData, double fontSize, VoidCallback onTap) {
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

  void _showRequiredFieldsAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Required Fields"),
          content: const Text("Please fill in all required fields."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

// ...
  void _submitData() async {
    final apiUrl = Uri.parse('https://sweet-salvador.kenkarlo.com/PCUP-API/online/add_accreditation.php');
    final response = await http.post(
      apiUrl,
      body: {
        'accreditation_name': nameController.text,
        'accreditation_barangay': barangayController.text,
        'accreditation_address': addressController.text,
        'accreditation_contactperson': contactPersonController.text,
        'accreditation_issued': dateIsusuedController.text,
        'accreditation_expired': expirationController.text,
        'accreditation_number': accreditationController.text,
        'accreditation_phone': phoneController.text,
        'accreditation_president': organizationController.text,
        'accreditation_area': sizeAreaController.text,
        'accreditation_class': classificationController.text,
        'accreditation_programs': programsController.text,
        'accreditation_problems': probelmsController.text,
        'accreditation_coordinator': officerController.text,
        'accreditation_remarks': remarksController.text,
      },
    );
    debugPrint(response.body);
    if (response.statusCode == 200) {
      fetchAccreditations();

      WidgetsBinding.instance.addPostFrameCallback((_) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully Added'),
            ),
          ));

      clearTextControllers();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit data'),
            ),
          ));
    }
  }

  void _submitUpdatedData(int index) async {
    final apiUrl = Uri.parse('https://sweet-salvador.kenkarlo.com/PCUP-API/online/update_accreditation.php');
    final response = await http.post(
      apiUrl,
      body: {
        'accreditation_id': accreditations[index]['accreditation_id'],
        'accreditation_name': nameController.text,
        'accreditation_barangay': barangayController.text,
        'accreditation_address': addressController.text,
        'accreditation_contactperson': contactPersonController.text,
        'accreditation_issued': dateIsusuedController.text,
        'accreditation_expired': expirationController.text,
        'accreditation_number': accreditationController.text,
        'accreditation_phone': phoneController.text,
        'accreditation_president': organizationController.text,
        'accreditation_area': sizeAreaController.text,
        'accreditation_class': classificationController.text,
        'accreditation_programs': programsController.text,
        'accreditation_problems': probelmsController.text,
        'accreditation_coordinator': officerController.text,
        'accreditation_remarks': remarksController.text,
      },
    );
    debugPrint(response.body);
    if (response.statusCode == 200) {
      await fetchAccreditations();
      setState(() {}); // Reload the screen to display the newly fetched data

      WidgetsBinding.instance.addPostFrameCallback((_) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully Updated'),
            ),
          ));

      clearTextControllers();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit updated data'),
            ),
          ));
    }
  }
// ...

  void _navigateToScreen(String routeName) {
    Navigator.of(context).pop(); // Close the sidebar
    switch (routeName) {
      case 'Home':
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePageOnline(userData: widget.userData)));
        break;
      case 'Accreditation':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AccreditationScreen(
                      userData: widget.userData,
                    )));
        break;
      case 'Leaders and Members':
        Navigator.push(context, MaterialPageRoute(builder: (context) => LeadersScreen(userData: widget.userData)));
        break;
      case 'Household':
        Navigator.push(context, MaterialPageRoute(builder: (context) => houseHoldScreen(userData: widget.userData)));
        break;
      case 'Report':
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen(userData: widget.userData)));
        break;
      case 'Settings':
        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(userData: widget.userData)));
        break;
      case 'Logout':
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(userData: widget.userData)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.userData;
    const userImage = AssetImage('assets/images/avatar.png');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accreditation'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage: userImage,
                          ),
                          Text(
                            '${userData['user_name']}',
                            style: const TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${userData['user_email']}',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildListTile('Home', Icons.home, 16, () {
              _navigateToScreen('Home');
            }),
            _buildListTile('Accreditation', Icons.verified_user, 16, () {
              _navigateToScreen('Accreditation');
            }),
            _buildListTile('Leaders and Members', Icons.group, 16, () {
              _navigateToScreen('Leaders and Members');
            }),
            _buildListTile('Household', Icons.home_work, 16, () {
              _navigateToScreen('Household');
            }),
            _buildListTile('Report', Icons.list_alt_rounded, 16, () {
              _navigateToScreen('Report');
            }),
            _buildListTile('Settings', Icons.settings, 16, () {
              _navigateToScreen('Settings');
            }),
            _buildListTile('Logout', Icons.logout, 16, () {
              _navigateToScreen('Logout');
            }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: PaginatedDataTable(
          columns: const [
            DataColumn(label: Text("accreditation_id")),
            DataColumn(label: Text("accreditation_name")),
            DataColumn(label: Text("accreditation_barangay")),
            DataColumn(label: Text("BarangayID")),
            DataColumn(label: Text("accreditation_address")),
            DataColumn(label: Text("accreditation_contactperson")),
            DataColumn(label: Text("accreditation_phone")),
            DataColumn(label: Text("accreditation_number")),
            DataColumn(label: Text("accreditation_issued")),
            DataColumn(label: Text("accreditation_expired")),
            DataColumn(label: Text("accreditation_president")),
            DataColumn(label: Text("accreditation_type")),
            DataColumn(label: Text("accreditation_ddress")),
            DataColumn(label: Text("accreditation_members")),
            DataColumn(label: Text("accreditation_population")),
            DataColumn(label: Text("accreditation_belowm")),
            DataColumn(label: Text("accreditation_belowf")),
            DataColumn(label: Text("accreditation_belowo")),
            DataColumn(label: Text("accreditation_abovem")),
            DataColumn(label: Text("accreditation_abovef")),
            DataColumn(label: Text("accreditation_aboveo")),
            DataColumn(label: Text("accreditation_area")),
            DataColumn(label: Text("accreditation_class")),
            DataColumn(label: Text("accreditation_programs")),
            DataColumn(label: Text("accreditation_problems")),
            DataColumn(label: Text("accreditation_coordinator")),
            DataColumn(label: Text("accreditation_created")),
            DataColumn(label: Text("accreditation_remarks")),
          ],
          source: AccreditationDataSource(
            data: accreditations,
            onLongPress: (int selectedIndex) => showDialog(
              context: context,
              builder: (context) => _buildEditModalContent(context, selectedIndex),
            ),
          ),
          rowsPerPage: accreditations.length < ROWS_PER_PAGE ? accreditations.length + 1 : ROWS_PER_PAGE,
          header: const Center(
            child: Text("Accreditations"),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return _buildModalContent(context); // Call the method here
            },
          );
        },
        label: const Text('Add Accreditation'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
