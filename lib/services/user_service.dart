import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../models/event.dart';
import 'api_client.dart';

class UserService {
  final ApiClient _apiClient;

  UserService(this._apiClient);

  Future<void> saveEvent(int eventId) async {
    await _apiClient.post('/user/save-event/$eventId', {});
  }

  Future<void> unsaveEvent(int eventId) async {
    await _apiClient.delete('/user/unsave-event/$eventId');
  }

  Future<List<Event>> getSavedEvents() async {
    final json = await _apiClient.get('/user/saved-events');
    return (json as List).map((item) => Event.fromJson(item)).toList();
  }

  Future<void> attendEvent(int eventId) async {
    await _apiClient.post('/user/attend-event/$eventId', {});
  }

  Future<void> unattendEvent(int eventId) async {
    await _apiClient.delete('/user/unattend-event/$eventId');
  }

  Future<List<Event>> getAttendingEvents() async {
    final json = await _apiClient.get('/user/attending-events');
    return (json as List).map((item) => Event.fromJson(item)).toList();
  }

    Future<void> deleteCurrentUser() async {
    await _apiClient.delete('/user/current');
  }

  Future<void> deleteUser(int userId) async {
    await _apiClient.delete('/user/$userId');
  }

  Future<void> submitEventProposal(Event event, List<XFile> images) async {
    // Create FormData
    FormData formData = FormData();
    
    // Add text fields from the event object
    final eventData = event.toJson();
    for (var entry in eventData.entries) {
      formData.fields.add(MapEntry(entry.key, entry.value.toString()));
    }
    
    // Add image files
  for (var image in images) {
    formData.files.add(MapEntry(
      'images',
      await MultipartFile.fromFile(
        image.path,
        filename: image.name,
      ),
    ));
  }
    
    // Send request
    await _apiClient.postFormData('/user/submit-event', formData, requiresAuth: false);
  }
}
