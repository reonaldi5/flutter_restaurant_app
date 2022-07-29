import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fundamental2/data/model/minuman.dart';
import 'package:flutter_fundamental2/data/model/makanan.dart';
import 'package:flutter_fundamental2/data/model/restaurant.dart';
import 'package:flutter_fundamental2/data/response/response_details.dart';
import 'package:flutter_fundamental2/provider/provider_details.dart';
import 'package:flutter_fundamental2/utils/state.dart';
import 'package:flutter_fundamental2/widgets/platform_widget.dart';

class RestaurantDetail extends StatefulWidget {
  static const routeName = '/detail_page';
  final String restaurant;
  const RestaurantDetail({Key? key, required this.restaurant})
      : super(key: key);

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  @override
  void initState() {
    Future.microtask(() {
      RestaurantDetailsProvider provider =
          Provider.of<RestaurantDetailsProvider>(
        context,
        listen: false,
      );
      provider.getDetails(widget.restaurant);
    });
    super.initState();
  }

  Widget _buildDetails(BuildContext context) {
    return Scaffold(body: Consumer<RestaurantDetailsProvider>(
      builder: (context, provider, _) {
        ResultState<RestaurantDetailsResponse> state = provider.state;
        switch (state.status) {
          case Status.loading:
            return Scaffold(
              appBar: AppBar(
                title: const Text('Loading'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          case Status.error:
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(
                    16.0,
                  ),
                  child: Text(
                    "Tidak Ada Koneksi Internet",
                  ),
                ),
              ),
            );
          case Status.hasData:
            {
              Restaurant restaurant = state.data!.restaurant;
              return Scaffold(
                body: NestedScrollView(
                  headerSliverBuilder: (context, isScroller) {
                    return [
                      SliverAppBar(
                        pinned: true,
                        expandedHeight: 200,
                        iconTheme: const IconThemeData(
                          color: Colors.white,
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Hero(
                            tag: restaurant.id,
                            child: Image.network(
                              restaurant.mediumPictureUrl,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          title: Text(
                            restaurant.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          centerTitle: true,
                          titlePadding: const EdgeInsets.only(
                            bottom: 16.0,
                          ),
                        ),
                      ),
                    ];
                  },
                  body: ListView(
                    padding: const EdgeInsets.all(
                      8.0,
                    ),
                    children: [
                      Text(restaurant.description),
                      const Divider(
                        height: 12.0,
                        color: Colors.green,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined),
                          Text('${restaurant.address}, '),
                          Text(restaurant.city),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_border),
                          Text(restaurant.rating.toString()),
                        ],
                      ),
                      const Divider(
                        height: 12.0,
                        color: Colors.green,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Foods'),
                            _buildFoodMenu(context, restaurant.menus.foods),
                            const Divider(
                              height: 12.0,
                              color: Colors.green,
                            ),
                            const Text('Drinks'),
                            _buildDrinkMenu(context, restaurant.menus.drinks),
                            const Divider(
                              height: 12.0,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
        }
      },
    ));
  }

  Widget _buildFoodMenu(BuildContext context, List<Makanan> foods) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 65,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Text(foods[index].name)],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget _buildDrinkMenu(BuildContext context, List<Minuman> drinks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 65,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: drinks.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text(drinks[index].name)],
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return _buildDetails(context);
  }

  Widget _buildIos(BuildContext context) {
    return _buildDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }
}
