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

  void adddocknest(String name, String ip, String port) async {
    final db = await getDatabase();

    final docknest = Docknest(name: name, ip: ip, port: port);

    db.insert(docknestTbl, {
      DocknestField.id.str: docknest.id,
      DocknestField.name.str: docknest.name,
      DocknestField.ip.str: docknest.ip,
      DocknestField.port.str: docknest.port
    });

    state = {...state, docknest};
  }

  void updatedocknest(Docknest docknest) async {
    final db = await getDatabase();

    final stateCopy = {...state};

    stateCopy.remove(docknest);
    stateCopy.add(docknest);

    state = stateCopy;


    db.update(docknestTbl, {
      DocknestField.name.str: docknest.name,
      DocknestField.ip.str: docknest.ip,
      DocknestField.port.str: docknest.port
    }, where: '${DocknestField.id.str} = ?',
      whereArgs: [docknest.id],
    );
  }

  void removedocknest(Docknest docknest) async {
    final db = await getDatabase();

    db.delete(
      docknestTbl,
      where: '${DocknestField.id.str} = ?',
      whereArgs: [docknest.id],
    );

    final stateCopy = {...state};

    stateCopy.remove(docknest);

    state = stateCopy;
  }

  Future<void> loadAlldocknests() async {
    final db = await getDatabase();
    final rows = await db.query(docknestTbl);
    final docknests = rows
        .map(
          (row) =>
          Docknest(
            ip: row[DocknestField.ip.str] as String,
            name: row[DocknestField.name.str] as String,
            port: row[DocknestField.port.str] as String,
            id: row[DocknestField.id.str] as String,
          ),
    )
        .toSet();

    state = docknests;
  }
}

final docknestsProvider =
StateNotifierProvider<DocknestsNotifier, Set<Docknest>>(
        (ref) => DocknestsNotifier());
