//
//  RORSystemService.m
//  RevolUtioN
//
//  Created by leon on 13-8-10.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSystemService.h"

@implementation RORSystemService

+ (Version_Control *)fetchVersionInfo:(NSString *) platform{
    return [self fetchVersionInfo:platform withContext:NO];
}

+ (Version_Control *)fetchVersionInfo:(NSString *) platform withContext:(BOOL) needContext{
    
    NSString *table=@"Version_Control";
    NSString *query = @"platform = %@";
    NSArray *params = [NSArray arrayWithObjects:platform, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if(!needContext){
        return [Version_Control removeAssociateForEntity:(Version_Control *) [fetchObject objectAtIndex:0]];
    }
    return  (Version_Control *) [fetchObject objectAtIndex:0];
}

+ (void) saveSystimeTime:(NSString *)systemTime{
    NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
    [userDict setValue:systemTime forKey:@"systemTime"];
    [RORUserUtils writeToUserInfoPList:userDict];
}

+(void)syncVersion:(NSString *)platform{
    NSError *error = nil;
    RORHttpResponse *httpResponse =[RORSystemClientHandler getVersionInfo:platform];
    
    if ([httpResponse responseStatus] == 200){
        NSDictionary *versionInfo = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        Version_Control *versionEntity = [self fetchVersionInfo:platform withContext:YES];
        NSLog(@"%@",versionEntity.systemTime);
        NSLog(@"%@",versionEntity.version);
        if(versionEntity == nil)
            versionEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Version_Control" inManagedObjectContext:[RORContextUtils getShareContext]];
        [versionEntity initWithDictionary:versionInfo];
        
        [RORContextUtils saveContext];
        NSLog(@"%@",versionEntity.systemTime);
        [self saveSystimeTime:[RORUtils getStringFromDate:versionEntity.systemTime]];
    } else {
        NSLog(@"sync with host error: can't get version info. Status Code: %d", [httpResponse responseStatus]);
    }
}

@end
