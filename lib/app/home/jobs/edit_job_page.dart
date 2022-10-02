// [297]
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';

import '../../../services/database.dart';
import '../models/job.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({super.key, required this.database, required this.job});

  final Database database; // [301]
  final Job? job; // [308]

  // instead of using Navigator inside of the job_page
  // onPressed - we are using show method to display this class
  // * context inside show method comes from jobs_page
  // * as it's called from inside of jobs_page
  static Future<void> show(BuildContext context, {Job? job}) async {
    // [301]
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<EditJobPage> createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  // use the key to access the state of the form
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job?.name;
      _ratePerHour = widget.job?.ratePerHour;
    }
  }

  //----------------------------------------------------------------------------
  //  Contents
  //----------------------------------------------------------------------------

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  //  Form
  //----------------------------------------------------------------------------

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _name,
        decoration: const InputDecoration(labelText: 'Job name'),
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: ((newValue) => _name = newValue!),
      ),
      TextFormField(
        initialValue: _ratePerHour != null ? '$_ratePerHour' : '',
        decoration: const InputDecoration(labelText: 'Rate per hour'),
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (newValue) => _ratePerHour = int.tryParse(newValue!),
      ),
    ];
  }

  //----------------------------------------------------------------------------
  //  Submit & validate method
  //----------------------------------------------------------------------------

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((e) => e.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job?.name);
          Navigator.of(context).pop();
        }
        if (allNames.contains(_name)) {
          // ignore: use_build_context_synchronously
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose different name',
            defaultActionText: 'OK',
          );
        } else {
          // [310]
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(
            name: _name!,
            ratePerHour: _ratePerHour!,
            id: id,
          );
          await widget.database.setJob(job);
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        }
      } on FirebaseAuthException catch (e) {
        showExceptionAlertDialog(context,
            title: "Failed to Save", exception: e);
      }
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  //----------------------------------------------------------------------------
  //  Main Build
  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        elevation: 2.0,
        actions: <Widget>[
          TextButton(
            onPressed: _submit,
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }
}
