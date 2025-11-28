import 'package:go_router/go_router.dart';
import '../features/home/screens/home_screen.dart';
import '../features/letter/screens/letter_list_screen.dart';
import '../features/letter/screens/letter_create_screen.dart';
import '../features/letter/screens/letter_detail_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/letters',
      builder: (context, state) => const LettersListScreen(),
    ),
    GoRoute(
      path: '/letter/create',
      builder: (context, state) {
        final extra = state.extra;
        return LetterCreateScreen(jenisSurat: extra);
      },
    ),
    GoRoute(
      path: '/letter/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return LetterDetailScreen(id: id);
      },
    ),
  ],
);
