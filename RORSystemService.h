//
//  RORSystemService.h
//  RevolUtioN
//
//  Created by leon on 13-8-10.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORAppDelegate.h"
#import "RORHttpResponse.h"
#import "RORSystemClientHandler.h"
#import "Version_Control.h"
#import "System_Message.h"
#import "RORContextUtils.h"

@interface RORSystemService : NSObject

+(void)syncVersion:(NSString *)platform;

+(BOOL)syncSystemMessage;

@end
