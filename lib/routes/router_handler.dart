import 'package:agent37_flutter/views/index.dart';
import 'package:agent37_flutter/views/login/address.dart';
import 'package:agent37_flutter/views/login/create-account.dart';
import 'package:agent37_flutter/views/login/forget.dart';
import 'package:agent37_flutter/views/login/login.dart';
import 'package:agent37_flutter/views/login/register.dart';
import 'package:agent37_flutter/views/login/update-user.dart';
import 'package:agent37_flutter/views/splash_page.dart';
import 'package:agent37_flutter/views/enterpriseApprove/uploadPic.dart';
import 'package:agent37_flutter/views/enterpriseApprove/uploadForm.dart';
import 'package:agent37_flutter/views/enterpriseApprove/uploadAudit.dart';
import 'package:agent37_flutter/views/vipManage/index.dart';
import 'package:agent37_flutter/views/enterpriseApprove/perfectInfo1.dart';
import 'package:agent37_flutter/views/enterpriseApprove/perfectInfo2.dart';
import 'package:fluro/fluro.dart';
import 'package:agent37_flutter/utils/fluro_convert_util.dart';
import 'package:flutter/material.dart';

// splash 页面
var splashHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      return SplashPage();
    });

Handler indexHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return IndexPage();
  }
);



Handler loginHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return LoginPage();
  }
);

Handler registerHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return RegisterPage();
  }
);

Handler forgetHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return ForgetPage();
  }
);

Handler updateUserHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return UpdateUserPage();
  }
);

Handler createAccountHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return CreateAccountPage();
  }
);

Handler addressHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return AddressPage();
  }
);
Handler uploadEnterPrisePicHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return UploadEnterprisePic();
  }
);

Handler uploadLicenseFormHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    String uploadJson = params['uploadJson']?.first;
    
    return UploadLicenseForm(
      uploadJson: uploadJson,
    );
  }
);

Handler perfectEnterprise1Handler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return PerfectEnterprise1();
  }
);

Handler perfectEnterprise2Handler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
    String legalName = params['legalName']?.first;
    
    return PerfectEnterprise2(
      legalName: legalName,
    );
  }
);

Handler uploadLicenseAuditHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return UploadLicenseAudit();
  }
);

Handler vipManageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return VipManageMain();
  }
);