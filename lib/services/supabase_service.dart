import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter/foundation.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  // Products CRUD
  Future<List<Map<String, dynamic>>> fetchProducts(String userId) async {
    final data = await client
        .from('products')
        .select()
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(data);
  }

  // Farms CRUD
  Future<List<Map<String, dynamic>>> fetchFarms(String userId) async {
    try {
      final data = await client
          .from('farms')
          .select()
          .eq('user_id', userId)
          .timeout(const Duration(seconds: 10));
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint('Supabase fetchFarms error: $e');
      return [];
    }
  }

  // Favorites CRUD
  Future<List<Map<String, dynamic>>> fetchFavorites(String userId) async {
    final data = await client
        .from('favorites')
        .select()
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(data);
  }

  // Orders CRUD
  Future<List<Map<String, dynamic>>> fetchOrders(String userId) async {
    final data = await client
        .from('orders')
        .select()
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(data);
  }

  // Messages CRUD
  Future<List<Map<String, dynamic>>> fetchMessages(String userId) async {
    final data = await client
        .from('messages')
        .select()
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(data);
  }

  // Real-time streams
  Stream<List<Map<String, dynamic>>> ordersStream(String userId) {
    return client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => List<Map<String, dynamic>>.from(data));
  }

  Stream<List<Map<String, dynamic>>> messagesStream(String userId) {
    return client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => List<Map<String, dynamic>>.from(data));
  }
}
