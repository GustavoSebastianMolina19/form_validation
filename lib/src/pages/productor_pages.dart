import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validation/src/blocks/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scafolldkey = GlobalKey<ScaffoldState>();

  ProductosBloc? productosBloc;
  ProductoModel producto = ProductoModel();
  bool _guardando = false;
  XFile? foto;

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);

    final Object? prodData = ModalRoute.of(context)?.settings.arguments;

    if (prodData != null) {
      producto = prodData as ProductoModel;
    }

    return Scaffold(
      key: scafolldkey,
      appBar: AppBar(
        title: Text('Prodctos'),
        actions: [
          IconButton(
            onPressed: _seleccionarFoto,
            icon: Icon(Icons.photo_size_select_actual),
          ),
          IconButton(
            onPressed: _tomarFoto,
            icon: const Icon(Icons.camera_alt),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                (_guardando)
                    ? const CircularProgressIndicator()
                    : _crearBoton(),
                //_crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (value) => producto.titulo = value!,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (value) => producto.valor = double.parse(value!),
      validator: (value) {
        if (utils.isNumeric(value!)) {
          return null;
        } else {
          return 'Ingresa solo números';
        }
      },
    );
  }

  Widget _crearBoton() {
    return Container(
      child: ElevatedButton.icon(
        onPressed: (_guardando) ? null : _submit,
        label: Text('Guardar'),
        icon: Icon(Icons.save),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();

    setState(() {
      _guardando = true;
    });

    if (foto != null) {
      producto.fotoUrl = await productosBloc?.subirFoto(foto!);
    }

    if (producto.id == null) {
      productosBloc!.agregarProducto(producto);
    } else {
      productosBloc?.editarProducto(producto);
    }

    mostrarSnackbar('Registro guardado');
    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
    //scafolldkey.currentState.showSnackBar(snackbar);
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(producto.fotoUrl!),
        height: 300.0,
        fit: BoxFit.cover,
      );
    } else {
      if (foto != null) {
        return Image.file(
          File(foto!.path),
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final ImagePicker _picker = ImagePicker();
    foto = await _picker.pickImage(
      source: origen,
    );

    if (foto != null) {
      producto.fotoUrl = null;
    }

    setState(() {});
  }
}
