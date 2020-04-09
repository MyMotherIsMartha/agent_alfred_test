import 'package:agent37_flutter/views/login/login.dart';
import 'package:flutter/material.dart';
import './router_handler.dart';
import 'package:fluro/fluro.dart';

class Routes {
  static String root = '/';
  static String index = '/index';
  static String loginPage = '/login';
  static String registerPage = '/register';
  static String forgetPage = '/forget';
  static String updateUserPage = '/update-user';
  static String createAccountPage = '/create-account';
  static String addressPage = '/address';
  static String uploadEnterPrisePic = '/uploadEnterPrisePic';
  static String uploadLicenseForm = '/uploadLicenseForm';
  static String uploadLicenseAudit = '/uploadLicenseAudit';
  static String vipManage = '/vipManage';
  static String perfectEnterprise1 = '/perfectEnterprise1';
  static String perfectEnterprise2 = '/perfectEnterprise2';
  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print('ERROR====>ROUTE WAS NOT FONUND!!!');
      return LoginPage();
    });
    router.define(root, handler: splashHandler);
    router.define(index, handler: indexHandler);
    router.define(loginPage, handler: loginHandler);
    router.define(registerPage, handler: registerHandler);
    router.define(forgetPage, handler: forgetHandler);
    router.define(updateUserPage, handler: updateUserHandler);
    router.define(createAccountPage, handler: createAccountHandler);
    router.define(addressPage, handler: addressHandler);
    router.define(uploadEnterPrisePic, handler: uploadEnterPrisePicHandler);
    router.define(uploadLicenseForm, handler: uploadLicenseFormHandler);
    router.define(uploadLicenseAudit, handler: uploadLicenseAuditHandler);
    router.define(vipManage, handler: vipManageHandler);
    router.define(perfectEnterprise1, handler: perfectEnterprise1Handler);
    router.define(perfectEnterprise2, handler: perfectEnterprise2Handler);
  }
}
