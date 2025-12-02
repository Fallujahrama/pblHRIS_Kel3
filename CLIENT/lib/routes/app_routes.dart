import 'package:go_router/go_router.dart';
import '../features/home/screens/home_screen.dart';
import '../features/letter/screens/letter_list_screen.dart';
import '../features/letter/screens/letter_template_form_screen.dart';
import '../features/letter/models/letter_format.dart';

import '../features/form/screen/form_surat_page.dart';
import '../features/form/screen/hrd_list_page.dart';
import '../features/form/screen/hrd_detail_page.dart';

class AppRoutes {
  static const formSurat = "/form-surat";
  static const hrdList = "/hrd-list";
  static const detailSurat = "/detail-surat";
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Home
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),

    // Form Surat - KARYAWAN mengajukan surat
    GoRoute(
      path: AppRoutes.formSurat,
      builder: (context, state) => const FormSuratPage(),
    ),

    // HRD List - HRD melihat daftar pengajuan
    GoRoute(
      path: AppRoutes.hrdList,
      builder: (context, state) => const HrdListPage(),
    ),

    // Detail Surat - HRD melihat detail pengajuan
    GoRoute(
      path: AppRoutes.detailSurat,
      builder: (context, state) =>
          HrdDetailPage(surat: state.extra as Map<String, dynamic>),
    ),

    // Letter Template Management - ADMIN kelola template
    GoRoute(
      path: '/letters',
      builder: (context, state) => const LettersListScreen(),
    ),

    // Create template baru - ADMIN buat template
    GoRoute(
      path: '/letter/template/create',
      builder: (context, state) => const LetterTemplateFormScreen(),
    ),

    // Edit template - ADMIN edit template
    GoRoute(
      path: '/letter/template/edit',
      builder: (context, state) {
        final template = state.extra as LetterFormat;
        return LetterTemplateFormScreen(template: template);
      },
    ),
  ],
);
