import 'package:api_beer_bar/Page/beer_list_screen.dart';
import 'package:api_beer_bar/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Авторизация')),
      body: BlocProvider<AuthCubit>(
        create: (context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              // Если авторизация успешна, переходим на BeerListScreen
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BeerListScreen()));
            } else if (state is AuthFailure) {
              // Если произошла ошибка авторизации, показываем SnackBar с сообщением об ошибке
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            // Здесь может быть код для отображения состояния загрузки или любой другой UI, который зависит от состояния
            if (state is AuthLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Почта'),
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Пароль'),
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: () => context.read<AuthCubit>().login(
                    _emailController.text,
                    _passwordController.text,
                  ),
                  child: Text('Авторизация'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text('Зарегистрироваться'),
                ),
              ],
            );
          },
        )

      ),
    );
  }
}
