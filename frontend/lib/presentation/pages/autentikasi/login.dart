import 'package:flutter/material.dart';
import 'package:frontend_app/presentation/pages/beranda.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../../widget/background_widget.dart';
import '../../widget/button/button_widget.dart';
import '../../widget/input/placeholder_input.dart';
import '../../widget/button/text_button_widget.dart';
import 'lupa_password.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double paddingHorizontal = size.width * 0.1;
    final double gapSize = size.height * 0.02;

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundWidget(),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Selamat Datang',
                    style: GoogleFonts.poppins(
                      fontSize: size.width * 0.09,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Gap(gapSize),
                  Text(
                    'Silahkan login dengan username dan password anda',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Gap(gapSize * 1.5),
                  const PlaceholderInputWidget(
                    label: 'Username',
                    iconPath: 'assets/icons/icon-username.png',
                  ),
                  const PlaceholderInputWidget(
                    label: 'Password',
                    isPassword: true,
                    iconPath: 'assets/icons/icon-password.png',
                  ),
                  Gap(gapSize),

                  //
                  SizedBox(
                    width: size.width * 0.5,
                    child: FilledButtonWidget(
                      text: 'Login',
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const Beranda()),
                        );
                      },
                    ),
                  ),

                  Gap(gapSize * 0.8),

                  // **Tombol Lupa Password**
                  TextButtonWidget(
                    text: 'Lupa Password ?',
                    fontSize: size.width * 0.045,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LupaPassword(),
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
