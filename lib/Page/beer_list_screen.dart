import 'package:api_beer_bar/Models/Beer.dart';
import 'package:api_beer_bar/Page/BeerSearch.dart';
import 'package:api_beer_bar/services/service_locator.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';
String searchQuery = '';

class BeerListScreen extends StatefulWidget {
  @override
  _BeerListScreenState createState() => _BeerListScreenState();
}

class _BeerListScreenState extends State<BeerListScreen> {
  late Future<List<Beer>> futureBeers;
  String selectedStrength = 'Все';

  @override
  void initState() {
    super.initState();
    futureBeers = fetchBeers(strength: selectedStrength);
  }

  void _showAddBeerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _nameController = TextEditingController();
        final _volumeController = TextEditingController();
        final _pictureController = TextEditingController();
        final _degreesController = TextEditingController();
        final _descriptionController = TextEditingController();

        return AlertDialog(
          title: Text("Добавить пиво"),
          content: SingleChildScrollView( // Добавлен SingleChildScrollView
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(controller: _nameController, decoration: InputDecoration(hintText: "Название")),
                TextField(controller: _volumeController, decoration: InputDecoration(hintText: "Объём")),
                TextField(controller: _pictureController, decoration: InputDecoration(hintText: "Фото")),
                TextField(controller: _degreesController, decoration: InputDecoration(hintText: "Крепкость")),
                TextField(controller: _descriptionController, decoration: InputDecoration(hintText: "Описание")),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Назад"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Добавить"),
              onPressed: () async {
                final name = _nameController.text;
                final volume = double.tryParse(_volumeController.text) ?? 0; // Преобразование строки в double, с фолбэком на 0
                final picture = _pictureController.text;
                final degrees = double.tryParse(_degreesController.text) ?? 0; // Аналогично для крепости
                final description = _descriptionController.text;

                final success = await getIt<ApiService>().addBeer(name, volume, picture, degrees, description);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Пиво успешно добавлено!')));
                  Navigator.of(context).pop(); // Закрыть диалоговое окно после успешного добавления
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка добавления пива.')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditBeerDialog(BuildContext context, Beer beer) {
    final _nameController = TextEditingController(text: beer.name);
    final _volumeController = TextEditingController(text: beer.volume.toString());
    final _pictureController = TextEditingController(text: beer.picture.toString());
    final _degreesController = TextEditingController(text: beer.degrees.toString());
    final _descriptionController = TextEditingController(text: beer.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Редактировать пиво"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(controller: _nameController, decoration: InputDecoration(labelText: "Название")),
                TextField(controller: _volumeController, decoration: InputDecoration(labelText: "Объём")),
                TextField(controller: _pictureController, decoration: InputDecoration(labelText: "Фото")),
                TextField(controller: _degreesController, decoration: InputDecoration(labelText: "Крепкость")),
                TextField(controller: _descriptionController, decoration: InputDecoration(labelText: "Описание")),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Назад"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Сохранить"),
              onPressed: () async {
                final Beer updatedBeer = Beer(
                  beerId: beer.beerId, // Предполагается, что у вас уже есть beerId для обновления
                  name: _nameController.text,
                  volume: double.tryParse(_volumeController.text) ?? 0.0,
                  picture: _pictureController.text,
                  degrees: double.tryParse(_degreesController.text) ?? 0.0,
                  description: _descriptionController.text,
                );

                final success = await getIt<ApiService>().updateBeer(updatedBeer);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Пиво успешно обновлено!')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка обновления пива.')));
                }
                Navigator.of(context).pop(); // Закрыть диалоговое окно после попытки сохранения
              },
            ),

          ],
        );
      },
    );
  }


  void _showDeleteConfirmationDialog(BuildContext context, int beerId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this beer?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () async {
                await getIt<ApiService>().deleteBeer(beerId);
                _refreshBeers(); // Обновите список после удаления
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<List<Beer>> fetchBeers({required String strength}) async {
    return getIt<ApiService>().fetchBeers();
  }

  Future<void> _refreshBeers() async {
    setState(() {
      futureBeers = getIt<ApiService>().fetchBeers(strength: selectedStrength);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Певко'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: BeerSearch());
            },
          ),
          DropdownButton<String>(
            value: selectedStrength,
            onChanged: (String? newValue) {
              setState(() {
                selectedStrength = newValue!;
                futureBeers = getIt<ApiService>().fetchBeers(strength: selectedStrength);
              });
            },
            items: <String>['Все', 'Легкое (до 4.0%)', 'Среднее (4.0% - 6.0%)', 'Крепкое (6.0% и выше)']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )


        ],
      ),
      body: FutureBuilder<List<Beer>>(
        future: futureBeers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: _refreshBeers,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Beer beer = snapshot.data![index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: <Widget>[

                        if (beer.picture!.isNotEmpty) // Проверяем, не пустой ли URL изображения
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            child: Image.network(
                              beer.picture!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              height: 300,
                            ),
                          ),
                        ListTile(
                          title: Text(beer.name),
                          subtitle: Text('Объём: ${beer.volume}Л, Крепкость: ${beer.degrees}\n Описание: ${beer.description}'),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditBeerDialog(context, beer);
                           },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, beer.beerId);
                          },
                        ),

                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(child: Text('Нет пива('));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBeerDialog(context);        },
        child: Icon(Icons.add),
      ),

    );
  }

}
