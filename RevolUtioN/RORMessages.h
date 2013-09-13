//
//  RORMessages.h
//  RevolUtioN
//
//  Created by leon on 13-9-11.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef messages

#define CONNECTION_ERROR @"设备尚未连接网络！"
#define LOGIN_ERROR @"登录失败,用户名或密码错误！"
#define REGISTER_SUCCESS @"恭喜你，注册成功！请继续完善个人信息！"
#define REGISTER_FAIL @"注册失败，注用户名已存在！"
#define LOGIN_INPUT_CHECK @"用户名或密码不能为空！"
#define REGISTER_INPUT_CHECK @"用户名,密码或昵称不能为空！"
#define CONNECTION_ERROR_CONTECT @"定位精度将受到严重影响，本次跑步将不能获得相应奖励，请检查相关系统设置。\n\n（小声的：启动数据网络可以大大提高定位精度与速度，同时只会产生极小的流量。）"
#define CANCEL_BUTTON @"知道呢！"
#define START_RUNNING_BUTTON @"走你"
#define CANCEL_RUNNING_BUTTON @"取消"
#define FINISH_RUNNING_BUTTON @"完成"
#define PAUSSE_RUNNING_BUTTON @"歇会儿"
#define CONTINUE_RUNNING_BUTTON @"再走你"
#define SYNC_DATA_SUCCESS @"数据同步成功！"
#define SYNC_DATA_FAIL @"哎呀～上传失败了!请查看上传设置以及网络连接！"
#define SYNC_MODE_ALL @"即时同步"
#define SYNC_MODE_WIFI @"仅wifi同步"
#define LOGOUT_ALERT_TITLE @"注销"
#define LOGOUT_ALERT_CONTENT @"确定要注销吗？"
#define CANCEL_BUTTON_CANCEL @"取消"
#define OK_BUTTON_OK @"确定"
#define SHARE_TO_PLATFORM_LIST @"分享到:"
#define ALERT_VIEW_TITEL @"提示"
#define SNS_BIND_ERROR @"绑定失败!"
#define SELECT_SHARE_PLATFORM_ERROR @"请选择要发布的平台!"
#define SHARE_DEFAULT_CONTENT @"这里就是传说中的固定内容"
#define SHARE_DEFAULT_TITLE @"赛跑乐快乐分享"
#define SHARE_DEFAULT_URL @"http://www.cyberace.cc"
#define SHARE_DEFAULT_DESCRIPTION @"来自赛跑乐的晒跑了"
#define SHARE_SUBMITTED @"分享已提交"
#define GPS_SETTING_ERROR @"定位失败，请打开GPS定位功能"

#endif

@interface RORMessages : NSObject

@end
