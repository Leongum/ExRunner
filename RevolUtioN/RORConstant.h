//
//  RORConstant.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef URLS
//define test service host
//#define SERVICE_HOST @"http://121.199.56.231:8080/usavich/service/api"

//define v1.2 host
#define SERVICE_HOST @"http://121.199.56.231:8080/usavichV2/service/api"

//define prod service host
//#define SERVICE_HOST @"http://www.cyberace.cc/service/api"

#define CURRENT_VERSION_MAIN 2
#define CURRENT_VERSION_SUB 0

#define LOGIN_URL [SERVICE_HOST stringByAppendingString:@"/account/%@/%@"]
#define REGISTER_URL [SERVICE_HOST stringByAppendingString:@"/account"]
#define USER_ADDITIONAL_UPDATE [SERVICE_HOST stringByAppendingString:@"/account/additional/%@"]
#define USER_LOCATION [SERVICE_HOST stringByAppendingString:@"/account/location/%@"]
#define USER_INFO [SERVICE_HOST stringByAppendingString:@"/account/%@?checkUuid=%@"]
#define POST_RUNNING_HISTORY_URL [SERVICE_HOST stringByAppendingString:@"/running/history/%@"]
#define RUNNING_HISTORY_URL [SERVICE_HOST stringByAppendingString:@"/running/history/%@?lastUpdateTime=%@"]
#define POST_USER_RUNNING_URL [SERVICE_HOST stringByAppendingString:@"/running/ongoing/%@"]
#define USER_RUNNING_URL [SERVICE_HOST stringByAppendingString:@"/running/ongoing/%@?lastUpdateTime=%@"]
#define FRIEND_URL [SERVICE_HOST stringByAppendingString:@"/account/friends/%@?lastUpdateTime=%@"]
#define MISSION_URL [SERVICE_HOST stringByAppendingString:@"/missions/mission?lastUpdateTime=%@"]
#define VERSION_URL [SERVICE_HOST stringByAppendingString:@"/system/version/%@"]
#define SYSTEM_MESSAGE_URL [SERVICE_HOST stringByAppendingString:@"/system/message/%@"]
#define FEEDBACK_URL [SERVICE_HOST stringByAppendingString:@"/system/feedback"]
#define DOWNLOADED_URL [SERVICE_HOST stringByAppendingString:@"/system/download"]
#define PM25_URL [SERVICE_HOST stringByAppendingString:@"/weather/pm25?cityName=%@&provinceName=%@"]

//define version 1.2 plan new api
#define USER_FOLLOWERS_DETAIL_URL [SERVICE_HOST stringByAppendingString:@"/account/follower/%@?pageNo=%@"]
#define PLAN_INFO_URL [SERVICE_HOST stringByAppendingString:@"/plans/plan/%@?lastUpdateTime=%@"]
#define HOT_PLAN_URL [SERVICE_HOST stringByAppendingString:@"/plans/list?pageNo=%@"]
#define POST_PLAN_URL [SERVICE_HOST stringByAppendingString:@"/plans/plan/post/%@"]
#define USER_LAST_UPDATE_PLAN_URL [SERVICE_HOST stringByAppendingString:@"/plans/history/lastupdate/%@"]
#define USER_COLLECT_PLAN_URL [SERVICE_HOST stringByAppendingString:@"/plans/collect/%@?lastUpdateTime=%@"]
#define PUT_USER_COLLECT_PLAN_URL [SERVICE_HOST stringByAppendingString:@"/plans/collect/put/%@"]
#define USER_PLAN_HISTORY_URL [SERVICE_HOST stringByAppendingString:@"/plans/history/%@?lastUpdateTime=%@"]
#define PUT_USER_PLAN_HISTORY_URL [SERVICE_HOST stringByAppendingString:@"/plans/history/put/%@"]
#define PLAN_HISTORY_BY_PLANID_URL [SERVICE_HOST stringByAppendingString:@"/plans/history/running/plan/%@?pageNo=%@"]
#define PLAN_HISTORY_BY_USERID_URL [SERVICE_HOST stringByAppendingString:@"/plans/history/running/user/%@?pageNo=%@"]
#define USER_FOLLOWER_LIST_URL [SERVICE_HOST stringByAppendingString:@"/plans/follow/%@?lastUpdateTime=%@"]
#define PUT_USER_FOLLOWER_LIST_URL [SERVICE_HOST stringByAppendingString:@"/plans/follow/put/%@"]

#define WEATHER_URL @"http://www.weather.com.cn/data/sk/%@.html"


#define DEFAULT_NET_WORK_MODE @"All_Mode"
#define NET_WORK_MODE_WIFI @"Only_Wifi"
#define DEFAULT_SEX @"男"
#define DEFAULT_WEIGHT [NSNumber numberWithDouble:60]
#define DEFAULT_HEIGHT [NSNumber numberWithDouble:175]
#define DEFAULT_SPEEDTYPE 0
#define DEFAULT_ANIMATION [NSNumber numberWithBool:YES]

//#define CHN_PRINT_FONT @"FZKaTong-M19S"
//#define CHN_WRITTEN_FONT @"FZKaTong-M19S"
//#define ENG_WRITTEN_FONT @"ComicSansMS"
#define CHN_PRINT_FONT @""
#define CHN_WRITTEN_FONT @""
#define ENG_WRITTEN_FONT @""
//#define ENG_PRINT_FONT @"Electronic Highway Sign"
#define ENG_PRINT_FONT @""
#define ENG_GAME_FONT @"EnterSansmanBoldItalic"

#define PLAN_PAGE_SIZE 10
#define FRIENDS_PAGE_SIZE 10

#define COLOR_MOSS [UIColor colorWithRed:0 green:128.f/255.f blue:64.f/255.f alpha:1]
#endif

typedef enum {Challenge = 0, Recommand = 1, Cycle = 2, SubCycle = 3, NormalRun = 4, SimpleTask = 5, ComplexTask = 6} MissionTypeEnum;
typedef enum {GRADE_S = 0, GRADE_A = 1, GRADE_B = 2, GRADE_C = 3, GRADE_D = 4, GRADE_E = 5, GRADE_F = 6} MissionGradeEnum;
typedef enum {PlanTypeEasy = 0, PlanTypeComplex = 1} PlanTypeEnum;
typedef enum {SharedPlanSystem = 0, SharedPlanShared = 1} SharedPlanEnum;
typedef enum {DurationTypeWeek = 0, DurationTypeDay = 1} DurationTypeEnum;
typedef enum {PlanStatusEnabled = 0, PlanStatusDisabled = 1} PlanStatusEnum;
typedef enum {TrainingContentTypeDistance = 0, TrainingContentTypeDuration = 1} TrainingContentTypeEnum;
typedef enum {CollectStatusCollected = 0, CollectStatusNotCollected = 1} CollectStatusEnum;
typedef enum {HistoryStatusExecute = 0, HistoryStatusFinished = 1, HistoryStatusCancled = 2} HistoryStatusEnum;
typedef enum {FollowStatusFollowed = 0, FollowStatusNotFollowed = 1} FollowStatusEnum;
typedef enum {OperateUpdate = 0, OperateInsert = 1, OperateDelete = 2} OperateEnum;
typedef enum {PlanFlagNew = 0, PlanFlagHot = 1, PlanFlagRecommend = 2} PlanFlagEnun;

typedef struct {
    int mainVersion;
    int subVersion;
} Version;

NSString *const MissionTypeEnum_toString[7];
NSString *const MissionGradeEnum_toString[7];
NSString *const MissionGradeCongratsImageEnum_toString[7];
NSString *const MissionGradeImageEnum_toString[7];
NSString *const CounterNumberImageInteger_toString[6];

@interface RORConstant : NSObject

+(NSString *)SoundNameForSpecificGrade:(MissionGradeEnum)grade;

@end
