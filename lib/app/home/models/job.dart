
class Job {
  Job( {required this.id, required this.name, required this.ratePerHour});
  final String id;
  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data, String id){
    final name = data['name'];
    final ratePerHour = data['ratePerHour'];
    return Job(
        id: id,
        name: name,
        ratePerHour: ratePerHour
    );
  }
  Map<String, dynamic> toMap(){
    return{
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}