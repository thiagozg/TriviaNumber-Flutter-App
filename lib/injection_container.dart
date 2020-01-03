import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
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

final _serviceLocator = GetIt.instance;

// returning Future<void> cuz is async
Future<void> init() async {
  _initFeatures();
  _initCore();
  _initExternalLibraries();
}

void _initFeatures() {
  /// Main - Number Trivia
  /// Bloc
  _serviceLocator.registerFactory(() => NumberTriviaBloc(
      concrete: _serviceLocator(),
      random: _serviceLocator(),
      inputConverter: _serviceLocator()
  ));

  /// Use Cases
  _serviceLocator.registerLazySingleton(() => GetConcreteNumberTriviaUseCase(_serviceLocator()));
  _serviceLocator.registerLazySingleton(() => GetRandomNumberTriviaUseCase(_serviceLocator()));

  /// Repository
  _serviceLocator.registerLazySingleton<NumberTriviaRepository>(() => NumberTriviaRepositoryImpl(
      remoteDataSource: _serviceLocator(),
      localDataSource: _serviceLocator(),
      networkInfo: _serviceLocator()
  ));

  /// Data Sources
  _serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(() => NumberTriviaRemoteDataSourceImpl(
      client: _serviceLocator()
  ));
  _serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(() => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: _serviceLocator()
  ));
}

void _initCore() {
  _serviceLocator.registerLazySingleton(() => InputConverter());
  _serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(_serviceLocator()));
}

Future<void> _initExternalLibraries() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  _serviceLocator.registerLazySingleton(() => sharedPreferences);
  _serviceLocator.registerLazySingleton(() => http.Client);
  _serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}