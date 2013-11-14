//
//  Plan.h
//  Cyberace
//
//  Created by leon on 13-11-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Plan : NSManagedObject

@property (nonatomic, retain) NSNumber * cycleTime;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * durationLast;
@property (nonatomic, retain) NSNumber * durationType;
@property (nonatomic, retain) NSDate * lastUpdateTime;
@property (nonatomic, retain) NSString * missionIds;
@property (nonatomic, retain) NSString * planDescription;
@property (nonatomic, retain) NSNumber * planId;
@property (nonatomic, retain) NSString * planName;
@property (nonatomic, retain) NSNumber * planShareUser;
@property (nonatomic, retain) NSString * planShareUserName;
@property (nonatomic, retain) NSNumber * planStatus;
@property (nonatomic, retain) NSNumber * planType;
@property (nonatomic, retain) NSNumber * sharedPlan;
@property (nonatomic, retain) NSNumber * totalMissions;

@property (nonatomic, retain) NSMutableArray * missions;

+(Plan *) intiUnassociateEntity;

+(Plan *) removeAssociateForEntity:(Plan *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;

-(NSMutableDictionary *)transToDictionary;

@end
