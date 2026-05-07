import 'package:shared_dependencies/equatable.dart';

class FavoriteItem extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final String color;

  const FavoriteItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.color,
  });

  @override
  List<Object?> get props => [id, title, imageUrl, color];
}
