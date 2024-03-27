import 'package:api_beer_bar/services/api_service.dart';
import 'package:api_beer_bar/services/service_locator.dart';
import 'package:flutter/material.dart';

import '../Models/Beer.dart';

class BeerSearch extends SearchDelegate<dynamic> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Эмуляция асинхронной загрузки данных
    final futureBeers = getIt<ApiService>().fetchBeers();

    return FutureBuilder<List<Beer>>(
      future: futureBeers,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final results = snapshot.data!.where((Beer beer) => beer.name.toLowerCase().contains(query.toLowerCase())).toList();

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final Beer beer = results[index];
            return ListTile(
              title: Text(beer.name),
              subtitle: Text('${beer.volume} L, ${beer.degrees}°'),
              onTap: () {
                close(context, beer); // Возвращает выбранное пиво и закрывает поиск
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Эмуляция асинхронной загрузки данных
    final futureBeers = getIt<ApiService>().fetchBeers();

    return FutureBuilder<List<Beer>>(
      future: futureBeers,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final suggestions = snapshot.data!.where((Beer beer) => beer.name.toLowerCase().contains(query.toLowerCase())).toList();

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final Beer beer = suggestions[index];
            return ListTile(
              title: Text(beer.name),
              subtitle: Text('${beer.volume} L, ${beer.degrees}°'),
              onTap: () {
                query = beer.name; // Обновляет поисковый запрос до полного названия пива
                showResults(context); // Показывает результаты на основе обновленного запроса
              },
            );
          },
        );
      },
    );
  }

}
