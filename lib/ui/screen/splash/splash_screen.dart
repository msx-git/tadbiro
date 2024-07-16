import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          SizedBox(
            height: 160,
            width: 300,
            child: SvgPicture.asset(Assets.signLogo),
          ),
          Text(
            "Tadbiro",
            style: GoogleFonts.caveat(
              fontWeight: FontWeight.w700,
              fontSize: 60,
              color: Colors.orange.shade800,
            ),
          )
        ],
      ),
    );
  }
}
