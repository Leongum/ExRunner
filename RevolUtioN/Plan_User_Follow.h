//
//  Plan_User_Follow.h
//  Cyberace
//
//  Created by leon on 13-11-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Plan_User_Follow : NSManagedObject

@property (nonatomic, retain) NSDate * addTime;
@property (nonatomic, retain) NSNumber * followUserId;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * updated;

+(Plan_User_Follow *) intiUnassociateEntity;

+(Plan_User_Follow *) removeAssociateForEntity:(Plan_User_Follow *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;

-(NSMutableDictionary *)transToDictionary;

@end
