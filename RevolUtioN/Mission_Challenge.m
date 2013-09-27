//
//  Mission_Challenge.m
//  RevolUtioN
//
//  Created by leon on 13828.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Mission_Challenge.h"
#import "RORDBCommon.h"

@implementation Mission_Challenge

@dynamic challengeId;
@dynamic distance;
@dynamic grade;
@dynamic note;
@dynamic sequence;
@dynamic time;
@dynamic sex;
@dynamic rule;

+(Mission_Challenge *) removeAssociateForEntity:(Mission_Challenge *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Mission_Challenge" inManagedObjectContext:context];
    Mission_Challenge *unassociatedEntity = [[Mission_Challenge alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.challengeId = [RORDBCommon getNumberFromId:[dict valueForKey:@"challengeId"]];
    self.grade = [RORDBCommon getStringFromId:[dict valueForKey:@"grade"]];
    self.time = [RORDBCommon getNumberFromId:[dict valueForKey:@"time"]];
    self.distance = [RORDBCommon getNumberFromId:[dict valueForKey:@"distance"]];
    self.sequence = [RORDBCommon getNumberFromId:[dict valueForKey:@"sequence"]];
    self.note = [RORDBCommon getStringFromId:[dict valueForKey:@"note"]];
    self.sex = [RORDBCommon getStringFromId:[dict valueForKey:@"sex"]];
    self.rule = [RORDBCommon getStringFromId:[dict valueForKey:@"rule"]];
}
@end
