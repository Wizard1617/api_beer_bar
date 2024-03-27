import 'package:api_beer_bar/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {

  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _middleNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (context) => RegisterCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text('Регистрация')),
        body: SingleChildScrollView(child: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              Navigator.pushReplacementNamed(context, '/login');
            } else if (state is RegisterFailure) {
              final snackBar = SnackBar(content: Text(state.error));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(labelText: 'Имя'),
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: 'Фамилия'),
                ),
                TextFormField(
                  controller: _middleNameController,
                  decoration: InputDecoration(labelText: 'Отчество'),
                ),
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
                  onPressed: () => context.read<RegisterCubit>().register(
                    firstName: _firstNameController.text.trim(),
                    lastName: _lastNameController.text.trim(),
                    middleName: _middleNameController.text.trim(),
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  ),
                  child: Text('Зарегистрироваться'),
                ),
              ],
            ),
          ),
        ),)
      ),
    );
  }

  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
