import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';

import '../../services/auth.dart';
import '../../services/database.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({
    super.key,
  });

  //----------------------------------------------------------------------------
  // Sign Out
  //----------------------------------------------------------------------------

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false); //[217]
      await auth.signOut(); // new
    } catch (e) {
      print(e.toString());
      print('Could not sign out');
    }
  }

  // [210] - sign out dialog
  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      defaultActionText: 'Yes',
      cancelActionText: 'No',
    );
    if (didRequestSignOut == true) {
      // ignore: use_build_context_synchronously
      _signOut(context);
    }
  }

  //----------------------------------------------------------------------------
  // Create Job - button method
  //----------------------------------------------------------------------------

  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(
        name: 'Blogging',
        ratePerHour: 100,
      ));
    } on FirebaseException catch (e) {
      // [285]
      showExceptionAlertDialog(
        context,
        title: 'Operation failes',
        exception: e,
      );
    }
  }

  //----------------------------------------------------------------------------
  // Body Contents
  //----------------------------------------------------------------------------

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs?.map((job) => Text(job.name)).toList();
          return ListView(
            children: children!,
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Some error occured'),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  //----------------------------------------------------------------------------
  // Build
  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          TextButton(
            // onPressed: _signOut,
            onPressed: () => _confirmSignOut(context), //210
            child: const Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: ElevatedButton(
        onPressed: () => _createJob(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
