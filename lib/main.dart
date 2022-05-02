import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterunidad3/data/data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Se asegura que todas las dependencias esten inicializadas
  Firebase.initializeApp().then((value) {
    runApp(const MyApp());
  }); // verifica el archivo google-services.json
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mantenimiento Usuarios'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int activoMenu1 = 0;
  List usuarioslista = [];
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _nivel = TextEditingController();
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _tipo = TextEditingController();
  final TextEditingController _usuario = TextEditingController();
  final String avatar = '';
  final String correo = '';
  final int idu = 0;
  final int nivel = 0;
  final String nombre = '';
  final String password = '';
  final String tipo = '';
  final String usuario = '';
  // Esta funcion se ejecuta antes de que el widget sea lanzado
  @override
  void initState() {
    super.initState();
    getUsuarios();
    _correo.addListener(() {
      final String text = _correo.text.toLowerCase();
      _correo.value = _correo.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    _nivel.addListener(() {
      final String text = _nivel.text.toLowerCase();
      _nivel.value = _nivel.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    _nombre.addListener(() {
      final String text = _nombre.text.toLowerCase();
      _nombre.value = _nombre.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    _password.addListener(() {
      final String text = _password.text.toLowerCase();
      _password.value = _password.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    _tipo.addListener(() {
      final String text = _tipo.text.toLowerCase();
      _tipo.value = _tipo.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    _usuario.addListener(() {
      final String text = _usuario.text.toLowerCase();
      _usuario.value = _usuario.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  void getUsuarios() async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('usuarios');
    QuerySnapshot usuarios = await collectionReference.get();

    usuarioslista.clear();

    if (usuarios.docs.isNotEmpty) {
      for (var doc in usuarios.docs) {
        // ignore: avoid_print
        print(doc.data());
        usuarioslista.add(doc.data());
      }
    }
  }

  Future<void> setUsuarios(correo, nivel, nombre, password, tipo, usuario) {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('usuarios');
    return collectionReference
      .add({
        'avatar': '',
        'correo': correo,
        'idu': usuarioslista.length,
        'nivel': nivel,
        'nombre': nombre,
        'password': password,
        'tipo': tipo,
        'usuario': usuario
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  void dispose() {
    _correo.dispose();
    _nivel.dispose();
    _nombre.dispose();
    _password.dispose();
    _tipo.dispose();
    _usuario.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: menu()
    );
  }

  Widget menu(){
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Row(
              children: List.generate(opciones.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: GestureDetector(
                    onTap: ((){
                      setState(() {
                        activoMenu1 = index;
                        getUsuarios();
                      });
                    }),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opciones[index],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        activoMenu1 == index ?
                          Container(
                            width: 40,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5)
                            ),
                          ) : Container()
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 20),
        activoMenu1 == 0 ? listado() : activoMenu1 == 1 ? agregar() : Text('No hay nada')
      ],
    );
  }
  
  Widget listado(){
    return Column(
      children: List.generate(usuarioslista.length, (index) {
        return GestureDetector(
          child: Row(
            children: [
              Text('Nombre: ' + usuarioslista[index]['nombre'] + '    Usuario: ' + usuarioslista[index]['usuario'] + '    Correo: ' + usuarioslista[index]['correo']),
            ],
          ),
        );
      })
    );
  }

  Widget agregar(){
    return Column(
      children: [
        TextFormField(
          controller: _correo,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'correo'
          ),
        ),
        TextFormField(
          controller: _nivel,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'nivel'
          ),
        ),
        TextFormField(
          controller: _nombre,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'nombre'
          ),
        ),
        TextFormField(
          controller: _password,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'password'
          ),
        ),
        TextFormField(
          controller: _tipo,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'tipo'
          ),
        ),
        TextFormField(
          controller: _usuario,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'usuario'
          ),
        ),
        FlatButton(
          onPressed: (){
            setState(() {
              setUsuarios(_correo.text.toString(), _nivel.text.toString(), _nombre.text.toString(), _password.text.toString(), _tipo.text.toString(), _usuario.text.toString());
            });
          },
          child: Text('Agregar')
        )
      ],
    );
  }
}
