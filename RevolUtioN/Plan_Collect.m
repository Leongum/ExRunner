//
//  Plan_Collect.m
//  Cyberace
//
//  Created by leon on 13-11-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Plan_Collect.h"
#import "RORDBCommon.h"

@implementation Plan_Collect

@dynamic collectStatus;
@dynamic collectTime;
@dynamic planId;
@dynamic userId;
@dynamic updated;

+(Plan_Collect *) initUnassociateEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Plan_Collect" inManagedObjectContext:context];
    Plan_Collect *unassociatedEntity = [[Plan_Collect alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return unassociatedEntity;
}

+(Plan_Collect *) removeAssociateForEntity:(Plan_Collect *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Plan_Collect" inManagedObjectContext:context];
    Plan_Collect *unassociatedEntity = [[Plan_Collect alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.collectStatus = [RORDBCommon getNumberFromId:[dict valueForKey:@"collectStatus"]];
    self.collectTime = [RORDBCommon getDateFromId:[dict valueForKey:@"collectTime"]];
    self.planId = [RORDBCommon getNumberFromId:[dict valueForKey:@"planId"]];
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.updated = [RORDBCommon getNumberFromId:[dict valueForKey:@"updated"]];
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempoDict = [[NSMutableDictionary alloc] init];
    [tempoDict setValue:self.collectStatus forKey:@"collectStatus"];
    [tempoDict setValue:[RORDBCommon getStringFromId:self.collectTime] forKey:@"collectTime"];
    [tempoDict setValue:self.planId forKey:@"planId"];
    [tempoDict setValue:self.userId forKey:@"userId"];
    return tempoDict;
}

@end
