import 'dart:io';
import 'dart:async';
import 'package:flutter_fundamental2/data/api/api_service.dart';
import 'package:flutter_fundamental2/data/response/response_list.dart';
import 'package:flutter_fundamental2/utils/state.dart';
import 'package:flutter/material.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  RestaurantProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  ResultState<RestaurantListResponse> _state =
      ResultState(status: Status.loading, message: null, data: null);

  ResultState<RestaurantListResponse> get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState(status: Status.loading, message: null, data: null);
      notifyListeners();
      final RestaurantListResponse restaurantListResponse =
          await apiService.getTopHeadLines();
      _state = ResultState(
          status: Status.hasData, message: null, data: restaurantListResponse);
      notifyListeners();
      return _state;
    } on TimeoutException {
      _state = ResultState(
          status: Status.error,
          message: 'Connection timeout, please try again!',
          data: null);
      notifyListeners();
      return _state;
    } on SocketException {
      _state = ResultState(
          status: Status.error,
          message: 'No internet, please check your internet!',
          data: null);
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
