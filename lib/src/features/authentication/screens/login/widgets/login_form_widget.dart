import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../constants/text_strings.dart';
import '../../../../../utils/Helper/helper_controller.dart';
import '../../../../../commom_widgets/buttons/primary_button.dart';
import '../../../controllers/login_controller.dart';
import '../../forget_pass/forget_pass_options/fgt_pass_modal_bottom_sheet.dart';

/// [LoginFormWidget] é um widget que contém os campos e botões
/// necessários para realizar o login do usuário.
class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Controlador para as funções de login e estados associados.
    final controller = Get.put(LoginController());

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Form(
        key: controller.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Campo E-mail
            TextFormField(
              validator: Helper.validateEmail,
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(LineAwesomeIcons.user),
                labelText: tEmail,
                hintText: tEmail,
              ),
            ),
            const Gap(10),

            //* Campo Senha com opção de mostrar/esconder a senha.

            // Obx é usado para observar as mudanças do estado e reconstruir o widget quando
            // o valor observado (showPassword) muda.
            Obx(
              () => TextFormField(
                controller: controller.passwordController,
                validator: (value) {
                  if (value!.isEmpty) return 'Insira sua senha.';
                  return null;
                },
                obscureText: controller.showPassword.value ? false : true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.fingerprint_rounded),
                  labelText: tPassword,
                  hintText: tPassword,

                  // Botão para alternar a visibilidade da senha.
                  // A visibilidade da senha é controlada pelo valor de 'showPassword' no controlador.
                  suffixIcon: IconButton(
                    icon: controller.showPassword.value
                        ? const Icon(LineAwesomeIcons.eye)
                        : const Icon(LineAwesomeIcons.eye_slash),
                    onPressed: () => controller.showPassword.value =
                        !controller.showPassword.value,
                  ),
                ),
              ),
            ),
            const Gap(10),

            // ...

            Align(
              alignment: Alignment.centerRight,
              // Botão que abre o modal de "esqueci minha senha".
              child: TextButton(
                onPressed: () =>
                    ForgetPasswordScreen.buildShowModalBottomSheet(context),
                child: const Text(tForgetPassword),
              ),
            ),

            /// Botão de login.

            // Obx é usado para observar a mudança de estado e reconstruir o widget quando
            // os valores observados (isLoading, isFacebookLoading, isGoogleLoading) mudam.
            Obx(
              () => MyPrimaryButton(
                isLoading: controller.isLoading.value ? true : false,
                text: tLogin,

                // O botão ficará desabilitado se qualquer um dos processos de carregamento estiver ativo.
                onPressed: controller.isGoogleLoading.value
                    ? () {}
                    : controller.isLoading.value
                        ? () {}
                        : () => controller.login(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}