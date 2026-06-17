import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/home_screen.dart';
import 'services/api_service.dart';
import 'services/local_database.dart';
import 'state/cs2_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final database = await LocalDatabase.open();
  final store = Cs2Store(apiService: Cs2ApiService(), database: database);
  await store.load();

  runApp(Cs2SkinsApp(store: store));
}

class Cs2SkinsApp extends StatelessWidget {
  const Cs2SkinsApp({super.key, required this.store});

  final Cs2Store store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CS2 Skins App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16A085),
          brightness: Brightness.dark,
          surface: const Color(0xFF171A1F),
        ),
        scaffoldBackgroundColor: const Color(0xFF101216),
        cardTheme: const CardThemeData(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: Color(0xFF101216),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: HomeScreen(store: store),
    );
  }
}
