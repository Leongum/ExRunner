//
//  Plan_Run_History.h
//  Cyberace
//
//  Created by leon on 13-11-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User_Running_History.h"

@interface Plan_Run_History : NSManagedObject

@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * historyStatus;
@property (nonatomic, retain) NSDate * lastUpdateTime;
@property (nonatomic, retain) NSNumber * nextMissionId;
@property (nonatomic, retain) NSNumber * planId;
@property (nonatomic, retain) NSString * planName;
@property (nonatomic, retain) NSString * planRunUuid;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSString * rateComment;
@property (nonatomic, retain) NSNumber * remainingMissions;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * totalMissions;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSNumber * operate;

@property (nonatomic, retain) NSMutableArray * runHistoryList;

+(Plan_Run_History *) intiUnassociateEntity;

+(Plan_Run_History *) removeAssociateForEntity:(Plan_Run_History *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;

-(NSMutableDictionary *)transToDictionary;

@end
