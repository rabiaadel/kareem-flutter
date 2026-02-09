import 'package:get_it/get_it.dart';

import '../../data/datasources/firebase_data_source.dart';
import '../../data/datasources/local_data_source.dart';
import '../../data/datasources/mock_data_source.dart';
import '../../data/repositories/ai_repository.dart';
import '../../data/repositories/analysis_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/repositories/community_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/notification_provider.dart';
import '../../shared/providers/user_provider.dart';
import '../services/firebase_auth_service.dart';
import '../services/firebase_firestore_service.dart';
import '../services/firebase_storage_service.dart';
import '../services/local_storage_service.dart';
import '../services/mock_api_service.dart';
import '../services/notification_service.dart';
import '../services/shared_preferences_service.dart';

final getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    // Services
    getIt.registerLazySingleton<SharedPreferencesService>(
          () => SharedPreferencesService(),
    );

    getIt.registerLazySingleton<LocalStorageService>(
          () => LocalStorageService(getIt<SharedPreferencesService>()),
    );

    getIt.registerLazySingleton<FirebaseAuthService>(
          () => FirebaseAuthService(),
    );

    getIt.registerLazySingleton<FirebaseFirestoreService>(
          () => FirebaseFirestoreService(),
    );

    getIt.registerLazySingleton<FirebaseStorageService>(
          () => FirebaseStorageService(),
    );

    getIt.registerLazySingleton<NotificationService>(
          () => NotificationService(),
    );

    getIt.registerLazySingleton<MockApiService>(
          () => MockApiService(),
    );

    // Data Sources
    getIt.registerLazySingleton<FirebaseDataSource>(
          () => FirebaseDataSource(
        getIt<FirebaseAuthService>(),
        getIt<FirebaseFirestoreService>(),
        getIt<FirebaseStorageService>(),
      ),
    );

    getIt.registerLazySingleton<LocalDataSource>(
          () => LocalDataSource(getIt<LocalStorageService>()),
    );

    getIt.registerLazySingleton<MockDataSource>(
          () => MockDataSource(getIt<MockApiService>()),
    );

    // Repositories
    getIt.registerLazySingleton<AuthRepository>(
          () => AuthRepository(
        getIt<FirebaseDataSource>(),
        getIt<LocalDataSource>(),
      ),
    );

    getIt.registerLazySingleton<ProfileRepository>(
          () => ProfileRepository(
        getIt<FirebaseDataSource>(),
        getIt<LocalDataSource>(),
      ),
    );

    getIt.registerLazySingleton<CommunityRepository>(
          () => CommunityRepository(
        getIt<FirebaseDataSource>(),
        getIt<LocalDataSource>(),
      ),
    );

    getIt.registerLazySingleton<ChatRepository>(
          () => ChatRepository(
        getIt<FirebaseDataSource>(),
        getIt<LocalDataSource>(),
      ),
    );

    getIt.registerLazySingleton<AnalysisRepository>(
          () => AnalysisRepository(
        getIt<FirebaseDataSource>(),
        getIt<LocalDataSource>(),
      ),
    );

    getIt.registerLazySingleton<AIRepository>(
          () => AIRepository(
        getIt<MockDataSource>(),
      ),
    );

    // Providers
    getIt.registerLazySingleton<AuthProvider>(
          () => AuthProvider(getIt<AuthRepository>()),
    );

    getIt.registerLazySingleton<UserProvider>(
          () => UserProvider(getIt<ProfileRepository>()),
    );

    getIt.registerLazySingleton<NotificationProvider>(
          () => NotificationProvider(getIt<NotificationService>()),
    );
  }
}