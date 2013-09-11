//
//  User_Attributes.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User_Attributes : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * baseAcc;
@property (nonatomic, retain) NSNumber * crit;
@property (nonatomic, retain) NSNumber * endurance;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSNumber * inertiaAcc;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * luck;
@property (nonatomic, retain) NSNumber * maxPower;
@property (nonatomic, retain) NSNumber * rapidly;
@property (nonatomic, retain) NSNumber * recoverSpeed;
@property (nonatomic, retain) NSNumber * remainingPower;
@property (nonatomic, retain) NSNumber * scores;
@property (nonatomic, retain) NSNumber * spirit;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * height;

+(User_Attributes *) intiUnassociateEntity;

+(User_Attributes *) removeAssociateForEntity:(User_Attributes *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
