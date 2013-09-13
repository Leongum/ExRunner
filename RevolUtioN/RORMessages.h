//
//  RORMessages.h
//  RevolUtioN
//
//  Created by leon on 13-9-11.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef messages

#define CONNECTION_ERROR @"网络连接错误"
#define LOGIN_ERROR @"填错了吧？检查检查？"
#define REGISTER_SUCCESS @"恭喜我，又多了一个注册用户！请继续完善个人信息！"
#define REGISTER_FAIL @"这名字太土，已经被别人取了！"
#define LOGIN_INPUT_CHECK @"填填好再提交嘛！"
#define REGISTER_INPUT_CHECK @"填填好再提交嘛！"
#define CONNECTION_ERROR_CONTECT @"定位精度将受到严重影响，本次跑步将不能获得相应奖励，请检查相关系统设置。\n\n（小声的：启动数据网络可以大大提高定位精度与速度，同时只会产生极小的流量。）"
#define CANCEL_BUTTON @"知道呢！"
#define START_RUNNING_BUTTON @"走你"
#define CANCEL_RUNNING_BUTTON @"取消"
#define FINISH_RUNNING_BUTTON @"完成"
#define PAUSSE_RUNNING_BUTTON @"歇会儿"
#define CONTINUE_RUNNING_BUTTON @"再走你"
#define SYNC_DATA_SUCCESS @"数据同步成功！"
#define SYNC_DATA_FAIL @"哎呀～上传失败了!快看看上传设置和网络连接！"
#define SYNC_MODE_ALL @"即时同步"
#define SYNC_MODE_WIFI @"仅wifi同步"
#define LOGOUT_ALERT_TITLE @"注销"
#define LOGOUT_ALERT_CONTENT @"确定要注销吗？"
#define CANCEL_BUTTON_CANCEL @"取消"
#define OK_BUTTON_OK @"确定"
#define SHARE_TO_PLATFORM_LIST @"分享到:"
#define ALERT_VIEW_TITEL @"提示"
#define SNS_BIND_ERROR @"绑定失败!"
#define SELECT_SHARE_PLATFORM_ERROR @"请选择要晒跑的平台!"
#define SHARE_DEFAULT_CONTENT @"这里就是传说中的固定内容"
#define SHARE_DEFAULT_TITLE @"晒跑乐"
#define SHARE_DEFAULT_URL @"http://www.cyberace.cc"
#define SHARE_DEFAULT_DESCRIPTION @"来自Cyberace赛跑乐"
#define SHARE_SUBMITTED @"晒跑成功"
#define NO_HISTORY @"你还没跑过耶哪来得记录"

#endif

@interface RORMessages : NSObject

@end
