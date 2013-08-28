//
//  User_Attributes.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "User_Attributes.h"
#import "RORDBCommon.h"

@implementation User_Attributes

@synthesize baseAcc;
@synthesize crit;
@synthesize experience;
@synthesize inertiaAcc;
@synthesize level;
@synthesize luck;
@synthesize scores;
@synthesize userId;
@synthesize maxPower;
@synthesize remainingPower;
@synthesize endurance;
@synthesize spirit;
@synthesize rapidly;
@synthesize recoverSpeed;
@synthesize age, weight, height;

-(void)initWithDictionary:(NSDictionary *)dict{
    userId = [dict valueForKey:@"userId"];
    level = [dict valueForKey:@"level"];
    crit = [dict valueForKey:@"crit"];
    baseAcc = [dict valueForKey:@"baseAcc"];
    experience = [dict valueForKey:@"experience"];
    inertiaAcc = [dict valueForKey:@"inertiaAcc"];
    luck = [dict valueForKey:@"luck"];
    scores = [dict valueForKey:@"scores"];
    maxPower = [dict valueForKey:@"maxPower"];
    remainingPower = [dict valueForKey:@"remainingPower"];
    endurance = [dict valueForKey:@"endurance"];
    spirit = [dict valueForKey:@"spirit"];
    rapidly = [dict valueForKey:@"rapidly"];
    recoverSpeed = [dict valueForKey:@"recoverSpeed"];
    age = [dict valueForKey:@"age"];
    weight = [dict valueForKey:@"weight"];
    height = [dict valueForKey:@"height"];
}

-(void)setAge:(id)obj{
    age = [RORDBCommon getNumberFromId:obj];
}

-(void)setHight:(id)obj{
    height = [RORDBCommon getNumberFromId:obj];
}

-(void)setWeight:(id)obj{
    weight = [RORDBCommon getNumberFromId:obj];
}

-(void)setBaseAcc:(id)obj{
    baseAcc = [RORDBCommon getNumberFromId:obj];
}

-(void)setCrit:(id)obj{
    crit = [RORDBCommon getNumberFromId:obj];
}

-(void)setExperience:(id)obj{
    experience = [RORDBCommon getNumberFromId:obj];
}

-(void)setInertiaAcc:(id)obj{
    inertiaAcc = [RORDBCommon getNumberFromId:obj];
}

-(void)setLevel:(id)obj{
    level = [RORDBCommon getNumberFromId:obj];
}

-(void)setLuck:(id)obj{
    luck = [RORDBCommon getNumberFromId:obj];
}

-(void)setScores:(id)obj{
    scores = [RORDBCommon getNumberFromId:obj];
}

-(void)setUserId:(id)obj{
    userId = [RORDBCommon getNumberFromId:obj];
}

-(void)setMaxPower:(id)obj{
    maxPower = [RORDBCommon getNumberFromId:obj];
}

-(void)setRemainingPower:(id)obj{
    remainingPower = [RORDBCommon getNumberFromId:obj];
}

-(void)setEndurance:(id)obj{
    endurance = [RORDBCommon getNumberFromId:obj];
}

-(void)setSpirit:(id)obj{
    spirit = [RORDBCommon getNumberFromId:obj];
}

-(void)setRapidly:(id)obj{
    rapidly = [RORDBCommon getNumberFromId:obj];
}

-(void)setRecoverSpeed:(id)obj{
    recoverSpeed = [RORDBCommon getNumberFromId:obj];
}

@end
