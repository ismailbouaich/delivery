import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:my_app/constants/constant.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_app/views/login_page.dart';
class AuthenticationController extends GetxController {

  final isLoading=false.obs;

  final token=''.obs;

  final box=GetStorage();

  Future register({required String name,required String email,required String username,required String password})async{
    
   try {
      isLoading.value=true;
    var data={
      'name':name,
      'username':username,
       'email':email,
      'password':password,
    };
    var response = await http.post(
      Uri.parse('${url}register_delivery'),
      headers: {
        'Accept':'application/json',
      },
      body: data,
    );

    if (response.statusCode==200) {
    isLoading.value=false;
       token.value=json.decode(response.body)['token'];
    box.write('token', token.value);  
        Get.toNamed('/home');
    }else{
       isLoading.value=false;
       Get.snackbar(
        'Error',
        json.decode(response.body)['message'],
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white
       );
       print(json.decode(response.body));
    }
   } catch (e) {
    isLoading.value=false;
     print(e.toString());
   }
  }

 Future login({required String email, required String password}) async {
  try {
    isLoading.value = true;
    var data = {
      'email': email,
      'password': password,
    };
    var response = await http.post(
      Uri.parse('${url}login_delivery'),
      headers: {
        'Accept': 'application/json',
      },
      body: data,
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.body.isNotEmpty) {
      var decodedResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        token.value = decodedResponse['token'];
        box.write('token', token.value);
        Get.toNamed('/home');
      } else {
        Get.snackbar(
          'Error',
          decodedResponse['message'] ?? 'An error occurred',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'Empty response from server',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
    }
  } catch (e) {
    print('Error: ${e.toString()}');
    Get.snackbar(
      'Error',
      'An unexpected error occurred',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white
    );
  } finally {
    isLoading.value = false;
  }
}
  Future<void> logout() async {
    try {
      // Clear the token from storage
      await box.remove('token');
      
      // Reset the token value in the controller
      token.value = '';

      // Redirect to the login page
      Get.offAll(() => const LoginPage()); // Replace LoginPage with your actual login page widget
    } catch (e) {
      print('Logout error: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to logout. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
    }
  }
  
}
