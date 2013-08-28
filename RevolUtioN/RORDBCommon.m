//
//  RORDBCommon.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORDBCommon.h"
#import <CoreLocation/CoreLocation.h>

@implementation RORDBCommon

+ (BOOL) isEmpty:(id)obj {
    if (obj == nil || [obj isKindOfClass:[NSNull class]])
        return YES;
    return NO;
}

+ (NSDate *)getDateFromId:(id)obj{
    if ([self isEmpty:obj])
        return nil;
    if ([obj isKindOfClass:[NSString class]]){
        NSString *str = (NSString *)obj;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSDate *date = [formatter dateFromString:str];
        return date;
    } else if([obj isKindOfClass:[NSDate class]]){
        return (NSDate *)obj;
    }
    return nil;
}

+ (NSString *)getStringFromId:(id)obj{
    if ([self isEmpty:obj])
        return nil;
    if ([obj isKindOfClass:[NSString class]])
        return (NSString *)obj;
    if ([obj isKindOfClass:[NSDate class]]){
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        return [formate stringFromDate:obj];
    }
    return [NSString stringWithFormat:@"%@", obj];
}

+ (NSNumber *)getNumberFromId:(id)obj{
    if ([self isEmpty:obj])
        return nil;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    if ([obj isKindOfClass:[NSString class]]){
        NSString *str = (NSString *) obj;
        NSNumber *result = [f numberFromString:str];
        if(!(result))
            return nil;
        return result;
    } else if ([obj isKindOfClass:[NSNumber class]]){
        return (NSNumber *)obj;
    }
    return nil;
}

+ (NSString *)getStringFromRoutePoints:(NSArray *)routePoints{
    NSMutableString *route_str = [[NSMutableString alloc] init];
    for (int i=0; i<routePoints.count; i++){
        CLLocation *loc_i = [routePoints objectAtIndex:i];
        CLLocationCoordinate2D loc_coor = [loc_i coordinate];
        [route_str appendString:[NSString stringWithFormat:@"%f,%f ",loc_coor.latitude, loc_coor.longitude]];
    }
    return route_str;
}

+ (NSArray *)getRoutePointsFromString:(NSString *)route_str{
    NSArray *pairs = [route_str componentsSeparatedByString:@" "];
    NSMutableArray *routePoints = [[NSMutableArray alloc] init];
    for (int i=0; i<pairs.count-1; i++){
        NSString *thisString = (NSString *)[pairs objectAtIndex:i];
        NSArray *pair = [thisString componentsSeparatedByString:@","];
        float latitude = [[self getNumberFromId:pair[0]] floatValue];
        float longitude = [[self getNumberFromId:pair[1]] floatValue];
//        CLLocationCoordinate2D loc_coor = CLLocationCoordinate2DMake(latitude, longitude);
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        [routePoints addObject:loc];
    }
    return routePoints;
}

@end
