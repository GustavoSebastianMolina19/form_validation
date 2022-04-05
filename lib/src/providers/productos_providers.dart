import 'dart:convert';

import 'package:form_validation/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';

import 'package:form_validation/src/models/producto_model.dart';

class ProductosProvider {
  final String _url =
      'https://flutter-varios-6575e-default-rtdb.firebaseio.com';

  final _prefs = PreferenciasUsuario();

  Future<bool> crearProdcuto(ProductoModel producto) async {
    final url = Uri.parse('$_url/productos.json?auth=${_prefs.token}');

    final resp = await http.post(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<bool> editarProdcuto(ProductoModel producto) async {
    final url =
        Uri.parse('$_url/productos/${producto.id}.json?auth=${_prefs.token}');

    final resp = await http.put(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = Uri.parse('$_url/productos.json?auth=${_prefs.token}');
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = [];

    if (decodedData == null) return [];

    if (decodedData['error'] != null) return [];

    decodedData.forEach((id, producto) {
      final prodTemp = ProductoModel.fromJson(producto);
      prodTemp.id = id;

      productos.add(prodTemp);
    });

    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final url = Uri.parse('$_url/productos/$id.json?auth=${_prefs.token}');
    final resp = await http.delete(url);

    print(json.decode(resp.body));
    return 1;
  }

  Future<String?> subirImagen(XFile imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dkzeyz2wh/image/upload?upload_preset=ikttxbf7');
    final mimeType = mime(imagen.path)!.split('/');
    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath(
      'file',
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      return null;
    } else {
      final responseData = json.decode(resp.body);

      return responseData['secure_url'];
    }
  }
}
