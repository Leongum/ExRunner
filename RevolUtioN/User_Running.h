//
//  User_Running.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface User_Running : NSManagedObject

@property (nonatomic, retain) NSDate * commitTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * missionId;
@property (nonatomic, retain) NSNumber * missionStatus;
@property (nonatomic, retain) NSNumber * missionTypeId;
@property (nonatomic, retain) NSString * runUuid;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * userId;

+(User_Running *) removeAssociateForEntity:(User_Running *)associatedEntity;

-(NSMutableDictionary *)transToDictionary;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
