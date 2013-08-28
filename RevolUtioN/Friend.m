//
//  Friend.m
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Friend.h"
#import "RORDBCommon.h"

@implementation Friend

@dynamic addTime;
@dynamic friendId;
@dynamic friendStatus;
@dynamic updateTime;
@dynamic userId;

+(Friend *) removeAssociateForEntity:(Friend *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:context];
    Friend *unassociatedEntity = [[Friend alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.friendId = [RORDBCommon getNumberFromId:[dict valueForKey:@"friendId"] ];
    self.friendStatus = [RORDBCommon getNumberFromId:[dict valueForKey:@"friendStatus"] ];
    self.addTime = [RORDBCommon getDateFromId:[dict valueForKey:@"addTime"] ];
    self.updateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"updateTime"] ];
}
@end
