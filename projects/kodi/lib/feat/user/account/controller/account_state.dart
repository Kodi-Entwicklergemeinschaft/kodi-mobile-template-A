import 'package:kodi/feat/listings/data/model/category_model.dart';
import 'package:shared_dependencies/equatable.dart';
import '../data/model/favorite_item_model.dart';
import '../data/model/service_item_model.dart';

class AccountState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<CategoryModel> favorites;
  final List<ServiceItem> services;

  const AccountState({
    this.isLoading = false,
    this.errorMessage,
    this.favorites = const [],
    this.services = const [],
  });

  AccountState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<CategoryModel>? favorites,
    List<ServiceItem>? services,
  }) {
    return AccountState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      favorites: favorites ?? this.favorites,
      services: services ?? this.services,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, favorites, services];
}
