import 'package:dependencies/dependencies.dart';
import 'package:dependencies_flutter/dependencies_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneparking_citizen/util/state-util.dart';
import 'package:oneparking_citizen/util/widget_util.dart';

import 'loader_bloc.dart';

class LoaderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InjectorWidget.bind(
      bindFunc: (binder) {
        final injector = InjectorWidget.of(context);
        binder.bindSingleton(LoaderBloc(injector.get(), injector.get()));
      },
      child: LoaderContainer(),
    );
  }
}

class LoaderContainer extends StatelessWidget with InjectorWidgetMixin {
  @override
  Widget buildWithInjector(BuildContext context, Injector injector) {
    final _bloc = injector.get<LoaderBloc>();
    return Material(
      child: BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          if (state is InitialState) {
            _bloc.dispatch(LoaderEvent.fetchData);
          }
          if (state is SuccessState || state is ErrorState) {
            goToMain(context);
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text("Cargando Configuración...",
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ],
          );
        },
      ),
    );
  }

  void goToMain(BuildContext context) {
    onWidgetDidBuild(() {
      Navigator.pushReplacementNamed(context, '/main');
    });
  }
}
