//
//  User_Last_Location.m
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "User_Last_Location.h"
#import "RORDBCommon.h"

@implementation User_Last_Location

@dynamic lastActiveTime;
@dynamic lastLocationContent;
@dynamic lastLocationPoint;
@dynamic userId;

+(User_Last_Location *) initUnassociateEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Last_Location" inManagedObjectContext:context];
    User_Last_Location *unassociatedEntity = [[User_Last_Location alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return unassociatedEntity;
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempoDict = [[NSMutableDictionary alloc] init];
    [tempoDict setValue:self.userId forKey:@"userId"];
    [tempoDict setValue:self.lastLocationPoint forKey:@"lastLocationPoint"];
    [tempoDict setValue:self.lastLocationContent forKey:@"lastLocationContent"];
    [tempoDict setValue:self.lastActiveTime forKey:@"lastActiveTime"];
    return tempoDict;
}
@end
