//
//  RORMissionServices.m
//  RevolUtioN
//
//  Created by leon on 13-7-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMissionServices.h"


@implementation RORMissionServices


+(Mission *)fetchPackageMission:(NSNumber *) packageMissionId{
    
    NSString *table=@"Mission";
    MissionTypeEnum cycle = Cycle;
    NSString *query = @"missionId = %@ and missionTypeId = %@";
    NSArray *params = [NSArray arrayWithObjects:packageMissionId, (int)cycle, nil];
    
    NSArray *fetchObject = [RORUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    Mission *packageMission = (Mission *) [fetchObject objectAtIndex:0];
    
    query = @"missionPackageId = %@ and missionTypeId = %@";
    MissionTypeEnum subCycle = SubCycle;
    params = [NSArray arrayWithObjects:packageMissionId, (int)subCycle, nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    fetchObject = [RORUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
    packageMission.subMissionPackageList = [(NSArray*)fetchObject mutableCopy];
    return packageMission;
    
}

+(Mission *)fetchRecommandMission:(NSNumber *) recommandMissionId{
    
    NSString *table=@"Mission";
    MissionTypeEnum recommand = Recommand;
    NSString *query = @"missionId = %@ and missionTypeId = %@";
    NSArray *params = [NSArray arrayWithObjects:recommandMissionId, (int)recommand, nil];
    
    NSArray *fetchObject = [RORUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    Mission *recommandMission = (Mission *) [fetchObject objectAtIndex:0];
    
    if(recommandMission.missionPlacePackageId != nil){
        table = @"Place_Package";
        query = @"packageId = %@";
        params = [NSArray arrayWithObjects:recommandMission.missionPlacePackageId, nil];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
        NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
        fetchObject = [RORUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
        recommandMission.missionPlacePackageList = [(NSArray*)fetchObject mutableCopy];
    }
    return recommandMission;
    
}

+(Mission *)fetchMissionDetails:(Mission *) mission{
    
    if([mission.missionTypeId intValue] == (int)Cycle){
        NSString *table=@"Mission";
        NSString *query = @"missionPackageId = %@ and missionTypeId = %@";
        NSArray *params = [NSArray arrayWithObjects:mission.missionId, (int)SubCycle, nil];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:NO];
        NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
        NSArray *fetchObject = [RORUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
        mission.subMissionPackageList = [(NSArray*)fetchObject mutableCopy];
    }
    if([mission.missionTypeId intValue] == (int)Recommand && mission.missionPlacePackageId != nil){
        NSString *table = @"Place_Package";
        NSString *query = @"packageId = %@";
        NSArray *params = [NSArray arrayWithObjects:mission.missionPlacePackageId, nil];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:NO];
        NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
        NSArray *fetchObject = [RORUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
        mission.missionPlacePackageList = [(NSArray*)fetchObject mutableCopy];
    }
    if(mission.challengeId != nil){
        NSString *table = @"Mission_Challenge";
        NSString *query = @"challengeId = %@";
        NSArray *params = [NSArray arrayWithObjects:mission.challengeId, nil];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:NO];
        NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
        NSArray *fetchObject = [RORUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
        mission.challengeList = [(NSArray*)fetchObject mutableCopy];
    }
    return mission;
    
}

+(Mission *)fetchMission:(NSNumber *) missionId{
    NSString *table=@"Mission";
    NSString *query = @"missionId = %@";
    NSArray *params = [NSArray arrayWithObjects:missionId, nil];
    NSArray *fetchObject = [RORUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    Mission *mission = (Mission *) [fetchObject objectAtIndex:0];
    return [self fetchMissionDetails:mission];
}

+(NSArray *)fetchMissionList:(MissionTypeEnum *) missionType{
    NSString *table=@"Mission";
    NSString *query = @"%@ missionTypeId = %@";
    NSArray *params = [NSArray arrayWithObjects:@"",(int)missionType, nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"missionId" ascending:YES];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *missionDetails = [NSMutableArray arrayWithCapacity:10];
    for (Mission *mission in fetchObject) {
        [missionDetails addObject: [self fetchMissionDetails:mission]];
    }
    return [(NSArray*)missionDetails mutableCopy];;
}

+(void) deletePlacePackage:(NSNumber *) placePackageId{
    NSString *table=@"Place_Package";
    NSString *query = @"packageId = %@";
    NSArray *params = [NSArray arrayWithObjects:placePackageId, nil];
    [RORUtils deleteFromDelegate:table withParams:params withPredicate:query];
}

+(void) deleteChallenges:(NSNumber *) challengeId{
    NSString *table=@"Mission_Challenge";
    NSString *query = @"challengeId = %@";
    NSArray *params = [NSArray arrayWithObjects:challengeId, nil];
    [RORUtils deleteFromDelegate:table withParams:params withPredicate:query];
}

+ (Boolean)syncMissions{
    NSError *error = nil;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSString *lastUpdateTime = [RORUtils getLastUpdateTime:@"MissionUpdateTime"];
    
    /* 
    //only need sync challenge
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithCapacity:3];
    [headers setObject:MissionTypeEnum_toString[Challenge] forKey:@"X-MISSION-TYPE"];
    RORHttpResponse *httpResponse =[RORMissionClientHandler getMissions:lastUpdateTime withHeaders:headers];
    */
    
    RORHttpResponse *httpResponse =[RORMissionClientHandler getMissions:lastUpdateTime];
    
    if ([httpResponse responseStatus]  == 200){
        NSArray *missionList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *missionDict in missionList){
            NSNumber *missionId = [missionDict valueForKey:@"missionId"];
            Mission *missionEntity = [self fetchMission:missionId];
            if(missionEntity == nil)
                missionEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Mission" inManagedObjectContext:context];
            [missionEntity initWithDictionary:missionDict];
            //sync place list
            if (![[missionDict valueForKey:@"missionPlacePackages"] isKindOfClass:[NSNull class]]){
                NSArray *placeList = [missionDict valueForKey:@"missionPlacePackages"];
                [self deletePlacePackage:[missionDict valueForKey:@"missionPlacePackageId"]];
                for (NSDictionary *place in placeList){
                    Place_Package *placeEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Place_Package" inManagedObjectContext:context];
                    [placeEntity initWithDictionary:place];
                }
            }
            //sync challenge list
            if (![[missionDict valueForKey:@"missionChallenges"] isKindOfClass:[NSNull class]]){
                NSArray *challengeList = [missionDict valueForKey:@"missionChallenges"];
                [self deleteChallenges:[missionDict valueForKey:@"challengeId"]];
                for (NSDictionary *challenge in challengeList){
                    Place_Package *challengeEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Mission_Challenge" inManagedObjectContext:context];
                    [challengeEntity initWithDictionary:challenge];
                }
            }
        }
        if (![context save:&error]) {
            NSLog(@"%@",[error localizedDescription]);
        }
        
        [RORUtils saveLastUpdateTime:@"MissionUpdateTime"];
    } else {
        NSLog(@"sync with host error: can't get mission list. Status Code: %d", [httpResponse responseStatus]);
        return NO;
    }
    return YES;
}

@end
