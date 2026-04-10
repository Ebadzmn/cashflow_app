import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'app_routes.dart';
import '../features/splash/splash_page.dart';
import '../features/splash/splash_binding.dart';
import '../features/onboarding/onboarding_page.dart';
import '../features/onboarding/onboarding_binding.dart';
import '../features/home/home_page.dart';
import '../features/home/home_binding.dart';
import '../features/home/home_controller.dart';
import '../features/auth/login/login_page.dart';
import '../features/auth/login/login_controller.dart';
import '../features/auth/signup/signup_page.dart';
import '../features/auth/signup/signup_controller.dart';
import '../features/auth/verify_email/verify_email_page.dart';
import '../features/auth/verify_email/verify_email_controller.dart';
import '../features/auth/otp/otp_page.dart';
import '../features/auth/otp/otp_controller.dart';
import '../features/auth/forgot_password/forgot_password_page.dart';
import '../features/auth/forgot_password/forgot_password_controller.dart';
import '../features/scan_receipt/scan_receipt_page.dart';
import '../features/audit_readiness/audit_readiness_page.dart';
import '../features/audit_readiness/expert_support_page.dart';
import '../features/scan_receipt/scan_receipt_controller.dart';
import '../features/profile/my_profile_page.dart';
import '../features/profile/edit_profile_page.dart';
import '../features/auth/forgot_password/change_password_page.dart';
import '../features/auth/forgot_password/change_password_controller.dart';
import '../features/premium_plans/premium_plans_page.dart';
import '../features/premium_plans/premium_plans_controller.dart';
import '../features/legal/terms_and_conditions_page.dart';
import '../features/legal/privacy_policy_page.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: Get.key,
    initialLocation: Routes.SPLASH,
    routes: [
      GoRoute(
        path: Routes.SPLASH,
        builder: (context, state) {
          SplashBinding().dependencies();
          return const SplashPage();
        },
      ),
      GoRoute(
        path: Routes.ONBOARDING,
        builder: (context, state) {
          OnboardingBinding().dependencies();
          return const OnboardingPage();
        },
      ),
      GoRoute(
        path: Routes.HOME,
        builder: (context, state) {
          final isPro = state.extra as bool? ?? true;
          HomeBinding().dependencies();
          // Inject isPro into the controller if it's already registered via HomeBinding
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().isPro.value = isPro;
          }
          return const HomePage();
        },
      ),
      GoRoute(
        path: Routes.LOGIN,
        builder: (context, state) {
          Get.lazyPut(() => LoginController());
          return const LoginPage();
        },
      ),
      GoRoute(
        path: Routes.SIGNUP,
        builder: (context, state) {
          Get.lazyPut(() => SignupController());
          return const SignupPage();
        },
      ),
      GoRoute(
        path: Routes.VERIFY_EMAIL,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          Get.lazyPut(() => VerifyEmailController(email: email));
          return const VerifyEmailPage();
        },
      ),
      GoRoute(
        path: Routes.OTP,
        builder: (context, state) {
          Get.lazyPut(() => OtpController());
          return const OtpPage();
        },
      ),
      GoRoute(
        path: Routes.FORGOT_PASSWORD,
        builder: (context, state) {
          Get.lazyPut(() => ForgotPasswordController());
          return const ForgotPasswordPage();
        },
      ),
      GoRoute(
        path: Routes.SCAN_RECEIPT,
        builder: (context, state) {
          Get.lazyPut(() => ScanReceiptController());
          return const ScanReceiptPage();
        },
      ),
      GoRoute(
        path: Routes.AUDIT_READINESS,
        builder: (context, state) => const AuditReadinessPage(),
      ),
      GoRoute(
        path: Routes.EXPERT_SUPPORT,
        builder: (context, state) => const ExpertSupportPage(),
      ),
      GoRoute(
        path: Routes.MY_PROFILE,
        builder: (context, state) => const MyProfilePage(),
      ),
      GoRoute(
        path: Routes.EDIT_PROFILE,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: Routes.CHANGE_PASSWORD,
        builder: (context, state) {
          Get.lazyPut(() => ChangePasswordController());
          return const ChangePasswordPage();
        },
      ),
      GoRoute(
        path: Routes.PREMIUM_PLANS,
        builder: (context, state) {
          Get.lazyPut(() => PremiumPlansController());
          return const PremiumPlansPage();
        },
      ),
      GoRoute(
        path: Routes.TERMS,
        builder: (context, state) => const TermsAndConditionsPage(),
      ),
      GoRoute(
        path: Routes.PRIVACY,
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
    ],
  );
}
