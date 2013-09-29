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
#import "RORAppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "RORConstant.h"
#import "RORMessages.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface RORUtils : NSObject

+ (NSString *)transSecondToStandardFormat:(double) seconds;

+ (NSDate *)getDateFromString:(NSString *) date;

+ (NSString *)getStringFromDate:(NSDate *) date;

+ (NSString *)md5:(NSString *)str;

+ (NSString *)uuidString;

+ (NSData *)gzipCompressData:(NSData *)uncompressedData;

+ (NSString *)toJsonFormObject:(NSObject *)object;

+ (NSString*)getCityCodeJSon;

+ (NSString *)getCitycodeByCityname:(NSString *)cityName withProvince:(NSString *)provinceName;

+ (NSString*)outputDistance:(double)distance;

+(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews;
//help finding out new added fonts
+(void)listFontFamilies;

+(double)randomBetween:(NSInteger)x1 and:(NSInteger)x2;

+ (int)convertToInt:(NSString*)strtemp;

@end
