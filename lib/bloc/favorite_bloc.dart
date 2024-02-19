import 'package:database_practice/bloc/favorite_state.dart';
import 'package:database_practice/database_helper.dart';


class ProductBloc extends Cubit<ProductState> {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  ProductBloc() : super(ProductState(isFavorite: false, title: '', description: ''));

  Future<void> loadFavorites() async {
    await databaseHelper.open();
    List<Map<String, dynamic>> favorites = await databaseHelper.getFavoritesWithDetails();

    String productId = widget.myProduct['id']!;

    Map<String, dynamic>? favoriteProduct = favorites.firstWhere(
      (favorite) => favorite['product_id'] == productId,
      orElse: () => null,
    );

    emit(ProductState(
      isFavorite: favoriteProduct != null,
      title: favoriteProduct?['title'] ?? widget.myProduct["title"]!,
      description: favoriteProduct?['description'] ?? widget.myProduct["description"]!,
    ));
  }

  Future<void> toggleFavorite() async {
    ProductState currentState = state;
    bool isFav = !currentState.isFavorite;

    await databaseHelper.open();

    if (isFav) {
      await databaseHelper.deleteFavoriteByProductId(widget.myProduct['id']!);
    } else {
      await databaseHelper.insertFavorite(widget.myProduct['id']!);
    }

    loadFavorites();
  }
}
