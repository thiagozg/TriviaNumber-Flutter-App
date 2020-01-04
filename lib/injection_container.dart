import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_number/core/network/network_info.dart';
import 'package:trivia_number/core/util/input_converter.dart';
import 'package:trivia_number/features/main/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_number/features/main/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_number/features/main/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia_number/features/main/domain/repositories/number_trivia_repository.dart';
import 'package:trivia_number/features/main/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_number/features/main/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia_number/features/main/presentation/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

// returning Future<void> cuz is async
Future<void> init() async {
  await _initExternalLibraries();
  _initCore();
  _initFeatures();
}

void _initFeatures() {
  /// Main - Number Trivia
  /// Bloc
  serviceLocator.registerFactory(() => NumberTriviaBloc(
      concrete: serviceLocator(),
      random: serviceLocator(),
      inputConverter: serviceLocator()
  ));

  /// Use Cases
  serviceLocator.registerLazySingleton(() => GetConcreteNumberTriviaUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetRandomNumberTriviaUseCase(serviceLocator()));

  /// Repository
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(() => NumberTriviaRepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator()
  ));

  /// Data Sources
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(() => NumberTriviaRemoteDataSourceImpl(
//      client: IOClient()
      client: serviceLocator()
  ));
  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(() => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: serviceLocator()
  ));
}

void _initCore() {
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(serviceLocator()));
}

Future<void> _initExternalLibraries() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}