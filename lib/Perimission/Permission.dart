import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

class Permission{

  Permission();

  Future<bool> getPermission(BuildContext context)async {
    bool isOK = await Permission().requestPermission(context);
    if(isOK){

    }else{
      //exit(0);
    }
    return isOK;
  }



  Future requestPermission(BuildContext context) async {
    // 申请权限
    List<PermissionGroup> requestPermissions = [
      PermissionGroup.storage,
    ];
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions(requestPermissions);

    // 申请结果  权限检测
    PermissionStatus permission =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    bool isOk=false;
    if (permission == PermissionStatus.granted) {
      // 参数1：提示消息
      // 参数2：提示消息多久后自动隐藏
      // 参数3：位置
      isOk = true;
//      Toast.show(tr('permiss_success'), context,
//          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } else {
      isOk=false;

    }
    return isOk;
  }

  Future openSetting(BuildContext context) async{
    bool isOpened = await PermissionHandler().openAppSettings();
    if(isOpened){
      Toast.show("打开了设置页！", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }else{
      Toast.show("没打开！", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }

}