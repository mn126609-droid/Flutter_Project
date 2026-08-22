import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'providers/medicine_provider.dart';
import 'screens/main_shell.dart';
import 'services/database_service.dart';
import 'utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = MedicineDatabase();
  await database.init();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.database});
  final MedicineDatabase database;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MedicineCubit(database)..loadMedicines(),
      child: MaterialApp(
        title: 'Medicine Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: backgroundColor,
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
        ),
        home: const MainShell(),
      ),
    );
  }
}
