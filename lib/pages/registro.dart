import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class resgistrosStado extends StatefulWidget {
  resgistrosStado({Key? key}) : super(key: key);

  @override
  State<resgistrosStado> createState() => _resgistrosStadoState();
}

class _resgistrosStadoState extends State<resgistrosStado> {
  late SharedPreferences sharedPreferences;
  String token = "";
  List<dynamic> datosbody = [];
  var _cards = [];
  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  final TextEditingController nombreController = new TextEditingController();
  final TextEditingController apellidodController = new TextEditingController();
  final TextEditingController cedulaController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController usuarioControler = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final TextEditingController _controller = TextEditingController();

  final TextEditingController apellidodController2 =
      new TextEditingController();
  final TextEditingController cedulaController2 = new TextEditingController();
  final TextEditingController emailController2 = new TextEditingController();
  final TextEditingController usuarioControler2 = new TextEditingController();
  final TextEditingController passwordController2 = new TextEditingController();
  String validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value))
      return 'Enter a valid email address';
    else
      return "Eror";
  }

  @override
  Widget build(BuildContext context) {
    print(datosbody);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Card(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          child: Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0)), //this right here
                                    child: SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 20.0),
                                        height: 450,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextField(
                                                controller: nombreController,
                                                cursorColor: Colors.white,
                                                decoration: InputDecoration(
                                                    icon: Icon(Icons.person_add,
                                                        color: const Color(
                                                            0xFF1BC0C5)),
                                                    hintText: 'Nombre'),
                                              ),
                                              TextField(
                                                controller: apellidodController,
                                                cursorColor: Colors.white,
                                                decoration: InputDecoration(
                                                    icon: Icon(Icons.person_add,
                                                        color: const Color(
                                                            0xFF1BC0C5)),
                                                    hintText: 'Apellido'),
                                              ),
                                              TextField(
                                                controller: cedulaController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Only numbers can be entered
                                                cursorColor: Colors.white,
                                                decoration: InputDecoration(
                                                    icon: Icon(Icons.contacts,
                                                        color: const Color(
                                                            0xFF1BC0C5)),
                                                    hintText: 'Cedula'),
                                              ),
                                              TextFormField(
                                                validator: (value) =>
                                                    validateEmail(value),
                                                controller: emailController,
                                                cursorColor: Colors.white,
                                                decoration: InputDecoration(
                                                    icon: Icon(Icons.email,
                                                        color: const Color(
                                                            0xFF1BC0C5)),
                                                    hintText: 'Email'),
                                              ),
                                              TextField(
                                                controller: usuarioControler,
                                                cursorColor: Colors.white,
                                                decoration: InputDecoration(
                                                    icon: Icon(Icons.person,
                                                        color: const Color(
                                                            0xFF1BC0C5)),
                                                    hintText: 'usuario'),
                                              ),
                                              TextFormField(
                                                controller: passwordController,
                                                cursorColor: Colors.white,
                                                decoration: InputDecoration(
                                                    icon: Icon(Icons.key,
                                                        color: const Color(
                                                            0xFF1BC0C5)),
                                                    hintText: 'contraseña'),
                                              ),
                                              SizedBox(
                                                width: 320.0,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    registroAdd(
                                                        usuarioControler.text,
                                                        apellidodController
                                                            .text,
                                                        emailController.text,
                                                        cedulaController.text,
                                                        usuarioControler.text,
                                                        passwordController
                                                            .text);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "Save",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: const Text('Agregar nuevo'),
                        ),
                      ))
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: _cards.length,
                      itemBuilder: (ontext, index) => Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 32, bottom: 10, left: 16, right: 16),
                              child: Column(
                                children: [
                                  InkWell(
                                      child: Text(_cards[index].toString())),
                                  Row(
                                    children: [
                                      InkWell(
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: ElevatedButton.icon(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: 20.0,
                                            ),
                                            label: Container(
                                                child: Text(
                                              'Eliminar',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 15.0),
                                            )),
                                            onPressed: () {
                                              eliminarUsuario(_cards[index]
                                                      ["id"]
                                                  .toString());
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              primary:
                                                  Colors.white.withOpacity(0),
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        20.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        child: ElevatedButton.icon(
                                          icon: Icon(
                                            Icons.update,
                                            color: Colors.blue,
                                            size: 30.0,
                                          ),
                                          label: Container(
                                              child: Text(
                                            'Editar',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 15.0),
                                          )),
                                          onPressed: () {
                                            _controller.value =
                                                _controller.value.copyWith(
                                                    text: _cards[index]
                                                            ["nombre"]
                                                        .toString(),
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset: _controller
                                                                .text.length));
                                            apellidodController2.value =
                                                apellidodController2.value.copyWith(
                                                    text: _cards[index]
                                                            ["apellido"]
                                                        .toString(),
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset:
                                                                apellidodController2
                                                                    .text
                                                                    .length));
                                            cedulaController2.value =
                                                cedulaController2.value.copyWith(
                                                    text: _cards[index]
                                                            ["cedula"]
                                                        .toString(),
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset:
                                                                cedulaController2
                                                                    .text
                                                                    .length));
                                            emailController2.value =
                                                emailController2.value.copyWith(
                                                    text: _cards[index]
                                                            ["correo"]
                                                        .toString(),
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset:
                                                                emailController2
                                                                    .text
                                                                    .length));
                                            usuarioControler2.value =
                                                usuarioControler2.value.copyWith(
                                                    text: _cards[index]["apodo"]
                                                        .toString(),
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset:
                                                                usuarioControler2
                                                                    .text
                                                                    .length));
                                            passwordController2.value =
                                                passwordController2.value.copyWith(
                                                    text: _cards[index]
                                                            ["contraseña"]
                                                        .toString(),
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset:
                                                                passwordController2
                                                                    .text
                                                                    .length));

                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20.0)), //this right here
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    15.0,
                                                                vertical: 20.0),
                                                        height: 450,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              TextField(
                                                                controller:
                                                                    _controller,
                                                                cursorColor:
                                                                    Colors
                                                                        .white,
                                                                decoration: InputDecoration(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .person_add,
                                                                        color: const Color(
                                                                            0xFF1BC0C5)),
                                                                    hintText:
                                                                        'Nombre'),
                                                              ),
                                                              TextField(
                                                                controller:
                                                                    apellidodController2,
                                                                cursorColor:
                                                                    Colors
                                                                        .white,
                                                                decoration: InputDecoration(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .person_add,
                                                                        color: const Color(
                                                                            0xFF1BC0C5)),
                                                                    hintText:
                                                                        'Apellido'),
                                                              ),
                                                              TextField(
                                                                controller:
                                                                    cedulaController2,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                inputFormatters: <
                                                                    TextInputFormatter>[
                                                                  FilteringTextInputFormatter
                                                                      .digitsOnly
                                                                ], // Only numbers can be entered
                                                                cursorColor:
                                                                    Colors
                                                                        .white,
                                                                decoration: InputDecoration(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .contacts,
                                                                        color: const Color(
                                                                            0xFF1BC0C5)),
                                                                    hintText:
                                                                        'Cedula'),
                                                              ),
                                                              TextFormField(
                                                                validator: (value) =>
                                                                    validateEmail(
                                                                        value),
                                                                controller:
                                                                    emailController2,
                                                                cursorColor:
                                                                    Colors
                                                                        .white,
                                                                decoration: InputDecoration(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .email,
                                                                        color: const Color(
                                                                            0xFF1BC0C5)),
                                                                    hintText:
                                                                        'Email'),
                                                              ),
                                                              TextField(
                                                                controller:
                                                                    usuarioControler2,
                                                                cursorColor:
                                                                    Colors
                                                                        .white,
                                                                decoration: InputDecoration(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .person,
                                                                        color: const Color(
                                                                            0xFF1BC0C5)),
                                                                    hintText:
                                                                        'usuario'),
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    passwordController2,
                                                                cursorColor:
                                                                    Colors
                                                                        .white,
                                                                decoration: InputDecoration(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .key,
                                                                        color: const Color(
                                                                            0xFF1BC0C5)),
                                                                    hintText:
                                                                        'contraseña'),
                                                              ),
                                                              SizedBox(
                                                                width: 320.0,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    editarUsuario(
                                                                        usuarioControler2
                                                                            .text,
                                                                        apellidodController2
                                                                            .text,
                                                                        emailController2
                                                                            .text,
                                                                        cedulaController2
                                                                            .text,
                                                                        usuarioControler2
                                                                            .text,
                                                                        passwordController2
                                                                            .text);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                    "Actualizar",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            primary:
                                                Colors.white.withOpacity(0),
                                            shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Text(_cards[index]['apellido']),
                          )),
                ],
              ),
            ),
          ),
        ));

    // print(datosbody["data"]);
    /*return Scaffold(
      body: Container(
      child: ListView(
        children: <Widget>[_listView()],
      ),
    )
    );*/
  }

  Widget _listView() {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.all(8),
      children: _usuarios(),
    );
  }

  editarUsuario(String nombre, String apellido, String cedula, String email,
      String usuario, String pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(token);
    var jsonResponse = null;
    http.Response response = await http.post(
        Uri.parse("https://infofsg.com/mockapi/auth/usuarios/update"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'access-token': token,
        },
        body: jsonEncode(<String, String>{
          "nombre": nombre,
          "apellido": apellido,
          "correo": email,
          "cedula": cedula,
          "apodo": usuario,
          "contraseña": pass
        }));
    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MainPage()),
          (Route<dynamic> route) => false);
    }
    print(response.statusCode);
  }

  eliminarUsuario(String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse = null;
    http.Response response = await http.post(
        Uri.parse("https://infofsg.com/mockapi/auth/usuarios/delete"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'access-token': token,
        },
        body: jsonEncode(<String, String>{
          "id": id,
        }));
    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MainPage()),
          (Route<dynamic> route) => false);
    }
    print(response.statusCode);
  }

  registroAdd(String nombre, String apellido, String cedula, String email,
      String usuario, String pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(token);
    var jsonResponse = null;
    http.Response response =
        await http.post(Uri.parse("https://infofsg.com/mockapi/auth/usuarios"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'access-token': token,
            },
            body: jsonEncode(<String, String>{
              "nombre": nombre,
              "apellido": apellido,
              "correo": email,
              "cedula": cedula,
              "apodo": usuario,
              "contraseña": pass
            }));
    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MainPage()),
          (Route<dynamic> route) => false);
    }
    print(response.statusCode);
  }

  checkStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var datos =
        await obtenerUsuarios(sharedPreferences.getString("token").toString());
    _cards = jsonDecode(datos.body)["data"];
    print(datos.body);
    setState(() {
      token = sharedPreferences.getString("token").toString();
      datosbody = jsonDecode(datos.body)["data"];
      _cards = jsonDecode(datos.body)["data"];
    });
  }

  List<Widget> _usuarios() {
    List<Widget> UsuariosData = [];
    datosbody.forEach((element) {
      //print(element);
      if (element["nombre"] != null) {
        UsuariosData.add(Text(element["nombre"]));
        UsuariosData.add(Text(element["apellido"]));
        UsuariosData.add(Text(element["correo"]));
        UsuariosData.add(Text(element["cedula"]));
      }
    });
    return UsuariosData;
  }
}

Future<http.Response> obtenerUsuarios(String token) async {
  return http.get(
    Uri.parse("https://infofsg.com/mockapi/auth/usuarios"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'access-token': token,
    },
  );
}
