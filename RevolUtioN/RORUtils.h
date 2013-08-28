//
//  RORUtils.h
//  RevolUtioN
//
//  Created by leon on 13-7-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zlib.h" 
#import <SBJson/SBJson.h>
#import "Reachability.h"
#import "RORAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface RORUtils : NSObject

+ (NSString *)transSecondToStandardFormat:(NSInteger) seconds;

+ (NSDate *)getDateFromString:(NSString *) date;

+ (NSString *)getStringFromDate:(NSDate *) date;

+ (NSString *)md5:(NSString *)str;

+ (NSString *)uuidString;

+ (NSData *)gzipCompressData:(NSData *)uncompressedData;

+ (NSString *)toJsonFormObject:(NSObject *)object;

+ (NSString*)getCityCodeJSon;

+ (BOOL) isConnectionAvailable;

+ (NSString *)getCitycodeByCityname:(NSString *)cityName;

+ (NSString*)outputDistance:(NSNumber*)distance;

+(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews;

@end
