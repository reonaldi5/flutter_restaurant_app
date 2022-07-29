import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fundamental2/data/api/api_service.dart';
import 'package:flutter_fundamental2/data/response/list_search.dart';
import 'package:flutter_fundamental2/utils/state.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchProvider({required this.apiService});

  ResultState<RestaurantSearchResponse> _state = ResultState(
    status: Status.hasData,
    message: null,
    data: RestaurantSearchResponse(
      error: false,
      founded: 0,
      restaurant: [],
    ),
  );

  ResultState<RestaurantSearchResponse> get state => _state;

  Future<dynamic> fetchSearchRestaurant(String keyword) async {
    try {
      _state = ResultState(status: Status.loading, message: null, data: null);
      notifyListeners();
      final RestaurantSearchResponse restaurantSearchResponse =
          await apiService.getSearch(keyword);
      _state = ResultState(
          status: Status.hasData,
          message: null,
          data: restaurantSearchResponse);
      notifyListeners();
      return _state;
    } on TimeoutException {
      _state = ResultState(
          status: Status.error, message: 'Request time out', data: null);
      notifyListeners();
      return _state;
    } on SocketException {
      _state = ResultState(status: Status.error, message: '', data: null);
      notifyListeners();
      return _state;
    } on Error catch (e) {
      _state =
          ResultState(status: Status.error, message: e.toString(), data: null);
      notifyListeners();
      return _state;
    }
  }
}
