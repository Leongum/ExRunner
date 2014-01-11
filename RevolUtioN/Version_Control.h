//
//  Version_Control.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Version_Control : NSManagedObject

@property (nonatomic, retain) NSString * decs;
@property (nonatomic, retain) NSString * platform;
@property (nonatomic, retain) NSNumber * subVersion;
@property (nonatomic, retain) NSDate * systemTime;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSDate * missionLastUpdateTime;
@property (nonatomic, retain) NSDate * messageLastUpdateTime;
@property (nonatomic, retain) NSDate *recommendLastUpdateTime;

+(Version_Control *) removeAssociateForEntity:(Version_Control *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;
@end
