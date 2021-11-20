import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/CommonWidgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/CommonWidgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/empty_content.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/job_list_item.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/list_item_builder.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';
import '../../services/database.dart';

import 'edit_job_page.dart';
import '../models/job.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({Key? key}) : super(key: key);



  Future<void> _signOut(BuildContext context) async{
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    }catch(e){
      print('sign out err: ${e.toString()}');
    }
  }
  Future<void> _confirmSignOut(BuildContext context) async{
    final didRequestSignout = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      cancelActionText: 'cancel',
      defaultActionText: 'logout'
    );
    if(didRequestSignout == true) {
      _signOut(context);
    }
  }
  Future<void> _delete(BuildContext context, Job job) async{
    final database = Provider.of<Database>(context, listen: false);
    try {
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs Page'),
        actions: <Widget>[
          FlatButton(
            child: const Text('Logout' , style: TextStyle(fontSize: 18.0, color: Colors.white),),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => EditJobPage.show(
            context,
            database: Provider.of<Database>(context, listen: false)
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Job?>>(
      stream: database.jobsStream(),
      builder: (context, snapshot){
        return ListItemBuilder<Job?>(
            snapshot: snapshot,
            itemBuilder: (context, job) => Dismissible(
              key: Key('job-${job!.id}'),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) =>  _delete(context, job),
              child: JobListTile(
                  job: job,
                  onTap: ()=> JobEntriesPage.show(context, job),
              ),
            ),
        );
      },
    );
  }




}
