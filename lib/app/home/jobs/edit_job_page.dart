import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/CommonWidgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/CommonWidgets/show_exception_alert_dialog.dart';
import '../../services/database.dart';

import '../models/job.dart';
class EditJobPage extends StatefulWidget {
  const EditJobPage({Key? key, required this.database, this.job}) : super(key: key);
  final Database database;
  final Job? job;

  static Future<void> show(BuildContext context,{Job? job, Database? database} ) async{
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EditJobPage(database: database!, job: job,),
      ),
    );
  }

  @override
  _AddJobFormPageState createState() => _AddJobFormPageState();
}

class _AddJobFormPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _ratePerHourFocusNode = FocusNode();
  String? _name;
  int? _ratePerHour;
  @override
  void initState(){
    super.initState();
    if(widget.job != null){
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }

  }

  bool _validateAndSaveForm(){
    final form = _formKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async{
    if(_validateAndSaveForm()){
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        print(allNames.contains(_name) && widget.job == null);
          if(allNames.contains(_name) && ( widget.job == null || widget.job!.name != _name)){
            print('name allready used');
            showAlertDialog(
                context,
                title: 'Name allready used',
                content: 'Please choose another job name',
                defaultActionText: 'OK');
          }else{
            print('job added');
            String documentIdGenerator() => DateTime.now().toIso8601String();
            final id = widget.job?.id ?? documentIdGenerator();
            final job = Job(name: _name!, ratePerHour: _ratePerHour!, id: id);
            print('normally widget should pop');
            await widget.database.setJob(job);
            Navigator.of(context).pop();
          }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation Failed',
          exception: e,
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job==null ? 'New Job' : 'Edite Job'),
        elevation: 2.0,
        actions: [
          TextButton(
              onPressed: _submit,
              child: const Text('Save', style: TextStyle(fontSize: 18, color: Colors.white),)
          )
        ],
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }
  Widget _buildContent() {
    return  SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }
  void _onNameEditingComplete() {
    FocusScope.of(context).requestFocus(_ratePerHourFocusNode);
  }
  List<Widget> _buildFormChildren() {
    return[
      TextFormField(
        decoration: const InputDecoration(labelText: 'Job name'),
        onSaved: (value) => _name = value!,
        validator: (value) => value!.isEmpty? 'Name can\'t be empty' : null,
        onEditingComplete: _onNameEditingComplete,
        focusNode: _nameFocusNode,
        initialValue: _name,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Rate per hour'),
        keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
        onSaved: (value) => _ratePerHour = int.tryParse(value!) ?? 0,
        validator: (value) => value!.isEmpty? 'Rate per hour can\'t be empty' : null,
        onEditingComplete: _submit,
        focusNode: _ratePerHourFocusNode,
        initialValue: _ratePerHour != null ? _ratePerHour.toString() : null,

      ),
    ];
  }




}
