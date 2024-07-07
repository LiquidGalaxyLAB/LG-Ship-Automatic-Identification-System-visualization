import 'package:ais_visualizer/models/ais_connection_model.dart';
import 'package:ais_visualizer/providers/AIS_connection_status_provider.dart';
import 'package:ais_visualizer/services/auth_service.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TokenSection extends StatefulWidget {
  const TokenSection({Key? key}) : super(key: key);

  @override
  State<TokenSection> createState() => _TokenSectionState();
}

class _TokenSectionState extends State<TokenSection> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _clientIdController;
  late TextEditingController _clientSecretController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _clientIdController = TextEditingController();
    _clientSecretController = TextEditingController();
    _loadConnectionDetails();
  }

  Future<void> _loadConnectionDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final aisConnectionModel = AisConnectionModel();
    bool isPresent =
        await aisConnectionModel.isPresentInSharedPreferences(prefs);
    if (isPresent) {
      setState(() {
        _clientIdController.text = aisConnectionModel.clientId;
        _clientSecretController.text = aisConnectionModel.clientSecret;
      });
    }
  }

  Future<void> _saveConnectionDetails() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final prefs = await SharedPreferences.getInstance();
      final aisConnectionModel = AisConnectionModel();
      aisConnectionModel.clientId = _clientIdController.text;
      aisConnectionModel.clientSecret = _clientSecretController.text;
      await aisConnectionModel.saveToSharedPreferences(prefs);

      bool isTokenValid = await AuthService.fetchToken(aisConnectionModel.clientId, aisConnectionModel.clientSecret);
      if (isTokenValid) {
        setState(() {
          _isLoading = false;
        });
        showSuccessSnackBar();
        updateConnectionStatus(true);
      } else {
        updateConnectionStatus(false);
        showFailureDialogue();
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void updateConnectionStatus(bool isConnected) {
    final connectionStatusProvider =
        Provider.of<AisConnectionStatusProvider>(context, listen: false);
    connectionStatusProvider.updateConnectionStatus(isConnected);
  }

  void showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppTexts.connectedAisSuccessfully),
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(163, 0, 255, 8),
      ),
    );
  }

  void showFailureDialogue() {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: 500.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      AppTexts.connectionAisFailed,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(color: AppColors.error),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      AppTexts.connectionAisFailedExplanation,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      style: ButtonStyle(
                        side: WidgetStateProperty.all(const BorderSide(
                            color: AppColors.darkGrey, width: 3.0)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppTexts.ok,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: AppColors.darkGrey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    _clientIdController.dispose();
    _clientSecretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 30.0),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
            child: Center(
              child: Text(
                AppTexts.credentialsTitle,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: _clientIdController,
                    decoration: const InputDecoration(
                      labelText: AppTexts.clientId,
                      hintText: AppTexts.clientIdHint,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.darkGrey),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppTexts.clientIdError;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: _clientSecretController,
                    decoration: const InputDecoration(
                      labelText: AppTexts.clientSecret,
                      hintText: AppTexts.clientSecretHint,
                    ),
                    obscureText: true,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.darkGrey),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppTexts.clientSecretError;
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
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            AppTexts.getTokens,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            decoration: BoxDecoration(
              color: AppColors.softGrey,
              border: Border.all(
                color: AppColors.darkGrey,
                width: 5.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0),
                  Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: AppColors.darkerGrey,
                                    height: 1.5,
                                  ),
                          children: [
                            TextSpan(
                              text: 'How to get your credentials\n\n\n',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    color: AppColors.darkerGrey,
                                  ),
                            ),
                            const TextSpan(
                                text:
                                    'In order to access the BarentsWatch API, follow these steps:\n\n\n'),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: AppColors.darkerGrey,
                                    height: 1.5,
                                  ),
                          children: [
                            const TextSpan(
                              text:
                                  '1. Register your own API Client connected to your user.\n\n'
                                  '2. Create a user and log in at: \n',
                            ),
                            TextSpan(
                              text: 'https://www.barentswatch.no/minside/',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 0, 121, 221),
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Color.fromARGB(255, 0, 121, 221),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _launchURL(
                                    'https://www.barentswatch.no/minside/'),
                            ),
                            const TextSpan(
                              text:
                                  '.\n\n3. Once logged in, scroll to find "Developer access".\n\n'
                                  '4. Choose "Show more" from API access.\n\n'
                                  '5. Find the "My clients" section and click on "New client".\n\n'
                                  '6. Fill in the form, ensuring you choose the right type of client (AIS-API).\n\n'
                                  '7. After creating the client, you will see the client ID and client secret (the password you wrote in the form).\n\n'
                                  '8. Make sure to use the client ID, not the URL-encoded client ID.',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
