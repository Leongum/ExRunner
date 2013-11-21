//
//  Plan_User_Follow.m
//  Cyberace
//
//  Created by leon on 13-11-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Plan_User_Follow.h"
#import "RORDBCommon.h"

@implementation Plan_User_Follow

@dynamic addTime;
@dynamic followerUserId;
@dynamic status;
@dynamic userId;
@dynamic updated;

+(Plan_User_Follow *) intiUnassociateEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Plan_User_Follow" inManagedObjectContext:context];
    Plan_User_Follow *unassociatedEntity = [[Plan_User_Follow alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return unassociatedEntity;
}

+(Plan_User_Follow *) removeAssociateForEntity:(Plan_User_Follow *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Plan_User_Follow" inManagedObjectContext:context];
    Plan_User_Follow *unassociatedEntity = [[Plan_User_Follow alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.addTime = [RORDBCommon getDateFromId:[dict valueForKey:@"addTime"]];
    self.followerUserId = [RORDBCommon getNumberFromId:[dict valueForKey:@"followerUserId"]];
    self.status = [RORDBCommon getNumberFromId:[dict valueForKey:@"status"]];
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.updated = [RORDBCommon getNumberFromId:[dict valueForKey:@"updated"]];
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempoDict = [[NSMutableDictionary alloc] init];
    [tempoDict setValue:[RORDBCommon getStringFromId:self.addTime] forKey:@"addTime"];
    [tempoDict setValue:self.followerUserId forKey:@"followerUserId"];
    [tempoDict setValue:self.status forKey:@"status"];
    [tempoDict setValue:self.userId forKey:@"userId"];
    return tempoDict;
}

@end
