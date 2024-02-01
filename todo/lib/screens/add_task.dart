// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AddTask extends StatefulWidget {
//   @override
//   _AddTaskState createState() => _AddTaskState();
// }

// class _AddTaskState extends State<AddTask> {
//   TextEditingController titleController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();

//   addTaskToFirebase() async {
//     User user = await FirebaseAuth.instance.currentUser!;
//     String uid = user.uid;
//     var time = DateTime.now();
//     await FirebaseFirestore.instance
//         .collection('tasks')
//         .doc(uid)
//         .collection('mytasks')
//         .doc(time.toString())
//         .set({
//       'title': titleController.text,
//       'description': descriptionController.text,
//       'time': time.toString(),
//       'timestamp': time,
//     });
//     Fluttertoast.showToast(msg: 'Data Added');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('New Task')),
//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Container(
//               child: TextField(
//                 controller: titleController,
//                 decoration: InputDecoration(
//                   labelText: 'Enter Title',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             Container(
//               // padding: EdgeInsets.symmetric(vertical: 150),
//               child: TextField(
//                 controller: descriptionController,
//                 maxLines: null,
//                 decoration: InputDecoration(
//                   labelText: 'Enter Description',
//                   border: OutlineInputBorder(),
//                 ),
//                 textInputAction: TextInputAction.newline,
//               ),
//             ),
//             SizedBox(height: 10),
//             Container(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                     (Set<MaterialState> states) {
//                       if (states.contains(MaterialState.pressed))
//                         return Colors.purple.shade100;
//                       return Theme.of(context).primaryColor;
//                     },
//                   ),
//                 ),
//                 child: Text(
//                   'Add Task',
//                   style: GoogleFonts.roboto(fontSize: 18),
//                 ),
//                 onPressed: () {
//                   addTaskToFirebase();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isAddingTask = false;

  Future<void> addTaskToFirebase() async {
    setState(() {
      isAddingTask = true;
    });

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var time = DateTime.now();
      try {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(user.uid)
            .collection('mytasks')
            .doc(time.toString())
            .set({
          'title': titleController.text,
          'description': descriptionController.text,
          'time': time.toString(),
          'timestamp': time,
        });

        Fluttertoast.showToast(msg: 'Data Added');
      } catch (error) {
        print('Error adding task: $error');
        Fluttertoast.showToast(msg: 'Failed to add task');
      }

      setState(() {
        isAddingTask = false;
      });
    } else {
      setState(() {
        isAddingTask = false;
      });
      Fluttertoast.showToast(msg: 'User not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Task')),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Enter Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              child: SingleChildScrollView(
                child: TextField(
                  controller: descriptionController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Enter Description',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.newline,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.purple.shade100;
                      return Theme.of(context).primaryColor;
                    },
                  ),
                ),
                // ignore: sort_child_properties_last
                child: isAddingTask
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        'Add Task',
                        style: GoogleFonts.roboto(fontSize: 18),
                      ),
                onPressed: isAddingTask ? null : addTaskToFirebase,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
