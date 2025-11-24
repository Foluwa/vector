import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/auth/screens/landing_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/bank_connect_intro_screen.dart';
import '../../features/auth/screens/bank_connected_screen.dart';
import '../../features/payments/screens/pay_screen.dart';
import '../../features/payments/screens/receive_screen.dart';
import '../../features/payments/screens/history_screen.dart';
import '../../features/payments/screens/scan_qr_screen.dart';
import '../../features/payments/screens/generate_qr_screen.dart';
import '../../features/payments/screens/payment_review_screen.dart';
import '../../features/payments/screens/request_details_screen.dart';
import '../../features/payments/screens/transaction_detail_screen.dart';
import '../../features/payments/screens/session_detail_screen.dart';
import '../../features/payments/screens/session_active_screen.dart';
import '../../features/payments/screens/session_settlement_screen.dart';
import '../../features/payments/screens/emergency_topup_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/help_faq_screen.dart';
import '../../features/profile/screens/contact_support_screen.dart';
import '../../features/profile/screens/report_problem_screen.dart';
import '../../features/profile/screens/privacy_policy_screen.dart';
import '../../features/profile/screens/terms_of_service_screen.dart';
import '../../features/profile/screens/security_settings_screen.dart';
import '../../features/bank/screens/bank_accounts_screen.dart';
import '../../features/subscription/screens/pro_pricing_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState != null;
      final isAuthRoute = state.matchedLocation == '/' || state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      if (!isAuthenticated && !isAuthRoute) {
        return '/';
      }

      if (isAuthenticated && isAuthRoute) {
        return '/pay';
      }

      return null;
    },
    routes: [
      // Auth routes
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
      GoRoute(path: '/bank-connect-intro', builder: (context, state) => const BankConnectIntroScreen()),
      GoRoute(path: '/bank-connected', builder: (context, state) => const BankConnectedScreen()),

      // Main app routes
      GoRoute(
        path: '/pay',
        builder: (context, state) => const PayScreen(),
        routes: [
          GoRoute(path: 'scan', builder: (context, state) => const ScanQrScreen()),
          GoRoute(path: 'review', builder: (context, state) => const PaymentReviewScreen()),
        ],
      ),
      GoRoute(
        path: '/session-active/:id',
        builder: (context, state) => SessionActiveScreen(sessionId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/session-settlement/:id',
        builder: (context, state) => SessionSettlementScreen(sessionId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/receive',
        builder: (context, state) => const ReceiveScreen(),
        routes: [
          GoRoute(path: 'generate-qr', builder: (context, state) => const GenerateQrScreen()),
          GoRoute(
            path: 'request/:id',
            builder: (context, state) => RequestDetailsScreen(requestId: state.pathParameters['id']!),
          ),
          GoRoute(path: 'emergency-topup', builder: (context, state) => const EmergencyTopUpScreen()),
        ],
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
        routes: [
          GoRoute(
            path: 'transaction/:id',
            builder: (context, state) => TransactionDetailScreen(transactionId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'session/:id',
            builder: (context, state) => SessionDetailScreen(sessionId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(path: 'edit', builder: (context, state) => const EditProfileScreen()),
          GoRoute(path: 'notifications', builder: (context, state) => const NotificationSettingsScreen()),
          GoRoute(path: 'bank-accounts', builder: (context, state) => const BankAccountsScreen()),
          GoRoute(path: 'pro', builder: (context, state) => const ProPricingScreen()),
          // Support & Help routes
          GoRoute(path: 'help', builder: (context, state) => const HelpFaqScreen()),
          GoRoute(path: 'support', builder: (context, state) => const ContactSupportScreen()),
          GoRoute(path: 'report', builder: (context, state) => const ReportProblemScreen()),
          // Legal & Security routes
          GoRoute(path: 'privacy', builder: (context, state) => const PrivacyPolicyScreen()),
          GoRoute(path: 'terms', builder: (context, state) => const TermsOfServiceScreen()),
          GoRoute(path: 'security', builder: (context, state) => const SecuritySettingsScreen()),
        ],
      ),
    ],
  );
});
