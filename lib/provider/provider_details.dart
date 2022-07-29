import 'dart:io';
import 'dart:async';
import 'package:flutter_fundamental2/data/api/api_service.dart';
import 'package:flutter_fundamental2/data/response/response_details.dart';
import 'package:flutter_fundamental2/utils/state.dart';
import 'package:flutter/material.dart';

class RestaurantDetailsProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantDetailsProvider({required this.apiService});

  ResultState<RestaurantDetailsResponse> _state =
      ResultState(status: Status.loading, message: null, data: null);
  ResultState<RestaurantDetailsResponse> get state => _state;

  Future<ResultState> getDetails(String id) async {
    try {
      _state = ResultState(status: Status.loading, message: null, data: null);
      notifyListeners();
      final RestaurantDetailsResponse restaurantDetailResponse =
          await apiService.getDetails(id);
      _state = ResultState(
          status: Status.hasData,
          message: null,
          data: restaurantDetailResponse);
      notifyListeners();
      return _state;
    } on TimeoutException {
      _state = ResultState(
          status: Status.error, message: 'timeoutExceptionMessage', data: null);
      notifyListeners();
      return _state;
    } on SocketException {
      _state = ResultState(
          status: Status.error, message: 'socketExceptionMessage', data: null);
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
