import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker/app/home/jobs/empty_content.dart';
import 'package:time_tracker/app/home/jobs/job_list_tile.dart';
import 'package:time_tracker/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';

import '../../../services/auth.dart';
import '../../../services/database.dart';

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
  // Create Job - button method -> depreceated. [298]
  //----------------------------------------------------------------------------

  // Future<void> _createJob(BuildContext context) async {
  //   try {
  //     final database = Provider.of<Database>(context, listen: false);
  //     await database.createJob(Job(
  //       name: 'Blogging',
  //       ratePerHour: 100,
  //     ));
  //   } on FirebaseException catch (e) {
  //     // [285]
  //     showExceptionAlertDialog(
  //       context,
  //       title: 'Operation failes',
  //       exception: e,
  //     );
  //   }
  // }

  //----------------------------------------------------------------------------
  // Delete method
  //----------------------------------------------------------------------------

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
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
        // [316]
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            background: Container(
              color: Colors.red,
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            key: Key('job-${job.id}'),
            child: JobListTile(
              job: job,
              onTap: () => EditJobPage.show(context, job: job),
            ),
          ),
        );
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
        // onPressed: () => _createJob(context),
        onPressed: () => EditJobPage.show(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
