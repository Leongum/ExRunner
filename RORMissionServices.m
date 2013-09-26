//
//  RORMissionServices.m
//  RevolUtioN
//
//  Created by leon on 13-7-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMissionServices.h"
#import "RORNetWorkUtils.h"

@implementation RORMissionServices

+(Mission *)fetchPackageMission:(NSNumber *) packageMissionId{
    return [self fetchPackageMission:packageMissionId withContext:NO];
}

+(Mission *)fetchPackageMission:(NSNumber *) packageMissionId withContext:(BOOL) needContext{
    
    NSString *table=@"Mission";
    MissionTypeEnum cycle = Cycle;
    NSString *query = @"missionId = %@ and missionTypeId = %@";
    NSArray *params = [NSArray arrayWithObjects:packageMissionId, [NSNumber numberWithInt:(int)cycle], nil];
    
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }

    Mission *packageMission = (Mission *) [fetchObject objectAtIndex:0];
    
    query = @"missionPackageId = %@ and missionTypeId = %@";
    MissionTypeEnum subCycle = SubCycle;
    params = [NSArray arrayWithObjects:packageMissionId, [NSNumber numberWithInt:(int)subCycle], nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    packageMission.subMissionPackageList = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
    if(!needContext){
        return [Mission removeAssociateForEntity:packageMission];
    }
    return packageMission;
}

+(Mission *)fetchRecommandMission:(NSNumber *) recommandMissionId{
    return [self fetchRecommandMission:recommandMissionId withContext:NO];
}

+(Mission *)fetchRecommandMission:(NSNumber *) recommandMissionId withContext:(BOOL) needContext{
    
    NSString *table=@"Mission";
    MissionTypeEnum recommand = Recommand;
    NSString *query = @"missionId = %@ and missionTypeId = %@";
    NSArray *params = [NSArray arrayWithObjects:recommandMissionId, [NSNumber numberWithInt:(int)recommand], nil];
    
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
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
        fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
        recommandMission.missionPlacePackageList = [(NSArray*)fetchObject mutableCopy];
    }
    if(!needContext){
        return [Mission removeAssociateForEntity:recommandMission];
    }
    return recommandMission;
}

+(Mission *)fetchMissionDetails:(Mission *) mission{
    
    if([mission.missionTypeId intValue] == (int)Cycle){
        NSString *table=@"Mission";
        NSString *query = @"missionPackageId = %@ and missionTypeId = %@";
        NSLog(@"%@",mission.missionId);
        NSArray *params = [NSArray arrayWithObjects:mission.missionId, [NSNumber numberWithInt:(int)SubCycle], nil];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:NO];
        NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
        NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
        mission.subMissionPackageList = [(NSArray*)fetchObject mutableCopy];
    }
    if([mission.missionTypeId intValue] == (int)Recommand && mission.missionPlacePackageId != nil){
        NSString *table = @"Place_Package";
        NSString *query = @"packageId = %@";
        NSArray *params = [NSArray arrayWithObjects:mission.missionPlacePackageId, nil];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:NO];
        NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
        NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
        mission.missionPlacePackageList = [(NSArray*)fetchObject mutableCopy];
    }
    if(mission.challengeId != nil){
        NSString *table = @"Mission_Challenge";
        NSString *query = @"challengeId = %@";
        NSArray *params = [NSArray arrayWithObjects:mission.challengeId, nil];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
        NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
        NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
        mission.challengeList = [(NSArray*)fetchObject mutableCopy];
    }
    return mission;
    
}

+(Mission *)fetchMission:(NSNumber *) missionId{
    return [self fetchMission:missionId withContext:NO];
}

+(Mission *)fetchMission:(NSNumber *) missionId withContext:(BOOL) needContext{
    NSString *table=@"Mission";
    NSString *query = @"missionId = %@";
    NSArray *params = [NSArray arrayWithObjects:missionId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    Mission *mission = (Mission *) [fetchObject objectAtIndex:0];
    mission = [self fetchMissionDetails:mission];
    if(!needContext){
        return [Mission removeAssociateForEntity:mission];
    }
    return mission;
}

+(NSArray *)fetchMissionList:(MissionTypeEnum *) missionType{
    return [self fetchMissionList:missionType withContext:NO];
}

+(NSArray *)fetchMissionList:(MissionTypeEnum *) missionType withContext:(BOOL) needContext{
    NSString *table=@"Mission";
    NSString *query = @"missionTypeId = %@";
    NSArray *params = [NSArray arrayWithObjects:[NSNumber numberWithInteger:(NSInteger)missionType], nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"missionId" ascending:YES];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *missionDetails = [NSMutableArray arrayWithCapacity:10];
    for (Mission *mission in fetchObject) {
        Mission *detailMission = [self fetchMissionDetails:mission];
        if(!needContext){
            [missionDetails addObject:[Mission removeAssociateForEntity:detailMission]];
        }
        else
        {
            [missionDetails addObject: detailMission];
        }
    }
    return [(NSArray*)missionDetails mutableCopy];;
}

+(void) deletePlacePackage:(NSNumber *) placePackageId{
    NSString *table=@"Place_Package";
    NSString *query = @"packageId = %@";
    NSArray *params = [NSArray arrayWithObjects:placePackageId, nil];
    [RORContextUtils deleteFromDelegate:table withParams:params withPredicate:query];
}

+(void) deleteChallenges:(NSNumber *) challengeId{
    NSString *table=@"Mission_Challenge";
    NSString *query = @"challengeId = %@";
    NSArray *params = [NSArray arrayWithObjects:challengeId, nil];
    [RORContextUtils deleteFromDelegate:table withParams:params withPredicate:query];
}

+ (BOOL)syncMissions{
    if(![RORNetWorkUtils getDoUploadable])return YES;
    NSError *error = nil;
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"MissionUpdateTime"];
    
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
            Mission *missionEntity = [self fetchMission:missionId withContext:YES];
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
        
        [RORContextUtils saveContext];
        [RORUserUtils saveLastUpdateTime:@"MissionUpdateTime"];
    } else {
        NSLog(@"sync with host error: can't get mission list. Status Code: %d", [httpResponse responseStatus]);
        return NO;
    }
    return YES;
}

@end
