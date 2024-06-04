import 'package:ais_visualizer/providers.dart/lg_connection_status_provider.dart';
import 'package:ais_visualizer/services/lg_service.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ais_visualizer/models/lg_connection_model.dart';

class ConnectionSection extends StatefulWidget {
  const ConnectionSection({Key? key}) : super(key: key);

  @override
  _ConnectionSectionState createState() => _ConnectionSectionState();
}

class _ConnectionSectionState extends State<ConnectionSection> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _ipController;
  late TextEditingController _portController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _screenNumberController;

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController();
    _portController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _screenNumberController = TextEditingController();
    _loadConnectionDetails();
  }

  Future<void> _loadConnectionDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final lgConnectionModel = LgConnectionModel();
    bool isPresent = await lgConnectionModel.isPresentInSharedPreferences(prefs);
    if (isPresent) {
      setState(() {
        _ipController.text = lgConnectionModel.ip;
        _portController.text = lgConnectionModel.port.toString();
        _usernameController.text = lgConnectionModel.userName;
        _passwordController.text = lgConnectionModel.password;
        _screenNumberController.text = lgConnectionModel.screenNumber.toString();
      });
    }
  }

  Future<void> _saveConnectionDetails() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final lgConnectionModel = LgConnectionModel();
      lgConnectionModel.ip = _ipController.text;
      lgConnectionModel.port = int.parse(_portController.text);
      lgConnectionModel.userName = _usernameController.text;
      lgConnectionModel.password = _passwordController.text;
      lgConnectionModel.screenNumber = int.parse(_screenNumberController.text);
      await lgConnectionModel.saveToSharedPreferences(prefs);
      
      final lgService = LgService();
      bool? isConnected = await lgService.connectToLG();
      if (isConnected != null && isConnected) {
        updateConnectionStatus(true);
        showSuccessSnackBar();
      } else {
        updateConnectionStatus(false);
        showFailureSnackBar();
      }
    }
  }

  void showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppTexts.connectedSuccessfully),
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(163, 0, 255, 8),
      ),
    );
  }

  void showFailureSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppTexts.connectionFailed),
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(173, 255, 0, 0),
      ),
    );
  }

  void updateConnectionStatus(bool isConnected) {
    final connectionStatusProvider =
        Provider.of<LgConnectionStatusProvider>(context, listen: false);
    connectionStatusProvider.updateConnectionStatus(isConnected);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 30.0),
          Center(
            child: Text(
              AppTexts.connectionLG,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(height: 20.0), // Add space
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    autofocus: true,
                    controller: _ipController,
                    decoration: const InputDecoration(
                      labelText: AppTexts.ip,
                      hintText: AppTexts.ipHint,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.darkGrey),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppTexts.ipError;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: _portController,
                    decoration: const InputDecoration(
                      labelText: AppTexts.port,
                      hintText: AppTexts.portHint,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.darkGrey),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppTexts.portError;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: AppTexts.username,
                      hintText: AppTexts.usernameHint,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.darkGrey),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppTexts.usernameError;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: AppTexts.password,
                      hintText: AppTexts.passwordHint,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.darkGrey),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppTexts.passwordError;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: _screenNumberController,
                    decoration: const InputDecoration(
                      labelText: AppTexts.screenNumber,
                      hintText: AppTexts.screenNumberHint,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.darkGrey),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppTexts.screenNumberError;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveConnectionDetails,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15.0),
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      backgroundColor: AppColors.accent,
                    ),
                    child: Text(
                      AppTexts.connect,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
