//
//  Mission.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Mission : NSManagedObject

@property (nonatomic, retain) NSNumber * challengeId;
@property (nonatomic, retain) NSNumber * cycleTime;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSDate * lastUpdateTime;
@property (nonatomic, retain) NSNumber * levelLimited;
@property (nonatomic, retain) NSString * missionContent;
@property (nonatomic, retain) NSNumber * missionDistance;
@property (nonatomic, retain) NSNumber * missionFlag;
@property (nonatomic, retain) NSString * missionFrom;
@property (nonatomic, retain) NSNumber * missionId;
@property (nonatomic, retain) NSString * missionName;
@property (nonatomic, retain) NSNumber * missionPackageId;
@property (nonatomic, retain) NSNumber * missionPlacePackageId;
@property (nonatomic, retain) NSNumber * missionSpeed;
@property (nonatomic, retain) NSNumber * missionSteps;
@property (nonatomic, retain) NSNumber * missionTime;
@property (nonatomic, retain) NSString * missionTo;
@property (nonatomic, retain) NSNumber * missionTypeId;
@property (nonatomic, retain) NSNumber * scores;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSString * subMissionList;
@property (nonatomic, retain) NSNumber *plan_id;

//array list for place package, challenge, submission
@property (nonatomic, retain) NSArray * missionPlacePackageList;
@property (nonatomic, retain) NSArray * challengeList;
@property (nonatomic, retain) NSArray * subMissionPackageList;

+(Mission *) removeAssociateForEntity:(Mission *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;
@end
