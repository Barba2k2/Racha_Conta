import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../../commom_widgets/form/form_header_widget.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/image_strings.dart';
import '../../../../../constants/text_strings.dart';
import '../../../../../controllers/theme_controller/theme_controller.dart';
import '../../../../../repository/authentication_repository/authentication_repository.dart';
import '../../welcome/home_page.dart';
import '../forget_pass_otp/otp_screen.dart';



/// [ForgetPasswordPhoneScreen] é uma tela que permite ao usuário
/// redefinir sua senha usando autenticação via telefone.
class ForgetPasswordPhoneScreen extends StatelessWidget {
  ForgetPasswordPhoneScreen({Key? key}) : super(key: key);

  /// Formatação da máscara do telefone.
  final MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
    mask: '+## (##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final phoneNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Controlador para determinar se o tema escuro está ativo.
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    final controller = Get.put(AuthenticationRepository());

    return WillPopScope(
      // Controla o comportamento do botão voltar.
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          return false;
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30.0,
                color: isDark ? whiteColor : blackColor,
              ),
              onPressed: () {
                Get.offAll(() => const WelcomeScreen());
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Gap(80),
                  // Cabeçalho da tela.
                  FormHeaderWidget(
                    image: tForgetPasswordImage,
                    imageColor: isDark ? tPrimaryColor : tSecondaryColor,
                    title: tForgetPassword,
                    subTitle: tForgetPhoneSubTitle,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    heightBetween: 30.0,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(30),
                  Form(
                    child: Column(
                      children: [
                        // Campo de entrada para o número de telefone.
                        TextFormField(
                          controller: phoneNo,
                          decoration: const InputDecoration(
                            label: Text(tPhoneNo),
                            hintText: tPhoneNo,
                            prefixIcon: Icon(Icons.numbers),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            phoneFormatter,
                          ],
                          keyboardType: TextInputType.phone,
                        ),
                        const Gap(20.0),
                        // Botão para avançar para a próxima tela.
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Chama função de autenticação por telefone.
                              controller.phoneAuthentication(
                                phoneNo.text.trim(),
                              );
                              Get.to(() => const OTPScreen());
                            },
                            child: const Text(tNext),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}