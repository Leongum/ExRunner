//
//  Version_Control.m
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Version_Control.h"
#import "RORDBCommon.h"


@implementation Version_Control

@dynamic decs;
@dynamic platform;
@dynamic subVersion;
@dynamic systemTime;
@dynamic version;

+(Version_Control *) removeAssociateForEntity:(Version_Control *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Version_Control" inManagedObjectContext:context];
    Version_Control *unassociatedEntity = [[Version_Control alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
        self.platform = [RORDBCommon getStringFromId:[dict valueForKey:@"platform"]];
        self.version = [RORDBCommon getNumberFromId:[dict valueForKey:@"version"]];
        self.subVersion = [RORDBCommon getNumberFromId:[dict valueForKey:@"subVersion"]];
        self.decs = [RORDBCommon getStringFromId:[dict valueForKey:@"description"]];
        self.systemTime = [RORDBCommon getDateFromId:[dict valueForKey:@"systemTime"]];
}

@end
