//
//  RORThirdPartyService.h
//  RevolUtioN
//
//  Created by leon on 13-8-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORHttpResponse.h"
#import "RORThirdPartyClientHandler.h"

@interface RORThirdPartyService : NSObject

+(NSDictionary *)syncWeatherInfo:(NSString *)cityCode;

+(NSDictionary *)syncPM25Info:(NSString *)city withProvince:(NSString *)province;

@end
