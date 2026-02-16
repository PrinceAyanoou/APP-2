import 'package:flutter/material.dart';
import 'models/profile.dart';
import 'models/request_model.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/home_page.dart';
import 'services/api.dart';

// Simple app state exposed with InheritedNotifier (no external packages)
class AppState extends ChangeNotifier {
  Profile profile = Profile();
  List<InternshipRequest> requests = [];
  String? userEmail;
  bool isLoading = false;

  Future<void> loadRequestsFromApi() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await ApiService.getRequests();
      if (result['success']) {
        requests = (result['data'] as List).map((r) {
          return InternshipRequest(
            id: r['id'],
            title: r['title'],
            type: r['type'] == 'academic'
                ? RequestType.academic
                : RequestType.professional,
            status: r['status'],
          );
        }).toList();
      }
    } catch (e) {
      print('Error loading requests: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadProfileFromApi() async {
    try {
      final result = await ApiService.getProfile();
      if (result['success']) {
        final data = result['data'];
        profile = Profile()
          ..firstName = data['firstName'] ?? ''
          ..lastName = data['lastName'] ?? ''
          ..email = data['email'] ?? ''
          ..phone = data['phone'] ?? ''
          ..university = data['university'] ?? ''
          ..degree = data['degree'] ?? ''
          ..gradYear = data['gradYear'] ?? ''
          ..company = data['company'] ?? ''
          ..position = data['position'] ?? '';
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
    notifyListeners();
  }

  void updateProfile(Profile p) {
    profile = p;
    notifyListeners();
  }

  void addRequest(InternshipRequest r) {
    requests.insert(0, r);
    notifyListeners();
  }

  void clearAuth() {
    ApiService.clearToken();
    userEmail = null;
    profile = Profile();
    requests = [];
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({required AppState notifier, required Widget child})
      : super(notifier: notifier, child: child);
  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppStateScope>()!.notifier!;
}

void main() {
  runApp(AppStateScope(notifier: AppState(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.indigo);

    return MaterialApp(
      title: 'APP-2',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF6F8FB),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const LoginPage(),
        '/signup': (ctx) => const SignupPage(),
        '/home': (ctx) => const HomePage(),
      },
    );
  }
}
// Where to add API integration:
// - API calls in ApiService (lib/services/api.dart) - already integrated
// - Login/Signup pass tokens to AppState and ApiService
// - Profile/Requests pages call API on init and after mutations
