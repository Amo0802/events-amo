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
}
