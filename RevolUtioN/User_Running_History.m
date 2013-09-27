//
//  User_Running_History.m
//  RevolUtioN
//
//  Created by leon on 13828.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "User_Running_History.h"
#import "RORDBCommon.h"


@implementation User_Running_History

@dynamic avgSpeed;
@dynamic comment;
@dynamic commitTime;
@dynamic distance;
@dynamic duration;
@dynamic experience;
@dynamic extraExperience;
@dynamic grade;
@dynamic missionDate;
@dynamic missionEndTime;
@dynamic missionGrade;
@dynamic missionId;
@dynamic missionRoute;
@dynamic missionStartTime;
@dynamic missionTypeId;
@dynamic offerUsers;
@dynamic runUuid;
@dynamic scores;
@dynamic spendCarlorie;
@dynamic steps;
@dynamic userId;
@dynamic uuid;
@dynamic waveForm;
@dynamic valid;

+(User_Running_History *) intiUnassociateEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Running_History" inManagedObjectContext:context];
    User_Running_History *unassociatedEntity = [[User_Running_History alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return unassociatedEntity;
}

+(User_Running_History *) removeAssociateForEntity:(User_Running_History *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Running_History" inManagedObjectContext:context];
    User_Running_History *unassociatedEntity = [[User_Running_History alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.avgSpeed = [RORDBCommon getNumberFromId:[dict valueForKey:@"avgSpeed"]];
    self.comment = [RORDBCommon getStringFromId:[dict valueForKey:@"comment"]];
    self.distance = [RORDBCommon getNumberFromId:[dict valueForKey:@"distance"]];
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.runUuid= [RORDBCommon getStringFromId:[dict valueForKey:@"runUuid"]];
    self.missionTypeId = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionTypeId"]];
    self.missionRoute = [RORDBCommon getStringFromId:[dict valueForKey:@"missionRoute"]];
    self.waveForm = [RORDBCommon getStringFromId:[dict valueForKey:@"waveForm"]];
    self.missionStartTime = [RORDBCommon getDateFromId:[dict valueForKey:@"missionStartTime"]];
    self.missionEndTime = [RORDBCommon getDateFromId:[dict valueForKey:@"missionEndTime"]];
    self.missionDate = [RORDBCommon getDateFromId:[dict valueForKey:@"missionDate"]];
    self.spendCarlorie = [RORDBCommon getNumberFromId:[dict valueForKey:@"spendCarlorie"]];
    self.duration = [RORDBCommon getNumberFromId:[dict valueForKey:@"duration"]];
    self.offerUsers = [RORDBCommon getStringFromId:[dict valueForKey:@"offerUsers"]];
    self.missionGrade = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionGrade"]];
    self.scores = [RORDBCommon getNumberFromId:[dict valueForKey:@"scores"]];
    self.experience = [RORDBCommon getNumberFromId:[dict valueForKey:@"experience"]];
    self.extraExperience = [RORDBCommon getNumberFromId:[dict valueForKey:@"extraExperience"]];
    self.missionId = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionId"]];
    self.uuid = [RORDBCommon getStringFromId:[dict valueForKey:@"uuid"]];
    self.steps = [RORDBCommon getNumberFromId:[dict valueForKey:@"steps"]];
    self.commitTime = [RORDBCommon getDateFromId:[dict valueForKey:@"commitTime"]];
    self.grade = [RORDBCommon getNumberFromId:[dict valueForKey:@"grade"]];
    self.valid = [RORDBCommon getNumberFromId:[dict valueForKey:@"valid"]];
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempoDict = [[NSMutableDictionary alloc] init];
    [tempoDict setValue:self.avgSpeed forKey:@"avgSpeed"];
    [tempoDict setValue:self.comment forKey:@"comment"];
    [tempoDict setValue:self.distance forKey:@"distance"];
    [tempoDict setValue:self.userId forKey:@"userId"];
    [tempoDict setValue:self.runUuid forKey:@"runUuid"];
    [tempoDict setValue:self.missionTypeId forKey:@"missionTypeId"];
    [tempoDict setValue:self.missionRoute forKey:@"missionRoute"];
    [tempoDict setValue:self.waveForm forKey:@"waveForm"];
    [tempoDict setValue:[RORDBCommon getStringFromId:self.missionStartTime] forKey:@"missionStartTime"];
    [tempoDict setValue:[RORDBCommon getStringFromId:self.missionEndTime] forKey:@"missionEndTime"];
    [tempoDict setValue:[RORDBCommon getStringFromId:self.missionDate] forKey:@"missionDate"];
    [tempoDict setValue:self.spendCarlorie forKey:@"spendCarlorie"];
    [tempoDict setValue:self.duration forKey:@"duration"];
    [tempoDict setValue:self.offerUsers forKey:@"offerUsers"];
    [tempoDict setValue:self.steps forKey:@"steps"];
    [tempoDict setValue:self.missionGrade forKey:@"missionGrade"];
    [tempoDict setValue:self.scores forKey:@"scores"];
    [tempoDict setValue:self.experience forKey:@"experience"];
    [tempoDict setValue:self.extraExperience forKey:@"extraExperience"];
    [tempoDict setValue:self.missionId forKey:@"missionId"];
    [tempoDict setValue:self.uuid forKey:@"uuid"];
    [tempoDict setValue:[RORDBCommon getStringFromId:self.commitTime] forKey:@"commitTime"];
    [tempoDict setValue:self.grade forKey:@"grade"];
    [tempoDict setValue:self.valid forKey:@"valid"];
    return tempoDict;
}


@end
