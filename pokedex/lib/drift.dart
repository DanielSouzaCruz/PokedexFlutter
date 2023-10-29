import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

part 'drift.g.dart';

@UseRowClass(Pokemon)
class Pokemons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get number => text()();
  TextColumn get rarity => text()();
  TextColumn get avatar => text()();
}

class Pokemon {
  final int id;
  final String name;
  final String type;
  final String number;
  final String rarity;
  final String avatar;

  Pokemon({
    required this.id,
    required this.name,
    required this.type,
    required this.number,
    required this.rarity,
    required this.avatar,
  });
}

@DriftDatabase(tables: [Pokemons])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Pokemon>> viewPokemons() => select(pokemons).get();
  Future<int> insertPokemons(PokemonsCompanion pokemon) =>
      into(pokemons).insert(pokemon);
  Future updatePokemons(PokemonsCompanion pokemon) =>
      update(pokemons).replace(pokemon);
  Future deletePokemons(PokemonsCompanion pokemon) =>
      delete(pokemons).delete(pokemon);
}

DatabaseConnection _openConnection() {
  return DatabaseConnection.delayed(Future(() async {
    final db = await WasmDatabase.open(
      databaseName: 'students_list',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
    );

    if (db.missingFeatures.isNotEmpty) {
      print('error - missing features');
    }

    return db.resolvedExecutor;
  }));
}
