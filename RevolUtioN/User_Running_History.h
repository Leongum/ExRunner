//
//  User_Running_History.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User_Running_History : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * runUuid;
@property (nonatomic, retain) NSNumber * missionId;
@property (nonatomic, retain) NSNumber * missionTypeId;
@property (nonatomic, retain) NSString * missionRoute;
@property (nonatomic, retain) NSString * waveForm;
@property (nonatomic, retain) NSDate * missionStartTime;
@property (nonatomic, retain) NSDate * missionEndTime;
@property (nonatomic, retain) NSDate * missionDate;
@property (nonatomic, retain) NSNumber * spendCarlorie;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * avgSpeed;
@property (nonatomic, retain) NSNumber * steps;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * offerUsers;
@property (nonatomic, retain) NSNumber * missionGrade;
@property (nonatomic, retain) NSNumber * scores;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * commitTime;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * grade;

-(NSMutableDictionary *)transToDictionary;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
