//
//  RORConstant.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef URLS
#define SERVICE_URL @"http://121.199.56.231:8080/usavich/service/api"
#define LOGIN_URL @"http://121.199.56.231:8080/usavich/service/api/account/%@/%@"
#define REGISTER_URL @"http://121.199.56.231:8080/usavich/service/api/account"
#define USER_INFO @"http://121.199.56.231:8080/usavich/service/api/account/%@?checkUuid=true"
#define POST_RUNNING_HISTORY_URL @"http://121.199.56.231:8080/usavich/service/api/running/history/%@"
#define RUNNING_HISTORY_URL @"http://121.199.56.231:8080/usavich/service/api/running/history/%@?lastUpdateTime=%@"
#define POST_USER_RUNNING_URL @"http://121.199.56.231:8080/usavich/service/api/running/ongoing/%@"
#define USER_RUNNING_URL @"http://121.199.56.231:8080/usavich/service/api/running/ongoing/%@?lastUpdateTime=%@"
#define FRIEND_URL @"http://121.199.56.231:8080/usavich/service/api/account/friends/%@?lastUpdateTime=%@"
#define MISSION_URL @"http://121.199.56.231:8080/usavich/service/api/missions/mission?lastUpdateTime=%@"
#define VERSION_URL @"http://121.199.56.231:8080/usavich/service/api/version/%@"

#define WEATHER_URL @"http://m.weather.com.cn/data/%@.html"
#define PM25_URL @"http://www.pm25.in/api/querys/pm2_5.json?city=%@&token=%@&stations=no"
#endif

typedef enum {Challenge = 0, Recommand = 1, Cycle = 2, SubCycle = 3, NormalRun = 4} MissionTypeEnum;

NSString *const MissionTypeEnum_toString[5];

@interface RORConstant : NSObject

@end
