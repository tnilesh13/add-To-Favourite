import 'package:database_practice/database_helper.dart';
import 'package:flutter/material.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return
     Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
      ),
      body:
       SizedBox(
        height: 200,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: getFavoriteData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Map<String, dynamic>> favoriteList = snapshot.data ?? [];

              print('mylist$favoriteList');

              return ListView.builder(
                shrinkWrap: true,
                itemCount: favoriteList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return favouriteView(favoriteList[index]);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getFavoriteData() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.open();
    return await databaseHelper.getFavorites();
  }

  Widget favouriteView(Map<String, dynamic> favoriteItem) {
    // Extract 'id' directly from the favoriteItem map
    int favoriteId = favoriteItem['id'] as int;
    String proId = favoriteItem['product_id']; // as int;

    void removeFavorite() async {
      DatabaseHelper databaseHelper = DatabaseHelper();
      await databaseHelper.open();
      // Remove the product from favorites
      await databaseHelper.deleteFavoriteByProductId(proId);
    }

    return Container(
      width: 140,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.red,
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            width: 140,
            height: 100,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: InkWell(
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.favorite, color: Colors.red),
              ),
              onTap: () {
                removeFavorite();
                setState(() {
                  
                });
              },
            ),
          ),
          Text(
            "id: $favoriteId",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "productId: $proId",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
