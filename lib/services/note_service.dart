import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/services/api_service.dart';

class NoteService {
  final ApiService apiService = ApiService.create();

  Future createNote(
    String contactId,
    String note,
    String timesheetId,
    List<String> listImagePath,
  ) async {
    try {
      Map<String, dynamic> body = {
        'contact': contactId,
        'content_type': contentType['Timesheet'],
        'note': note,
        'object_id': timesheetId,
      };

      http.Response res =
        await apiService.post(path: 'core/notes/', body: body);

      if (res.statusCode == 201) {
        Map<String, dynamic> resBody = json.decode(utf8.decode(res.bodyBytes));
        
        String noteId = resBody["id"];
        Map<String, dynamic> fields = {
          'note': noteId,
        };

        await Future.wait(
          listImagePath.map((file) => 
            apiService.uploadFile(
              path: '/core/notefiles/',
              fields: fields,
              fileField: 'file',
              filePath: file,
            )
          )
        );
      } else {
        throw Exception('Failed to create a note.');
      }
    } catch (e) {
      print(e);
    }
  }
}
