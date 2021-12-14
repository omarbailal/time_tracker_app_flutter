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
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white,),
            onPressed: () => EditJobPage.show(
                context,
                database: Provider.of<Database>(context, listen: false)
            ),
          ),
        ],
      ),
      body: _buildContents(context),
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
