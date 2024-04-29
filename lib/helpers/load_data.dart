import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stdominicsadmin/models/timetable_item_data.dart';
import 'package:stdominicsadmin/models/timetable_model.dart';
import '../models/announcement_model.dart';
import '../models/class_subject_model.dart';
import '../models/guardian_model.dart';
import '../models/institution_model.dart';
import '../models/result_model.dart';
import '../models/results_reason_model.dart';
import '../models/student_model.dart';
import '../models/teacher_model.dart';

class LoadData {
  FirebaseFirestore fs = FirebaseFirestore.instance;

  Future<InstitutionModel> getInstitution({institutionId})async{
    var data = await fs.collection('institutions').doc(institutionId).get();

    InstitutionModel institution = InstitutionModel(
        uid: data.id,
        name: data.get('name'),
        admin: data.get('admin'),
        country: data.get('country'),
        district: data.get('district'),
        province: data.get('province'),
        motto: data.get('motto'),
        logo: data.get('logo'),
        status: data.get('status'), 
        subscriptionType: data.get('subscription'),
        type: data.get('type')
    );

    return institution;
  }

  Future<List<ClassSubjectModel>>getMyClasses(teacherID)async{
    List<ClassSubjectModel> myclasses = [];
    var data = await fs.collection('my_classes').where('tutor', isEqualTo: teacherID).get();

    for(var item in data.docs){
      ClassSubjectModel myclass = ClassSubjectModel(teacher: item.get('tutor'), academicYear: item.get('academic_year'), course: item.get('course'), programme: item.get('programme'));

      myclasses.add(myclass);
    }
    return myclasses;
  }

  Future<List<StudentModel>>getAllStudents(institutionID)async{
    List<StudentModel> students = [];
    var data = await fs.collection('students').where('institutionID', isEqualTo: institutionID).get();

    for(var item in data.docs){
      StudentModel student = StudentModel(
        uid: item.id,
        name: item.get('displayName'),
        academicYear: item.get('academic_year'),
        programme: item.get('programme'),
        photo: item.get('photo') ?? '',
        email: item.get('email'),
        gender: item.get('gender'),
        intake: item.get('intake'),
        isfreezed: item.get('isfreezed'),
        guardianPhone: item.get('guardianPhone') ?? '',  // Check if field exists and provide default value if not
        guardianRelationship: item.get('guardianRelationship') ?? '',  // Check if field exists and provide default value if not
      );

      students.add(student);
    }
    return  students;
  }

  Future<List<ReasonModel>>getReasons(institutionID)async{
    List<ReasonModel> reasons = [];
    var data = await fs.collection('results_reason').where('institutionID', isEqualTo: institutionID).get();

    for(var item in data.docs){
      ReasonModel reason = ReasonModel(reason: item.get('reason'));

      reasons.add(reason);
    }
    return reasons;
  }

  Future<List<ResultModel>>getResults(teacherID)async{
    List<ResultModel> results = [];
    var data = await fs.collection('results').where('tutor', isEqualTo: teacherID).get();

    for(var item in data.docs){
      ResultModel result = ResultModel(
          id: item.id,
          marks: item.get('marks'), 
          course: item.get('course'), 
          academicYear: item.get('academic_year'), 
          reason: item.get('reason'), 
          tutor: item.get('tutor'), 
          studentId: item.get('student_id'), 
          datetime: item.get('tutor')
      );

      results.add(result);
    }
    return results;
  }

  Future<List<GuardianModel>>getGuardians()async{
    List<GuardianModel> guardians = [];
    var data = await fs.collection('guardians').get();

    for(var item in data.docs){
      GuardianModel result = GuardianModel(
          name: item.get('name'),
          phone: item.get('phone')
      );

      guardians.add(result);
    }
    return guardians;
  }

  Future<List<AnnouncementModel>>getAnnouncements(institutionID)async{
    List<AnnouncementModel> announcements = [];
    var data = await fs.collection('notice_board').where('institutionID', isEqualTo: institutionID).get();

    for(var item in data.docs){
      AnnouncementModel announcement = AnnouncementModel(uid: item.id, announcement: item.get('notice'));

      announcements.add(announcement);
    }
    return announcements;
  }
  
  Future<List<TeacherModel>>getAllTeachers(institutionID)async{
    List<TeacherModel> teachers = [];
    var data = await fs.collection('tutor').where('institutionID', isEqualTo: institutionID).get();

    for(var item in data.docs){
      TeacherModel teacher = TeacherModel(uid: item.id, fullname: item.get('name'), email: item.get('email'), institutionID: item.get('institutionID'), photo: item.get('photo'), password: item.get('password'));

      teachers.add(teacher);
    }
    return teachers;
  }

  Future<List<TimetableModel>>getSchoolTimetables(institutionID)async{
    List<TimetableModel> timetables = [];
    var data = await fs.collection('timetable').where('institutionID', isEqualTo: institutionID).get();

    for(var item in data.docs){

      List<TimetableItemData> data = item.get('items').map<TimetableItemData>((e)=>
          TimetableItemData(description: e['description'], start: e['start'], end: e['end'], teacher: e['teacher'])
      ).toList();

      TimetableModel timetable = TimetableModel(
          id: item.id,
          title: item.get('title'),
          description: item.get('description'),
          audience: item.get('audience'),
          days: item.get('days'),
          data: data,
          datetime: item.get('datetime'),
          teacher: item.get('teacher')
      );

      timetables.add(timetable);
    }
    return timetables;
  }


  addMissingFields(institutionID)async{
    var students = await fs.collection('students').where('institutionID', isEqualTo: institutionID).get();

    for(var student in students.docs){
      var data = {
        'guardianPhone': '0962407441',  // Check if field exists and provide default value if not
        'guardianRelationship': 'Father',
      };

      await fs.collection('students').doc(student.id).update(data);
    }
  }
}