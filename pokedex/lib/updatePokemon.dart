import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/drift.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/palette.dart';
import 'package:pokedex/rarityPokemons.dart';
import 'package:pokedex/typePokemons.dart';
import 'package:pokedex/validate.dart';

class EditPokemonScreen extends StatefulWidget {
  final Pokemon pokemon;

  const EditPokemonScreen({Key? key, required this.pokemon}) : super(key: key);

  @override
  EditPokemonScreenState createState() => EditPokemonScreenState();
}

class EditPokemonScreenState extends State<EditPokemonScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameControllerAlter = TextEditingController();
  final TextEditingController numberControllerAlter = TextEditingController();
  final TextEditingController avatarControllerAlter = TextEditingController();
  final TextEditingController typeControllerAlter = TextEditingController();
  final TextEditingController rarityControllerAlter = TextEditingController();

  @override
  void initState() {
    super.initState();
    idController.text = widget.pokemon.id.toString();
    nameControllerAlter.text = widget.pokemon.name;
    numberControllerAlter.text = widget.pokemon.number;
    avatarControllerAlter.text = widget.pokemon.avatar;
    typeControllerAlter.text = widget.pokemon.type;
    rarityControllerAlter.text = widget.pokemon.rarity;
  }

  String? initialCourseValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Pokemon'),
      ),
      body: Center(
        child: ListView(
          children: [
            Container(
              width: 450,
              decoration: const BoxDecoration(
                color: Color(0xFF6c2d6a),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: CircleAvatar(
                radius: 100,
                backgroundColor: ColorPalette.iconColor,
                child: CircleAvatar(
                  radius: 95,
                  backgroundImage: NetworkImage(avatarControllerAlter.text),
                ),
              ),
            ),
            Container(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: const TextStyle(color: ColorPalette.textColor),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                        borderSide: const BorderSide(
                            color: ColorPalette.borderColorInput, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                        borderSide: const BorderSide(
                            color: ColorPalette.borderColorInputActivate,
                            width: 2))),
                controller: nameControllerAlter,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Number',
                    labelStyle: const TextStyle(color: ColorPalette.textColor),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                        borderSide: const BorderSide(
                            color: ColorPalette.borderColorInput, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                        borderSide: const BorderSide(
                            color: ColorPalette.borderColorInputActivate,
                            width: 2))),
                inputFormatters: [LengthLimitingTextInputFormatter(2)],
                controller: numberControllerAlter,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: DropdownButtonFormField<String>(
                value: typeControllerAlter.text,
                decoration: InputDecoration(
                    labelText: 'Type',
                    labelStyle: const TextStyle(color: ColorPalette.textColor),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                        borderSide: const BorderSide(
                            color: ColorPalette.borderColorInput, width: 2))),
                items: typePokemons.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (selectedType) {
                  typeControllerAlter.text = selectedType!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: DropdownButtonFormField<String>(
                value: rarityControllerAlter.text,
                decoration: InputDecoration(
                    labelText: 'Rarity',
                    labelStyle: const TextStyle(color: ColorPalette.textColor),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                        borderSide: const BorderSide(
                            color: ColorPalette.borderColorInput, width: 2))),
                items: rarityPokemons.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (selectedRarity) {
                  rarityControllerAlter.text = selectedRarity!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                  decoration: InputDecoration(
                      labelText: 'Avatar',
                      labelStyle:
                          const TextStyle(color: ColorPalette.textColor),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                          borderSide: const BorderSide(
                              color: ColorPalette.borderColorInput, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                          borderSide: const BorderSide(
                              color: ColorPalette.borderColorInputActivate,
                              width: 2))),
                  controller: avatarControllerAlter,
                  onChanged: (avatarControllerAlter) {
                    setState(() {
                      avatarControllerAlter;
                    });
                  }),
            ),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    int id = int.parse(idController.text);
                    String alteredName = nameControllerAlter.text;
                    String alteredNumber = numberControllerAlter.text;
                    String alteredType = typeControllerAlter.text;
                    String alteredRarity = rarityControllerAlter.text;
                    String alteredAvatar = avatarControllerAlter.text;

                    if (isValidName(alteredName) ||
                        isValidNumber(alteredNumber) ||
                        isValidAvatar(alteredAvatar)) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Warning'),
                              content: const Text('Invalid update pokemon'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("Exit"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    } else {
                      database.updatePokemons(
                        PokemonsCompanion(
                          id: Value(id),
                          name: Value(alteredName),
                          number: Value(alteredNumber),
                          avatar: Value(alteredAvatar),
                          rarity: Value(alteredRarity),
                          type: Value(alteredType),
                        ),
                      );
                      Navigator.pop(
                          context,
                          Pokemon(
                              id: id,
                              name: alteredName,
                              number: alteredNumber,
                              avatar: alteredAvatar,
                              rarity: alteredRarity,
                              type: alteredType));
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF522151)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text('Save'),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      List<TextEditingController> controllersToClear = [
                        nameControllerAlter,
                        numberControllerAlter,
                        avatarControllerAlter,
                      ];

                      for (var controller in controllersToClear) {
                        controller.clear();
                      }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xFF8D2E8B),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text('Clear'),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
