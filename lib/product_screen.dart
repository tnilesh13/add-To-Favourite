import 'package:database_practice/database_helper.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  List<Map<String, String>> myList = [
    {"id": "1", "title": "Shirt", "description": "Adidas"},
    {"id": "2", "title": "T-Shirt", "description": "Puma"},
    {"id": "3", "title": "Glasses", "description": "Gucci"},
    {"id": "4", "title": "Shoes", "description": "Nike"},
    {"id": "5", "title": "Coat", "description": "LV"}
  ];

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body:
       SizedBox(
        height: 200,
        child: ListView.builder(
          itemCount: myList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return ProductView(myList[index]);
          },
        ),
      ),
    );
  }
}

class ProductView extends StatefulWidget {
  Map<String, String> myProduct;
  ProductView(this.myProduct, {super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  // bool isFav = false;
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    // checkFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80,
      width: 140,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(8),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.red,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            alignment: Alignment.topRight,
            width: 140,
            height: 120,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/img1.jpg"), fit: BoxFit.cover),
            ),
            child: InkWell(
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: FutureBuilder<bool>(
                  future: isFavorite(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Icon(Icons.favorite_border, color: Colors.red);
                    } else {
                      bool isFav = snapshot.data ?? false;
                      print("snapshot${snapshot.data}");
                      print("isfav$isFav");
                      return Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      );
                    }
                  },
                ),
              ),
              onTap: () {
                toggleFavorite();
              },
            ),
          ),
          // Image.asset("assets/img1.jpg"),
          Text(
            widget.myProduct["title"]!,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            widget.myProduct["description"]!,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Future<bool> isFavorite() async {
    await databaseHelper.open();
    List<Map<String, dynamic>> favorites = await databaseHelper.getFavorites();

    String productId = widget.myProduct['id']!; // as int;

    // Check if the current product is in the favorites list
    return favorites.any((favorite) => favorite['product_id'] == productId);
  }

  void toggleFavorite() async {
    bool isFav = await isFavorite();


    await databaseHelper.open();

    if (isFav) {
      // Remove the product from favorites
      await databaseHelper.deleteFavoriteByProductId(widget.myProduct['id']!);
    } else {
      // Add the product to favorites
      await databaseHelper.insertFavorite(widget.myProduct['id']!);
    }
    setState(() {
      isFav = !isFav;
    });
  }
}
