import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'YOUR_SUPABASE_URL_HERE';
  static const String anonKey = 'YOUR_ANON_KEY_HERE';
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }
}

// Global reference
final supabase = Supabase.instance.client;