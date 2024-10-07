import 'dart:convert';

List<Order> ordersFromJson(String str) => 
    List<Order>.from(json.decode(str)['orders'].map((x) => Order.fromJson(x)));

String ordersToJson(List<Order> data) => 
    json.encode({"orders": List<dynamic>.from(data.map((x) => x.toJson()))});

class Order {
    int id;
    String firstName;
    String lastName;
    String email;
    String phone;
    String status;
    double shippingCost;
     final double? latitude;
  final double? longitude;
    List<OrderDetail> orderDetails;

    Order({
        required this.id,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.phone,
        required this.status,
        required this.shippingCost,
        required this.orderDetails,
         this.latitude,
    this.longitude,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        status: json["status"],
         latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : null,
        shippingCost: double.parse(json["shipping_cost"]),
        orderDetails: List<OrderDetail>.from(json["order_details"].map((x) => OrderDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "status": status,
        "shipping_cost": shippingCost.toStringAsFixed(2),
        "order_details": List<dynamic>.from(orderDetails.map((x) => x.toJson())),
    };
}

class OrderDetail {
    int id;
    int orderId;
    int productId;
    double totalPrice;
    int quantity;
    String city;
    String address;
    String zipCode;

    OrderDetail({
        required this.id,
        required this.orderId,
        required this.productId,
        required this.totalPrice,
        required this.quantity,
        required this.city,
        required this.address,
        required this.zipCode,
    });

    factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json["id"],
        orderId: json["order_id"],
        productId: json["product_id"],
        totalPrice: double.parse(json["total_price"]),
        quantity: json["quantity"],
        city: json["city"],
        address: json["address"],
        zipCode: json["zip_code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "product_id": productId,
        "total_price": totalPrice.toStringAsFixed(2),
        "quantity": quantity,
        "city": city,
        "address": address,
        "zip_code": zipCode,
    };
}