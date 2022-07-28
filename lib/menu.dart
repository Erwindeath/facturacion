import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

@override
Widget MenuLateral(BuildContext context, String token) {
  var response = obtenerUsuarios(token);
  return new Drawer(
    child: ListView(
      children: <Widget>[
        new UserAccountsDrawerHeader(
          accountName: Text("Tortuga"),
          accountEmail: Text(token),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(
                "https://w7.pngwing.com/pngs/104/119/png-transparent-orange-and-white-logo-computer-icons-icon-design-person-person-miscellaneous-logo-silhouette-thumbnail.png"),
            fit: BoxFit.cover,
          )),
        ),
        Ink(
          color: Colors.indigo,
          child: new ListTile(
            title: Text(
              "Usuarios",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}

Future<http.Response> obtenerUsuarios(String token) async {
  var datos = null;
  http.Response response = await http.get(
    Uri.parse("https://infofsg.com/mockapi/auth/datos_usuario"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'access-token': token,
    },
  );
  // print(response.statusCode);
  return response;
}
