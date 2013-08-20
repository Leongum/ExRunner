//
//  RORShareService.h
//  RevolUtioN
//
//  Created by leon on 13-8-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import "User_Base.h"
#import "RORUserServices.h"
#import "RORShareViewDelegate.h"

@interface RORShareService : NSObject

+ (void)authLoginFromSNS:(ShareType) type;

@end
