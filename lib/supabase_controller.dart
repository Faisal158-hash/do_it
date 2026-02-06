import 'package:get_x/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseController extends GetxController {
  final supabase = Supabase.instance.client;

  // Observable list for dynamic data
  var items = <Map<String, dynamic>>[].obs;

  // Fetch data from a table
  Future<void> fetchItems() async {
    try {
      final response = await supabase.from('items').select();
      items.value = List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Add new item
  Future<void> addItem(String name) async {
    try {
      await supabase.from('items').insert({'name': name});
      fetchItems(); // Refresh list
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Delete item
  Future<void> deleteItem(int id) async {
    try {
      await supabase.from('items').delete().eq('id', id);
      fetchItems();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
