import 'package:flutter/foundation.dart';
import '../models/auth_request.dart';
import '../models/register_request.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  
  AuthStatus _status = AuthStatus.initial;
  User? _currentUser;
  String? _error;
  
  AuthProvider(this._authService) {
    _checkAuthStatus();
  }
  
  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  String? get error => _error;
  
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  
  Future<void> _checkAuthStatus() async {
    try {
      final isAuthenticated = await _authService.isAuthenticated();
      
      if (isAuthenticated) {
        _currentUser = await _authService.getCurrentUser();
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.toString();
    }
    
    notifyListeners();
  }
  
  Future<bool> register(String name, String lastName, String email, String password) async {
    try {
      _error = null;
      
      final request = RegisterRequest(
        name: name,
        lastName: lastName,
        email: email,
        password: password,
      );
      
      await _authService.register(request);
      _currentUser = await _authService.getCurrentUser();
      _status = AuthStatus.authenticated;
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> login(String email, String password) async {
    try {
      _error = null;
      
      final request = AuthRequest(
        email: email,
        password: password,
      );
      
      await _authService.login(request);
      _currentUser = await _authService.getCurrentUser();
      _status = AuthStatus.authenticated;
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
  
  Future<void> refreshUser() async {
    try {
      _currentUser = await _authService.getCurrentUser();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
