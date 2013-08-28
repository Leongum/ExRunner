//
//  RORRunHistoryClientHandler.h
//  RevolUtioN
//
//  Created by leon on 13-7-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORConstant.h"
#import "RORUtils.h"
#import "RORHttpClientHandler.h"
#import "RORHttpResponse.h"

@interface RORRunHistoryClientHandler : NSObject

+(RORHttpResponse *)createRunHistories:(NSNumber *) userId withRunHistories:(NSArray *) runHistories;

+(RORHttpResponse *)getRunHistories:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime;

+(RORHttpResponse *)createUserRunning:(NSNumber *) userId withUserRun:(NSArray *) userRunning;

+(RORHttpResponse *)getUserRunning:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime;

@end
