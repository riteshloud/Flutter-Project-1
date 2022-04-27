// ignore_for_file: unused_field, prefer_final_fields, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';
import '../../helpers/api_constant.dart';
import '../../models/subscription.dart';
import '../../models/auth/login_reposnse_model.dart';
import '../../models/common/user.dart';

import '../../service/api_service.dart';

import '../../widgets/common/common_button.dart';
import '../../widgets/common/safearea_widget.dart';

class SubscriptionListScreen extends StatefulWidget {
  const SubscriptionListScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionListScreenState createState() => _SubscriptionListScreenState();
}

class _SubscriptionListScreenState extends State<SubscriptionListScreen> {
  late Map<String, String> body;

  List<Subscription> arrProducts = [];

  late StreamSubscription _purchaseUpdatedSubscription;
  late StreamSubscription _purchaseErrorSubscription;
  late StreamSubscription _conectionSubscription;
  final List<String> _productLists = [SubscriptionPackage.monthlyPackage];

  List<IAPItem> _arrProductsInIAP = [];
  List<PurchasedItem> _purchases = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() async {
    super.dispose();
    await FlutterInappPurchase.instance.finalize();
    if (_conectionSubscription != null) {
      _conectionSubscription.cancel();
      // _conectionSubscription = null;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // prepare
    await FlutterInappPurchase.instance.initialize();
    await _getProduct();

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      if (kDebugMode) {
        print('consumeAllItems: $msg');
      }
    } catch (err) {
      if (kDebugMode) {
        print('consumeAllItems error: $err');
      }
    }

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      if (kDebugMode) {
        print('connected: $connected');
      }
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      Singleton.instance.hideProgress();

      if (Platform.isIOS) {
        if (productItem?.transactionStateIOS == TransactionState.failed) {
          if (kDebugMode) {
            print("TRANSACTION FAILED");
          }
        } else if (productItem?.transactionStateIOS ==
            TransactionState.purchasing) {
          if (kDebugMode) {
            print("TRANSACTION IN PROGRESS");
          }
        } else if (productItem?.transactionStateIOS ==
            TransactionState.purchased) {
          if (kDebugMode) {
            print("RECEIPT DATA ==> ${productItem?.transactionReceipt}");
          }

          if (productItem != null) {
            createPurchaseapiCall(
                productItem.transactionReceipt ?? "",
                SubscriptionPackage.monthlyPackage,
                "",
                context,
                "subscribe",
                productItem.transactionId ?? "");
          }
        } else if (productItem?.transactionStateIOS ==
            TransactionState.restored) {
          createPurchaseapiCall(
              productItem?.transactionReceipt ?? "",
              SubscriptionPackage.monthlyPackage,
              "",
              context,
              "restore",
              productItem?.transactionId ?? "");
        }
      } else if (Platform.isAndroid) {
        if (productItem?.purchaseStateAndroid == PurchaseState.pending) {
          if (kDebugMode) {
            print("TRANSACTION PENDING");
          }
        } else if (productItem?.purchaseStateAndroid ==
            PurchaseState.purchased) {
          if (kDebugMode) {
            print("PURCHASED TOKEN ==> ${productItem?.purchaseToken}");
          }

          await FlutterInappPurchase.instance.finishTransaction(productItem!);

          createPurchaseapiCall("", SubscriptionPackage.monthlyPackage,
              productItem.purchaseToken ?? "", context, "subscribe", "");
        }
      }

      if (kDebugMode) {
        print('purchase-updated: $productItem');
      }
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      Singleton.instance.hideProgress();
      if (purchaseError != null) {
        Singleton.instance.showAlertDialogWithOkAction(
            context, Constant.appName, purchaseError.message ?? "");
      }
    });
  }

  void _requestPurchase(IAPItem item) {
    FlutterInappPurchase.instance.requestPurchase(item.productId ?? "");
  }

  Future _getProduct() async {
    Singleton.instance.showDefaultProgress();

    List<IAPItem> items =
        await FlutterInappPurchase.instance.getSubscriptions(_productLists);

    _arrProductsInIAP = items;

    for (var i = 0; i < items.length; i++) {
      var objProduct = items[i];

      if (kDebugMode) {
        print("ID ==> ${objProduct.productId}");
        print("TITLE ==> ${objProduct.title}");
        print("PRICE ==> ${objProduct.price}");
        print("ROW PRICE ==> ${objProduct.localizedPrice}");
        print("CURRENCY CODE ==> ${objProduct.currency}");
        // print("CURRENCY SYMBOL ==> ${objProduct.currencySymbol}");
        print("DESCRIPTION ==> ${objProduct.description}");
      }

      String planName = "";
      if (i == 0) {
        planName = "A";
      } else if (i == 1) {
        planName = "B";
      } else if (i == 2) {
        planName = "C";
      } else if (i == 3) {
        planName = "D";
      } else if (i == 4) {
        planName = "E";
      }

      arrProducts.add(
        Subscription(
            objProduct.productId ?? "",
            objProduct.title ?? "",
            objProduct.description ?? "",
            objProduct.price ?? "",
            objProduct.localizedPrice ?? "",
            objProduct.currency ?? "",
            // objProduct.currencySymbol,
            false,
            "Subscription name $planName"),
      );

      Subscription? objActiveSubscription;
      if (Singleton.instance.objLoginUser.planType.isNotEmpty) {
        objActiveSubscription = arrProducts.firstWhere((element) =>
            element.id == Singleton.instance.objLoginUser.planType);
      }

      if (objActiveSubscription != null) {
        arrProducts.forEach((element) => element.id == objActiveSubscription!.id
            ? element.isSelected = true
            : element.isSelected = false);
      }

      setState(() {});
      Singleton.instance.hideProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: ColoredSafeArea(
          color: Colors.white,
          child: Scaffold(
            appBar: Singleton.instance.CommonAppbar(
              appbarText: "",
              leadingClickEvent: () {
                Navigator.pop(context, false);
              },
              backgroundColor: Colors.white,
              iconColor: Colors.black,
              endTextColor: Colors.black,
              endText: "",
              endTextClickEvent: null,
              // endText: Strings.confirm.toUpperCase(),
              // endTextClickEvent: () {
              //   Navigator.pop(context, false);
              // },
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  heading(context),
                  subscriptionDetail(context),
                  subscribeButton(context),
                  restoreButton(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            if (canLaunch(Constant.termsURL) != null) {
                              launch(Constant.termsURL);
                            }
                          },
                          child: Text(
                            "Terms & Conditions".toUpperCase(),
                            textAlign: TextAlign.left,
                            style: Singleton.instance
                                .setTextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            if (canLaunch(Constant.privacyURL) != null) {
                              launch(Constant.privacyURL);
                            }
                          },
                          child: Text(
                            "Privacy Policy".toUpperCase(),
                            textAlign: TextAlign.right,
                            style: Singleton.instance
                                .setTextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget heading(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.symmetric(vertical: 30),
            child: Text(
              Strings.subscriptionLevel.toUpperCase(),
              style: Singleton.instance.setTextStyle(
                fontFamily: Constant.robotoCondensedFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: TextSize.text_24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  subscriptionDetail(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var objSubscription = arrProducts[index];

        return GestureDetector(
          onTap: () {
            for (var element in arrProducts) {
              element.isSelected = false;
            }
            objSubscription.isSelected = !objSubscription.isSelected;
            if (mounted) {
              setState(() {});
            }
          },
          child: Container(
            color: objSubscription.isSelected
                ? ColorCodes.yellow
                : ColorCodes.unselectedColor,
            margin: const EdgeInsets.only(top: 7),
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Image.asset(
                  objSubscription.isSelected ? "" : "",
                  width: 20,
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        objSubscription.subscriptionName,
                        textAlign: TextAlign.start,
                        style: Singleton.instance.setTextStyle(
                          fontFamily: Constant.robotoCondensedFontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: TextSize.text_18,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          objSubscription.rawPrice +
                              " " +
                              objSubscription.currencyCode,
                          textAlign: TextAlign.start,
                          style: Singleton.instance.setTextStyle(
                            fontFamily: Constant.robotoFontFamily,
                            fontWeight: FontWeight.bold,
                            fontSize: TextSize.text_14,
                          ),
                        ),
                      ),
                      Text(
                        objSubscription.description,
                        textAlign: TextAlign.start,
                        style: Singleton.instance.setTextStyle(
                          fontFamily: Constant.robotoFontFamily,
                          fontSize: TextSize.text_13,
                          textColor: ColorCodes.textColorGray,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: arrProducts.length,
    );
  }

  Widget subscribeButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20),
      child: CommonButton(
        onPressed: () {
          var count = arrProducts
              .where((element) => element.isSelected == true)
              .toList()
              .length;

          if (count <= 0) {
            Singleton.instance.showAlertDialogWithOkAction(
                context, Constant.appName, "Please select subscription level.");
          } else {
            Subscription? objActiveSubscription;
            if (Singleton.instance.objLoginUser.planType.isNotEmpty) {
              objActiveSubscription = arrProducts.firstWhere((element) =>
                  element.id == Singleton.instance.objLoginUser.planType);
            }

            var objSelectedSubscription =
                arrProducts.firstWhere((element) => element.isSelected == true);

            if (objActiveSubscription == null) {
              Singleton.instance.showDefaultProgress();
              if (_arrProductsInIAP.isNotEmpty) {
                _requestPurchase(_arrProductsInIAP[0]);
              }

              // _buyProduct(objSelectedSubscription);
            } else if (objActiveSubscription.id == objSelectedSubscription.id) {
              Singleton.instance.showAlertDialogWithOkAction(context,
                  Constant.appName, "You already subscribed to this package.");
            }
          }
        },
        title: Strings.confirmSubscribe.toUpperCase(),
        textColor: Colors.white,
      ),
    );
  }

  Widget restoreButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: CommonButton(
        onPressed: () async {
          Singleton.instance.showDefaultProgress();

          List<PurchasedItem>? items =
              await FlutterInappPurchase.instance.getAvailablePurchases();

          if (items != null && items.isNotEmpty) {
            items.sort(
                (a, b) => a.transactionDate!.compareTo(b.transactionDate!));

            DateTime currentDate = DateTime.now();

            DateTime transactionEndDate =
                items.last.transactionDate!.add(const Duration(minutes: 5));

            bool isSubscriptionActive =
                currentDate.isBefore(transactionEndDate);
            if (kDebugMode) {
              print(isSubscriptionActive);
            }

            if (Platform.isIOS) {
              createPurchaseapiCall(
                  items.last.transactionReceipt ?? "",
                  SubscriptionPackage.monthlyPackage,
                  "",
                  context,
                  "restore",
                  "");
              // }
            } else {
              createPurchaseapiCall("", SubscriptionPackage.monthlyPackage,
                  items.last.purchaseToken ?? "", context, "restore", "");
            }
          } else {
            Singleton.instance.hideProgress();
            Singleton.instance.showAlertDialogWithOkAction(
                context,
                Constant.appName,
                "You don't have any active subscription to restore");
          }
        },
        title: "Restore".toUpperCase(),
        textColor: Colors.white,
      ),
    );
  }

  Future<void> createPurchaseapiCall(
      localReceipt,
      String packageName,
      String purchaseToken,
      BuildContext context,
      String subscribeOrRestore,
      String iOSTransactionID) async {
    late Map<String, String> body;
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    if (Platform.isIOS) {
      body = {
        ApiParamters.device_type_auth: ApiParamters.ios,
        ApiParamters.package_name: packageName,
        ApiParamters.receipt_data: localReceipt,
        ApiParamters.request_type: subscribeOrRestore,
      };
    } else {
      body = {
        ApiParamters.device_type_auth: ApiParamters.android,
        ApiParamters.package_name: packageName,
        ApiParamters.purchase_token: purchaseToken,
        ApiParamters.request_type: subscribeOrRestore,
      };
    }

    if (kDebugMode) {
      print("SUBSCRIPTION PARAM = $body");
    }

    Singleton.instance.showDefaultProgress();
    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.createSubscription);
    if (kDebugMode) {
      print("url$url");
    }

    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          if (kDebugMode) {
            print(responseData);
            print("statuscode ${response.statusCode}");
          }

          if (response.statusCode == 200) {
            if (subscribeOrRestore == "subscribe") {
              if (Platform.isIOS) {
                await FlutterInappPurchase.instance
                    .finishTransactionIOS(iOSTransactionID);
              }
            }

            arrProducts[0].isSelected = true;
            setState(() {});
            callGetUserProfileAPI(context, responseData["message"]);
          } else if (response.statusCode == 500) {
            Singleton.instance.hideProgress();
            Singleton.instance.showAInvalidTokenAlert(
                context, Constant.alert, responseData["message"]);
          } else if (response.statusCode == 501) {
            Singleton.instance.hideProgress();
            Singleton.instance.showAInvalidTokenAlertForLogout(
                context, Constant.alert, responseData["message"]);
          } else {
            Singleton.instance.hideProgress();
            Singleton.instance.showAlertDialogWithOkAction(
                context, Constant.alert, responseData["message"]);
          }
        } on SocketException {
          Singleton.instance.hideProgress();
          response.success = false;
          response.message = "Please check internet connection";
        } catch (e) {
          Singleton.instance.hideProgress();
        }
      } else {
        //Singleton.instance.hideProgress();
        if (kDebugMode) {
          if (kDebugMode) {
            print("EMPTY RESPONSE");
          }
        }
      }
    });
  }

  Future<void> callGetUserProfileAPI(
      BuildContext context, String message) async {
    LoginReposnseModel loginResponseModel;
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    Map<String, String> body;
    body = {
      ApiParamters.device_type_auth: Singleton.instance.deviceType(),
      ApiParamters.user_secret: Singleton.instance.objLoginUser.id.toString()
    };

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.get_user_profile);

    Singleton.instance.showDefaultProgress();
    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          if (response.statusCode == 200) {
            loginResponseModel =
                LoginReposnseModel.fromJson(json.decode(response.body));
            var userData = loginResponseModel.payload;

            String userCommonData = jsonEncode(
                UserModel.fromJson(json.decode(response.body)['payload']));

            if (userData != null) {
              UserModel userModel =
                  UserModel.fromJson(json.decode(response.body)['payload']);
              Singleton.instance.objLoginUser = userModel;
              Singleton.instance.setUserModel(userCommonData);

              Singleton.instance.AuthToken =
                  Singleton.instance.objLoginUser.token;
              Singleton.instance.userProfile =
                  loginResponseModel.payload.profileImage;

              Singleton.instance.hideProgress();
              Singleton.instance.showAlertDialogWithSingleCallbackOption(
                  context,
                  Constant.appName,
                  message,
                  "OK",
                  positiveButtonClicked);
            }
          } else if (response.statusCode == 500) {
            Singleton.instance.hideProgress();
            Singleton.instance.showAInvalidTokenAlert(
                context, Constant.alert, responseData["message"]);
          } else if (response.statusCode == 501) {
            Singleton.instance.hideProgress();
            Singleton.instance.showAInvalidTokenAlertForLogout(
                context, Constant.alert, responseData["message"]);
          } else {
            Singleton.instance.hideProgress();
            Singleton.instance.showAlertDialogWithOkAction(
                context, Constant.alert, responseData["message"]);
          }
        } on SocketException {
          Singleton.instance.hideProgress();
          response.success = false;
          response.message = "Please check internet connection";
        } catch (e) {
          Singleton.instance.hideProgress();
        }
      } else {
        //Singleton.instance.hideProgress();
        if (kDebugMode) {
          if (kDebugMode) {
            print("EMPTY RESPONSE");
          }
        }
      }
    });
  }

  void positiveButtonClicked() {
    //To Dismiss the Alert Dialog
    Navigator.of(context).pop();

    //Call back to refresh the previous screen
    Navigator.pop(context, true);
  }
  /*
  Future<void> checkSubscription(String purchaseToken, String receiptData,
      bool isWantToPurchase, String transactionID) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    // Singleton.instance.showDefaultProgress();
    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.checkSubscription);
    print("url$url");

    ApiService.postCallwithHeaderWithoutParam(url, header, context)
        .then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body)["payload"];

        try {
          print(responseData);
          print("statuscode ${response.statusCode}");
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            print("CHECK SUBSCRIPTION");

            var isSubscribed = responseData["subscription"];

            if (isSubscribed) {
              if (isWantToPurchase) {
                if (Platform.isIOS) {
                  createPurchaseapiCall(
                      receiptData,
                      SubscriptionPackage.monthlyPackage,
                      "",
                      context,
                      "subscribe",
                      transactionID);
                } else {
                  print("ANDROID PURCHASE");
                }
              } else {
                if (Platform.isIOS) {
                  createPurchaseapiCall(
                      receiptData,
                      SubscriptionPackage.monthlyPackage,
                      "",
                      context,
                      "restore",
                      "");
                } else {
                  createPurchaseapiCall("", SubscriptionPackage.monthlyPackage,
                      purchaseToken, context, "restore", "");
                }
              }
            } else {
              Singleton.instance.showAlertDialogWithOkAction(
                  context,
                  Constant.appName,
                  "You don't have any active subscription to restore.");
            }
          } else if (response.statusCode == 500) {
            Singleton.instance.showAInvalidTokenAlert(
                context, Constant.alert, responseData["message"]);
          } else if (response.statusCode == 501) {
            Singleton.instance.showAInvalidTokenAlertForLogout(
                context, Constant.alert, responseData["message"]);
            print(response.body);
          } else {
            Singleton.instance.showAlertDialogWithOkAction(
                context, Constant.alert, responseData["message"]);
          }
        } on SocketException catch (e) {
          Singleton.instance.hideProgress();
          print(e.message);
          response.success = false;
          response.message = "Please check internet connection";
        } catch (e) {
          Singleton.instance.hideProgress();
           
        }
      } else {
        //Singleton.instance.hideProgress();
          
      }
    });
  }
  */
}
