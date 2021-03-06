import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/CommonWidgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/entry_list_item.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/entry_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/list_item_builder.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import '../../services/database.dart';


class JobEntriesPage extends StatelessWidget {
   const JobEntriesPage({Key? key, required this.database, required this.job}) : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context,Job job) async {
    final Database database = Provider.of<Database>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context,Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
      stream: database.jobStream(jobId: job.id),
      builder: (context, snapshot) {
        final job = snapshot.data;
        final jobName = job?.name ?? '';
        return Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            title: Text(jobName),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white,),
                onPressed: () => EditJobPage.show(context, job: job, database: database),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white,),
                onPressed: () => EntryPage.show(
                  context: context,
                  database: database,
                  job: job!,
                ),
              ),
            ],
          ),
          body: _buildContent(context, job!),
        );
      }
    );
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
