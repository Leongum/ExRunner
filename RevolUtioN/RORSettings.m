//
//  RORSettings.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-31.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSettings.h"

@implementation RORSettings

static NSMutableDictionary *configList = nil;

//+ (NSMutableDictionary*)getConfigList{
//    if (configList == nil) {
//        NSString *path = [RORPlistPaths getUserSettingsPList];
//        configList = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
//    }
//    return configList;
//}


+(NSMutableDictionary*)getInstance{
    if (configList == nil) {
        configList = [RORUserUtils getUserSettingsPList];
    }
    return configList;
}

+ (void)setValue:(id)value forKey:(NSString *)key{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"userSettings.plist"];
    [configList setValue:value forKey:key];
    [configList writeToFile:path atomically:YES];
}

- (id)copyWithZone:(NSZone*)zone{
    return self;
}

//+ (BOOL) setValue:(id)newValue forKey:(NSString *)confKey{
//    NSMutableDictionary *config = [self getConfigList];
//    [config setValue:newValue forKey:confKey];
//    
//    NSMutableArray *currentListeners  = [listeners4keys objectForKey:confKey];
//    [self announce2Listeners:currentListeners];
//    return YES;
//}
//
//+ (id) getValue4Key:(NSString *)confKey{
//    NSMutableDictionary *config = [self getConfigList];
//    return [config valueForKey:confKey];
//}
//
//+ (void)addListener:(id)listener forKey:(NSString *)confKey{
//    NSMutableArray *listeners = [listeners4keys objectForKey:confKey];
//    if (![listeners containsObject:listener])
//         [listeners addObject:listener];
//}
//
//+ (void)addListener:(id)listener forKeys:(NSArray *)keys{
//    for (id key in keys){
//        [self addListener:listener forKey:(NSString *)key];
//    }
//}
//
//+ (void)addListeners:(NSArray *)listeners forKey:(NSString *)confKey{
//    
//}
//
//+ (void)announce2Listeners:(NSArray *)listeners{
//    for (id obj in listeners){
//        UIView *view = (UIView *)obj;
//        [view reloadInputViews];
//    }
//}
//
//+ (void)announce2All{
//    
//}


@end
