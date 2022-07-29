import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fundamental2/common/style.dart';
import 'package:flutter_fundamental2/data/model/restaurant.dart';
import 'package:flutter_fundamental2/data/response/response_list.dart';
import 'package:flutter_fundamental2/provider/provider.dart';
import 'package:flutter_fundamental2/ui/search_page.dart';
import 'package:flutter_fundamental2/utils/state.dart';
import 'package:flutter_fundamental2/widgets/card_custom.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/restaurants';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Restaurant',
        ),
        bottom: PreferredSize(
          child: Container(
            padding: const EdgeInsets.only(
              left: 14.0,
              bottom: 12.0,
            ),
            alignment: Alignment.centerLeft,
            child: Center(
              child: Text(
                'Recommended restaurant for you!',
                style: myTextTheme.subtitle2!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          preferredSize: const Size.fromHeight(10.0),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(
                context,
                RestaurantSearch.routeName,
              );
            },
          ),
        ],
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, _) {
          ResultState<RestaurantListResponse> state = provider.state;
          switch (state.status) {
            case Status.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case Status.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(
                    16.0,
                  ),
                  child: Text(
                    state.message!,
                  ),
                ),
              );
            case Status.hasData:
              {
                List<Restaurant> restaurants = state.data!.restaurants;
                if (restaurants.isEmpty) {
                  return const Center(
                    child: Text('Restaurant is empty.'),
                  );
                } else {
                  return CardCustom(
                    restaurant: restaurants,
                  );
                }
              }
          }
        },
      ),
    );
  }
}
