//
//  Plan_Collect.h
//  Cyberace
//
//  Created by leon on 13-11-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Plan_Collect : NSManagedObject

@property (nonatomic, retain) NSNumber * collectStatus;
@property (nonatomic, retain) NSDate * collectTime;
@property (nonatomic, retain) NSNumber * planId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * updated;

+(Plan_Collect *) initUnassociateEntity;

+(Plan_Collect *) removeAssociateForEntity:(Plan_Collect *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;

-(NSMutableDictionary *)transToDictionary;

@end
