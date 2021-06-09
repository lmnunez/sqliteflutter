import 'package:flutter/material.dart';
import 'package:sqliteflutter/PersonaModel.dart';
import 'package:sqliteflutter/Database.dart';
import 'dart:math' as math;

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<Persona> testPersonas = [
    Persona(nombre: "pedro1", correo: "p1@gmail.com", telefono: "70000000"),
    Persona(nombre: "pedro2", correo: "p2@gmail.com", telefono: "70000000"),
    Persona(nombre: "pedro3", correo: "p3@gmail.com", telefono: "70000000"),
    Persona(nombre: "pedro4", correo: "p4@gmail.com", telefono: "70000000"),
    Persona(nombre: "pedro5", correo: "p5@gmail.com", telefono: "70000000"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter SQLite")),
      body: FutureBuilder<List<Persona>>(
        future: DBProvider.db.getAllPersonas(),
        builder: (BuildContext context, AsyncSnapshot<List<Persona>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Persona item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    DBProvider.db.deletePersona(item.id);
                  },
                  child: ListTile(
                    title: Text(item.nombre+" -- "+item.correo+" -- "+item.telefono),

                    leading: Text(item.id.toString()),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Persona rnd = testPersonas[math.Random().nextInt(testPersonas.length)];
          bool ep = await DBProvider.db.existsPersona(rnd);
          if(!ep) {
            await DBProvider.db.newPersona(rnd);
            setState(() {});
            print("Persona agregada.......................");
          } else {
            print("Persona No agregada existe el correo"+ rnd.correo+".......................");
            _showDialog(context);
          }
        },
      ),
    );
  }


  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Alert!!"),
          content: new Text("Persona no agregada existe correo !"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
