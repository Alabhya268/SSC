import 'package:cheque_app/models/notification_model.dart';
import 'package:cheque_app/models/orders_model.dart';
import 'package:cheque_app/models/payment_model.dart';
import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/models/product_list_model.dart';
import 'package:cheque_app/models/token_model.dart';
import 'package:cheque_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String getCurrentUserId() {
    return firebaseAuth.currentUser!.uid;
  }

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference paymentsRef =
      FirebaseFirestore.instance.collection("payments");
  final CollectionReference partiesRef =
      FirebaseFirestore.instance.collection("parties");
  final CollectionReference ordersRef =
      FirebaseFirestore.instance.collection("orders");
  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection("products");
  final CollectionReference tokensRef =
      FirebaseFirestore.instance.collection("tokens");
  final CollectionReference notificationsRef =
      FirebaseFirestore.instance.collection("notifications");

  Future<int> getUserOrders(String uid) => usersRef.doc(uid).get().then((user) {
        return UserModel.fromData(user.data() as Map<String, dynamic>).orders;
      });

  Stream<UserModel> getCurrentUserDetails() => usersRef
      .doc(getCurrentUserId())
      .snapshots()
      .map((user) => UserModel.fromData(user.data() as Map<String, dynamic>));

  Stream<List<UserModel>> getUsers() {
    UserModel _userModel;
    return usersRef.where('role', isNotEqualTo: 'Admin').snapshots().map(
          (QuerySnapshot<Object?> querySnapshot) => querySnapshot.docs.map(
            (user) {
              _userModel =
                  UserModel.fromData(user.data() as Map<String, dynamic>);
              _userModel.uid = user.id;
              return _userModel;
            },
          ).toList(),
        );
  }

  Stream<List<OrdersModel>> getPartyOrders({required String partyId}) {
    OrdersModel _ordersModel;
    return ordersRef
        .where('partyId', isEqualTo: partyId)
        .orderBy('issueDate', descending: true)
        .snapshots()
        .map(
          (QuerySnapshot<Object?> querySnapshot) =>
              querySnapshot.docs.map((order) {
            _ordersModel =
                OrdersModel.fromData(order.data() as Map<String, dynamic>);
            _ordersModel.id = order.id;
            return _ordersModel;
          }).toList(),
        );
  }

  Stream<List<OrdersModel>> getApprovedPartyOrders({required String partyId}) {
    OrdersModel _ordersModel;
    return ordersRef
        .where('partyId', isEqualTo: partyId)
        .where('status', isEqualTo: 'Approved')
        .orderBy('issueDate', descending: true)
        .snapshots()
        .map(
          (QuerySnapshot<Object?> querySnapshot) =>
              querySnapshot.docs.map((order) {
            _ordersModel =
                OrdersModel.fromData(order.data() as Map<String, dynamic>);
            _ordersModel.id = order.id;
            return _ordersModel;
          }).toList(),
        );
  }

  Stream<List<PaymentModel>> getPartyPayments({required String partyId}) {
    PaymentModel _paymentModel;
    return paymentsRef
        .where('partyId', isEqualTo: partyId)
        .orderBy('issueDate', descending: true)
        .snapshots()
        .map(
          (QuerySnapshot<Object?> querySnapshot) =>
              querySnapshot.docs.map((payment) {
            _paymentModel =
                PaymentModel.fromData(payment.data() as Map<String, dynamic>);
            _paymentModel.id = payment.id;
            return _paymentModel;
          }).toList(),
        );
  }

  Stream<List<PaymentModel>> getApprovedPartyPayments(
      {required String partyId}) {
    PaymentModel _paymentModel;
    return paymentsRef
        .where('partyId', isEqualTo: partyId)
        .where('status', isEqualTo: 'Approved')
        .orderBy('issueDate', descending: true)
        .snapshots()
        .map(
          (QuerySnapshot<Object?> querySnapshot) =>
              querySnapshot.docs.map((payment) {
            _paymentModel =
                PaymentModel.fromData(payment.data() as Map<String, dynamic>);
            _paymentModel.id = payment.id;
            return _paymentModel;
          }).toList(),
        );
  }

  Stream<List<PartiesModel>> searchParties({DocumentSnapshot<Object?>? doc}) {
    PartiesModel _partiesModel;
    return partiesRef.orderBy('name').snapshots().map(
          (QuerySnapshot<Object?> querySnapshot) => querySnapshot.docs.map(
            (party) {
              _partiesModel =
                  PartiesModel.fromData(party.data() as Map<String, dynamic>);
              _partiesModel.id = party.id;
              return _partiesModel;
            },
          ).toList(),
        );
  }

  Stream<List<PartiesModel>> searchPartiesSales(
      {required List<dynamic> products}) {
    PartiesModel _partiesModel;
    return partiesRef
        .where('product', whereIn: products)
        .orderBy('name')
        .snapshots()
        .map(
          (QuerySnapshot<Object?> querySnapshot) => querySnapshot.docs.map(
            (party) {
              _partiesModel =
                  PartiesModel.fromData(party.data() as Map<String, dynamic>);
              _partiesModel.id = party.id;
              return _partiesModel;
            },
          ).toList(),
        );
  }

  Future<bool> doesPartyAlreadyExist(
      {required String name, required String location}) async {
    final QuerySnapshot result = await partiesRef
        .where('name', isEqualTo: name)
        .where('location', isEqualTo: location)
        .limit(1)
        .get();
    final List<DocumentSnapshot> document = result.docs;
    return document.length == 1;
  }

  Future<bool> doesTokenAlreadyExist({required String token}) async {
    final QuerySnapshot result =
        await tokensRef.where('token', isEqualTo: token).limit(1).get();
    final List<DocumentSnapshot> document = result.docs;
    return document.length == 1;
  }

  Future<TokenModel> getTokenDetail({required String token}) async {
    final QuerySnapshot result =
        await tokensRef.where('token', isEqualTo: token).limit(1).get();
    TokenModel _tokenModel;
    _tokenModel =
        TokenModel.fromData(result.docs.first.data() as Map<String, dynamic>);
    _tokenModel.id = result.docs.first.id;
    return _tokenModel;
  }

  Stream<PaymentModel> getPaymentDetail({required String paymentId}) =>
      paymentsRef.doc(paymentId).snapshots().map((payment) {
        PaymentModel _paymentModel;
        _paymentModel =
            PaymentModel.fromData(payment.data() as Map<String, dynamic>);
        _paymentModel.id = payment.id;
        return _paymentModel;
      });

  Stream<OrdersModel> getOrderDetail({required String orderId}) =>
      ordersRef.doc(orderId).snapshots().map((order) {
        OrdersModel _orderModel;
        _orderModel =
            OrdersModel.fromData(order.data() as Map<String, dynamic>);
        _orderModel.id = order.id;
        return _orderModel;
      });

  Future<OrdersModel> getOrderDetailOnce({required String orderId}) async =>
      await ordersRef.doc(orderId).get().then((order) {
        OrdersModel _orderModel;
        _orderModel =
            OrdersModel.fromData(order.data() as Map<String, dynamic>);
        _orderModel.id = order.id;
        return _orderModel;
      });

  Future<PaymentModel> getPaymentDetailOnce({required String paymentId}) =>
      paymentsRef.doc(paymentId).get().then((payment) {
        PaymentModel _paymentModel;
        _paymentModel =
            PaymentModel.fromData(payment.data() as Map<String, dynamic>);
        _paymentModel.id = payment.id;
        return _paymentModel;
      });

  Stream<PartiesModel> getPartyDetail({required String partyId}) =>
      partiesRef.doc(partyId).snapshots().map((party) {
        PartiesModel _partiesModel;
        _partiesModel =
            PartiesModel.fromData(party.data() as Map<String, dynamic>);
        _partiesModel.id = party.id;
        return _partiesModel;
      });

  Stream<List<dynamic>> get getProducts =>
      productsRef.snapshots().map((value) => value.docs
          .map((products) => ProductListModel.fromData(
              products.data() as Map<String, dynamic>))
          .first
          .productList);

  Stream<List<OrdersModel>> getOrdersInTimeRange(
          {required DateTime startDate, required DateTime endDate}) =>
      ordersRef
          .where('issueDate', isGreaterThanOrEqualTo: startDate)
          .where('issueDate',
              isLessThanOrEqualTo:
                  DateTime(endDate.year, endDate.month, endDate.day + 1))
          .where('status', isEqualTo: 'Approved')
          .snapshots()
          .map((event) => event.docs
              .map((_orders) =>
                  OrdersModel.fromData(_orders.data() as Map<String, dynamic>))
              .toList());

  Stream<bool> get getUserApproved => usersRef
      .doc(getCurrentUserId())
      .snapshots()
      .map((DocumentSnapshot<Object?> document) => document['approved']);

  Future<String> getProductRefId() {
    return productsRef.get().then((event) => event.docs.first.id);
  }

  Future<void> updateUserOrders({
    required String uid,
    required int orders,
  }) async {
    usersRef.doc(uid).update({
      'orders': orders,
    }).onError((error, stackTrace) => print(
        ' Error from firebase Service in method updateUserOrders: $error'));
  }

  Future<void> updatePaymentDetails({
    required String chequeId,
    required String paymentNumber,
    required double amount,
    required DateTime issueDate,
    required String status,
    required DateTime statusDate,
    required bool isFreezed,
  }) async {
    paymentsRef.doc(chequeId).update({
      'paymentNumber': paymentNumber,
      'amount': amount,
      'issueDate': issueDate,
      'status': status,
      'statusDate': statusDate,
      'isFreezed': isFreezed,
    }).onError((error, stackTrace) => print(
        ' Error from firebase Service in method updatePaymentDetails: $error'));
  }

  Future<void> updateOrderDetails({
    required String orderId,
    required double numberOfUnits,
    required double perUnitAmount,
    required bool billed,
    required double tax,
    required double extraCharges,
    required String description,
    required DateTime issueDate,
    required String status,
    required DateTime statusDate,
  }) async {
    ordersRef.doc(orderId).update({
      'numberOfUnits': numberOfUnits,
      'perUnitAmount': perUnitAmount,
      'billed': billed,
      'tax': tax,
      'extraCharges': extraCharges,
      'description': description,
      'issueDate': issueDate,
      'status': status,
      'statusDate': statusDate,
    }).onError((error, stackTrace) => print(
        ' Error from firebase Service in method updateOrderDetails: $error'));
  }

  Future<void> updateProductList({required List<dynamic> product}) async {
    String id = await getProductRefId().onError((error, stackTrace) {
      return '';
    });
    id.length == 0
        ? productsRef.add({'productList': product})
        : await productsRef.doc(id).set({
            'productList': product
          }).onError((error, stackTrace) => print(
            'Error from firebase Service in method updateUserDetails: $error'));
  }

  Future<void> updateTokenProduct(
      {required List<dynamic> product, required String id}) async {
    tokensRef.doc(id).update({
      'products': product
    }).onError((error, stackTrace) => print(
        ' Error from firebase Service in method updateTokenProduct: $error'));
  }

  Future<void> updateUserDetails({
    required bool canAddParty,
    required List<dynamic> products,
    required String uid,
    required bool approved,
    required String role,
    required int orders,
  }) async {
    usersRef.doc(uid).update({
      'canAddParty': canAddParty,
      'products': products,
      'approved': approved,
      'role': role,
      'orders': orders,
    }).onError((error, stackTrace) => print(
        'Error from firebase Service in method updateUserDetails: $error'));
  }

  Future<void> updatePartyLimit(
      {required String partyId, required double limit}) async {
    partiesRef.doc(partyId).update({
      'limit': limit,
    }).onError((error, stackTrace) => print(
        ' Error from firebase Service in method updatePartyLimit: $error'));
  }

  Future<void> addToParty({required PartiesModel partiesModel}) {
    return partiesRef.add(partiesModel.toJson());
  }

  Future addToPayment({required PaymentModel paymentModel}) {
    return paymentsRef.add(paymentModel.toJson());
  }

  Future addToToken({required TokenModel tokenModel}) {
    return tokensRef.doc(tokenModel.token).set(tokenModel.toJson());
  }

  Future addToNotification({required NotificationModel notificationModel}) {
    return notificationsRef.add(notificationModel.toJson());
  }

  Future addToOrder({required OrdersModel orderModel}) {
    return ordersRef.add(orderModel.toJson());
  }

  Future<void> deleteFromToken({required String id}) async {
    tokensRef.doc(id).delete().onError((error, stackTrace) => print(
        ' Error from firebase Service in method deleteFromToken: $error'));
  }

  Future<void> deleteFromParty({required String id}) async {
    partiesRef.doc(id).delete().onError((error, stackTrace) => print(
        ' Error from firebase Service in method deleteFromParty: $error'));
  }

  Future<void> deleteFromPayment({required String id}) async {
    paymentsRef.doc(id).delete().onError((error, stackTrace) => print(
        ' Error from firebase Service in method deleteFromPayment: $error'));
  }

  Future<void> deleteFromOrder({required String id}) async {
    ordersRef.doc(id).delete().onError((error, stackTrace) => print(
        ' Error from firebase Service in method deleteFromOrder: $error'));
  }

  Future<String?> createAccount(
      {required UserModel userDetail, required String password}) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: userDetail.email,
        password: password,
      );
      User? _user = userCredential.user;
      userDetail.uid = _user!.uid;
      usersRef.doc(_user.uid).set(userDetail.toJson());
      return '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return ('The account already exists for that email.');
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signInAccount(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return '';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return (e.toString());
    }
  }

  Future<bool> emailExist(String email) async {
    bool isEmailExist = false;
    await usersRef.where('email', isEqualTo: email).get().then(
      (value) {
        if (value.docs.first.exists) {
          isEmailExist = true;
        }
      },
    ).onError(
      (error, stackTrace) {
        isEmailExist = false;
      },
    );
    return isEmailExist;
  }
}
