import 'package:database_practice/database_helper.dart';
import 'package:database_practice/favourite_screen.dart';
import 'package:database_practice/product_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductScreen(),
                      ));
                },
                child: Text("Products")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavouriteScreen(),
                      ));
                },
                child: Text("Favourites")),
            ElevatedButton(
                onPressed: () {
                  // DatabaseHelper databaseHelper = DatabaseHelper();
                  // databaseHelper.open();
                  // databaseHelper.deleteAllFavorites();
                  deleteAllFavorites();
                },
                child: Text("delete all Favourites")),
          ],
        ),
      ),
    );
  }
  
  void deleteAllFavorites() async {
                  DatabaseHelper databaseHelper = DatabaseHelper();
  await databaseHelper.open();
  await databaseHelper.deleteAllFavorites();
  // Optionally, update the UI or perform any other actions after deletion
}
}
