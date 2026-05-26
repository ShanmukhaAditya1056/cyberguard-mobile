import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get headline =>
      GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textWhite);
  static TextStyle get title =>
      GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textWhite);
  static TextStyle get subtitle =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textMuted);
  static TextStyle get body =>
      GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textMuted);
  static TextStyle get bodyBright =>
      GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textWhite);
  static TextStyle get dim =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textDim);
  static TextStyle get button =>
      GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white);
  static TextStyle get badge =>
      GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textWhite);
}
