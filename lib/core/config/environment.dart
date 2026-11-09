// Environment configuration — never bake production secrets into source (FR-19)
// Values injected via --dart-define at build time
enum Env { development, staging, production }

class Environment {
  Environment._();

  static const String _env = String.fromEnvironment('APP_ENV', defaultValue: 'development');
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8000');
  static const String paystackPublicKey = String.fromEnvironment('PAYSTACK_PUBLIC_KEY');
  static const String googleClientId = String.fromEnvironment('GOOGLE_CLIENT_ID');
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static Env get current => switch (_env) {
        'production' => Env.production,
        'staging' => Env.staging,
        _ => Env.development,
      };

  static bool get isProduction => current == Env.production;
}
