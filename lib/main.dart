import 'package:flutter/material.dart';
import 'package:myapp/Page/IngredientPage.dart';
import 'package:myapp/Page/PlanificateurPage.dart';
import 'package:myapp/Page/RecettePage.dart';
import 'package:myapp/Provider/IngredientProvider.dart';
import 'package:myapp/Provider/PlanProvider.dart';
import 'package:myapp/Provider/RecetteProvider.dart';
import 'package:myapp/database/database_helper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IngredientProvider()),
        ChangeNotifierProvider(create: (_) => RecetteProvider()),
        ChangeNotifierProvider(create: (_) => PlanProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planificateur de Repas',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.orange[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.orange,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color.fromARGB(255, 80, 52, 16),
          unselectedItemColor: Color.fromARGB(255, 255, 255, 255),
          backgroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.brown),
        ),
      ),
      home: const MyHomePage(title: 'Planificateur de Repas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  int _previousIndex = 0;

  final List<Widget> _pages = [
    const IngredientPage(),
    const RecettePage(),
    const PlanificateurPage(),
  ];

  final List<Color> _backgroundColors = [
    Colors.blue,
    Colors.green,
    Colors.orange, // Couleur pour la page Planificateur
  ];

  void _onItemTapped(int index) {
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final isForward = _currentIndex > _previousIndex;
          final offsetAnimation = Tween<Offset>(
            begin: isForward
                ? const Offset(1.0, 0.0)
                : const Offset(
                    -1.0, 0.0), // Slide from right if forward, left if backward
            end: Offset.zero,
          ).animate(animation);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        child: _pages[_currentIndex],
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        color: _backgroundColors[_currentIndex], // Change color based on index
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.kitchen),
              label: 'Ingrédients',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Recettes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Planificateur',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors
              .transparent, // Make the background of BottomNavigationBar transparent
          elevation: 0, // Remove shadow
        ),
      ),
    );
  }
}
