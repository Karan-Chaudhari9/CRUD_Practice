import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/pages/employee.dart';
import 'package:flutterdemo/service/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();


  getontheload() async {
    EmployeeStream = await DatabaseMethod().getEmployeeDetails();

    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Stream? EmployeeStream;

  Widget allEmployeeDetails() {
    return StreamBuilder(
        stream: EmployeeStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Name : " + ds["Name"],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        nameController.text = ds["Name"];
                                        ageController.text = ds["Age"];
                                        locationController.text = ds["Location"];
                                        editEmployeeDetails(ds["Id"]);
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    GestureDetector(
                                      onTap: () async{
                                        await DatabaseMethod().deleteEmployeeDetail(ds["Id"]);
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Age : " + ds["Age"],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Location : " + ds["Location"],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Employee()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flutter',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Firebase',
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(child: allEmployeeDetails()),
          ],
        ),
      ),
    );
  }

  Future editEmployeeDetails(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Edit',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Details',
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 80),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close)),
                  ],
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () async {
                  Map<String,dynamic>updateInfo = {
                    "Name" : nameController.text,
                    "Age" : ageController.text,
                    "Id" : id,
                    "Location" : locationController.text,
                  };
                  await DatabaseMethod().updateEmployeeDetail(id, updateInfo).then((value) => {
                    Navigator.pop(context)
                  });
                }, child: Text("Update"))
              ],
            ),
          ));
}
