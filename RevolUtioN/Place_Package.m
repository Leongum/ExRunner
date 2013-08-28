//
//  Place_Package.m
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Place_Package.h"
#import "RORDBCommon.h"

@implementation Place_Package

@dynamic packageId;
@dynamic placeDesc;
@dynamic placeName;
@dynamic placePoint;
@dynamic sequence;

+(Place_Package *) removeAssociateForEntity:(Place_Package *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Place_Package" inManagedObjectContext:context];
    Place_Package *unassociatedEntity = [[Place_Package alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.packageId = [RORDBCommon getNumberFromId:[dict valueForKey:@"packageId"]];
    self.placeName = [RORDBCommon getStringFromId:[dict valueForKey:@"placeName"]];
    self.placePoint = [RORDBCommon getStringFromId:[dict valueForKey:@"placePoint"]];
    self.sequence = [RORDBCommon getNumberFromId:[dict valueForKey:@"sequence"]];
}

@end
