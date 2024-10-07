import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_app/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/constants/constant.dart';
import 'dart:convert';

class OrderController extends GetxController {
  final orders = <Order>[].obs;
  final status = RxStatus.empty().obs;
  final box = GetStorage();
 final isLoading = false.obs;
   final Set<String> _processingOrders = <String>{};

  @override
  void onInit() {
    getOrders();
    super.onInit();
  }

  Future<void> getOrders() async {
    try {
      status.value = RxStatus.loading();
      orders.clear();

      var response = await http.get(
        Uri.parse('${url}delivery-worker/orders'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        final content = json.decode(response.body)['orders'];
        orders.assignAll(content.map<Order>((item) => Order.fromJson(item)));
        status.value = RxStatus.success();
      } else {
        status.value = RxStatus.error('Failed to load orders');
        print(json.decode(response.body));
      }
    } catch (e) {
      status.value = RxStatus.error('An error occurred: ${e.toString()}');
      print(e.toString());
    }
  }
     Future<bool> completeOrder(String orderId) async {
        if (_processingOrders.contains(orderId)) {
      print('Order $orderId is already being processed');
      return false;
    }

    _processingOrders.add(orderId);
    try {
      isLoading.value = true;

      var response = await http.post(
        Uri.parse('${url}delivery-worker/orders/complete/$orderId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        if (responseBody['status'] == 'complete') {
          Get.snackbar('Success', responseBody['message'] ?? 'Order status updated successfully');
          await getOrders(); // Refresh the orders list
          return true;
        } else {
          Get.snackbar('Error', 'Unexpected response from server');
          return false;
        }
      } else if (response.statusCode == 404) {
        var responseBody = json.decode(response.body);
        print('Order not found: $responseBody');
        Get.snackbar('Error', responseBody['message'] ?? 'Order not found');
        return false;
      } else {
        print('Failed to complete order: ${response.body}');
        Get.snackbar('Error', 'Failed to complete order');
        return false;
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      Get.snackbar('Error', 'An error occurred while completing the order');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}