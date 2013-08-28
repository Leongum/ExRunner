//
//  Mission_Challenge.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Mission_Challenge : NSManagedObject

@property (nonatomic, retain) NSNumber * challengeId;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * grade;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSNumber * time;

+(Mission_Challenge *) removeAssociateForEntity:(Mission_Challenge *)associatedEntity;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
