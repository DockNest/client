import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docknest/models/add_docknest_screen.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

const dbFilename = 'docknests.db';
const docknestTbl = 'docknest';
const createTableDdl =
    'CREATE TABLE $docknestTbl(id TEXT PRIMARY KEY, name TEXT, ip TEXT, port TEXT)';

class DocknestsNotifier extends StateNotifier<Set<Docknest>> {
  DocknestsNotifier() : super(<Docknest>{});

  Future<sql.Database> getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, dbFilename),
        onCreate: (db, version) => db.execute(createTableDdl), version: 1);
  }

  void addShipyard(String name, String ip, String port) async {
    final db = await getDatabase();

    final docknest = Docknest(name: name, ip: ip, port: port);

    db.insert(docknestTbl, {
      ShipyardField.id.str: docknest.id,
      ShipyardField.name.str: docknest.name,
      ShipyardField.ip.str: docknest.ip,
      ShipyardField.port.str: docknest.port
    });

    state = {...state, docknest};
  }

  void updateShipyard(Docknest docknest) async {
    final db = await getDatabase();

    final stateCopy = {...state};

    stateCopy.remove(docknest);
    stateCopy.add(docknest);

    state = stateCopy;


    db.update(docknestTbl, {
      ShipyardField.name.str: docknest.name,
      ShipyardField.ip.str: docknest.ip,
      ShipyardField.port.str: docknest.port
    }, where: '${ShipyardField.id.str} = ?',
      whereArgs: [docknest.id],
    );
  }

  void removeShipyard(Docknest docknest) async {
    final db = await getDatabase();

    db.delete(
      docknestTbl,
      where: '${ShipyardField.id.str} = ?',
      whereArgs: [docknest.id],
    );

    final stateCopy = {...state};

    stateCopy.remove(docknest);

    state = stateCopy;
  }

  Future<void> loadAllShipyards() async {
    final db = await getDatabase();
    final rows = await db.query(docknestTbl);
    final docknests = rows
        .map(
          (row) =>
          Docknest(
            ip: row[ShipyardField.ip.str] as String,
            name: row[ShipyardField.name.str] as String,
            port: row[ShipyardField.port.str] as String,
            id: row[ShipyardField.id.str] as String,
          ),
    )
        .toSet();

    state = docknests;
  }
}

final docknestsProvider =
StateNotifierProvider<DocknestsNotifier, Set<Docknest>>(
        (ref) => DocknestsNotifier());
