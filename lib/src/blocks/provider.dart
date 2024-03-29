import 'package:flutter/material.dart';
import 'package:form_validation/src/blocks/login_block.dart';
export 'package:form_validation/src/blocks/login_block.dart';
import 'package:form_validation/src/blocks/productos.bloc.dart';
export 'package:form_validation/src/blocks/productos.bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = LoginBlock();
  final _productosBloc = ProductosBloc();

  static Provider? _instancia;

  factory Provider({Key? key, Widget? child}) {
    if (_instancia == null) {
      _instancia = Provider._internal(key: key, child: child);
    }
    //_instancia ??= Provider._internal(key: key, child: child!);

    return _instancia!;
  }

  Provider._internal({Key? key, Widget? child})
      : super(key: key, child: child!);

  /*Provider({Key? key, Widget? child})
      : super(key: key, child: child!);*/

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBlock of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()!.loginBloc;
  }

  static ProductosBloc productosBloc(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>(
            aspect: Provider) as Provider)
        ._productosBloc;
  }
}
