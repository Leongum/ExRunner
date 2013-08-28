//
//  User_Base.m
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "User_Base.h"
#import "RORDBCommon.h"


@implementation User_Base

@dynamic nickName;
@dynamic password;
@dynamic sex;
@dynamic userEmail;
@dynamic userId;
@dynamic uuid;

@synthesize attributes;

+(User_Base *) intiUnassociateEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Base" inManagedObjectContext:context];
    User_Base *unassociatedEntity = [[User_Base alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return unassociatedEntity;
}

+(User_Base *) removeAssociateForEntity:(User_Base *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Base" inManagedObjectContext:context];
    User_Base *unassociatedEntity = [[User_Base alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    unassociatedEntity.attributes=[User_Attributes removeAssociateForEntity:associatedEntity.attributes];
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.nickName = [RORDBCommon getStringFromId:[dict valueForKey:@"nickName"]];
    self.userEmail = [RORDBCommon getStringFromId:[dict valueForKey:@"userEmail"]];
    self.sex = [RORDBCommon getStringFromId:[dict valueForKey:@"sex"]];
    self.uuid = [RORDBCommon getStringFromId:[dict valueForKey:@"uuid"]];
}
@end
