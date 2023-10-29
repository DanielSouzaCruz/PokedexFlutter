import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/drift.dart';
import 'package:pokedex/palette.dart';
import 'package:pokedex/rarityPokemons.dart';
import 'package:pokedex/typePokemons.dart';
import 'package:pokedex/updatePokemon.dart';
import 'package:pokedex/validate.dart';

void main() {
  runApp(const MyApp());
}

final List<Pokemon> _pokemons = [];
final database = AppDatabase();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemons List App',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pokedex'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PokemonsListScreen(),
              ));
            },
            child: const Text('Quem é esse Pokemon?'),
          ),
        ));
  }
}

class PokemonsListScreen extends StatefulWidget {
  const PokemonsListScreen({super.key});

  @override
  PokemonsListScreenState createState() => PokemonsListScreenState();
}

class PokemonsListScreenState extends State<PokemonsListScreen> {
  @override
  void initState() {
    super.initState();
    _loadPokemons();
  }

  Future<void> _loadPokemons() async {
    await database.viewPokemons().then((pokemons) {
      setState(
        () {
          _pokemons.clear();
          _pokemons.addAll(pokemons);
        },
      );
    });
  }

  Future<void> _removePokemon(Pokemon pokemon) async {
    await database
        .deletePokemons(
          PokemonsCompanion(
              id: Value(pokemon.id),
              name: Value(pokemon.name),
              type: Value(pokemon.type),
              rarity: Value(pokemon.rarity),
              number: Value(pokemon.number),
              avatar: Value(pokemon.avatar)),
        )
        .then((_) => _loadPokemons());
  }

  Future<void> _addPokemons(String name, String type, String number,
      String rarity, String avatar) async {
    final newPokemon = PokemonsCompanion.insert(
        name: name, type: type, number: number, rarity: rarity, avatar: avatar);

    await database.insertPokemons(newPokemon).then((_) {
      _loadPokemons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokemons List')),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: _pokemons.length,
            itemBuilder: (context, i) {
              final avatar = CircleAvatar(
                backgroundColor: ColorPalette.iconColor,
                radius: 20,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(_pokemons[i].avatar),
                  radius: 19,
                ),
              );
              return Container(
                margin: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: ColorPalette.cardColor,
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color: const Color(0xFF000000),
                    width: 1,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: ColorPalette.borderColorInput,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  textColor: const Color(0xFFFFFFFF),
                  leading: avatar,
                  title: Text(
                      'Name: ${_pokemons[i].name} | Type: ${_pokemons[i].type}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Number: ${_pokemons[i].number} | Rarity: ${_pokemons[i].rarity}',
                      ),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditPokemonScreen(pokemon: _pokemons[i]),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                _pokemons[i] = result;
                              });
                            }
                          },
                          color: ColorPalette.iconColor,
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _removePokemon(_pokemons[i]);
                          },
                          color: ColorPalette.iconColor,
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController nameController = TextEditingController();
          TextEditingController typeController = TextEditingController();
          TextEditingController numberController = TextEditingController();
          TextEditingController rarityController = TextEditingController();
          TextEditingController avatarController = TextEditingController();
          showDialog(
            context: context,
            builder: (BuildContext context) => Center(
                child: SizedBox(
                    width: 450,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AlertDialog(
                          title: const Text('Add Pokemon'),
                          content: Column(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: TextField(
                                decoration: InputDecoration(
                                    labelText: 'Name',
                                    labelStyle: const TextStyle(
                                        color: ColorPalette.textColor),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(21),
                                        borderSide: const BorderSide(
                                            color:
                                                ColorPalette.borderColorInput,
                                            width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                      borderSide: const BorderSide(
                                          color: ColorPalette
                                              .borderColorInputActivate,
                                          width: 2),
                                    )),
                                controller: nameController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: TextField(
                                decoration: InputDecoration(
                                    labelText: 'Number',
                                    labelStyle: const TextStyle(
                                        color: ColorPalette.textColor),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(21),
                                        borderSide: const BorderSide(
                                            color:
                                                ColorPalette.borderColorInput,
                                            width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(21),
                                        borderSide: const BorderSide(
                                            color: ColorPalette
                                                .borderColorInputActivate,
                                            width: 2))),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11)
                                ],
                                controller: numberController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                    labelText: 'type',
                                    labelStyle: const TextStyle(
                                        color: ColorPalette.textColor),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(21),
                                        borderSide: const BorderSide(
                                            color:
                                                ColorPalette.borderColorInput,
                                            width: 2))),
                                items: typePokemons
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (selectedType) {
                                  typeController.text = selectedType!;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                    labelText: 'rarity',
                                    labelStyle: const TextStyle(
                                        color: ColorPalette.textColor),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(21),
                                        borderSide: const BorderSide(
                                            color:
                                                ColorPalette.borderColorInput,
                                            width: 2))),
                                items: rarityPokemons
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (selectedRarity) {
                                  rarityController.text = selectedRarity!;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: TextField(
                                decoration: InputDecoration(
                                    labelText: 'Avatar',
                                    labelStyle: const TextStyle(
                                        color: ColorPalette.textColor),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(21),
                                        borderSide: const BorderSide(
                                            color:
                                                ColorPalette.borderColorInput,
                                            width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(21),
                                        borderSide: const BorderSide(
                                            color: ColorPalette
                                                .borderColorInputActivate,
                                            width: 2))),
                                controller: avatarController,
                              ),
                            ),
                          ]),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                String name = nameController.text;
                                String number = numberController.text;
                                String type = typeController.text;
                                String rarity = rarityController.text;
                                String avatar = avatarController.text;
                                if (isValidName(name) ||
                                    isValidNumber(number) ||
                                    isValidAvatar(avatar)) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Warning"),
                                        content: const Text("Invalid pokemon"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text("Exit"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  _addPokemons(
                                      name, type, number, rarity, avatar);
                                  Navigator.of(context).pop();
                                  nameController.clear();
                                  typeController.clear();
                                  rarityController.clear();
                                  numberController.clear();
                                  avatarController.clear();
                                }
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        )
                      ],
                    ))),
          );
        },
        backgroundColor: Color.fromARGB(255, 252, 7, 7),
        child: const Icon(Icons.add),
      ),
    );
  }
}
