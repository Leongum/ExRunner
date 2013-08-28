//
//  User_Last_Location.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface User_Last_Location : NSManagedObject

@property (nonatomic, retain) NSDate * lastActiveTime;
@property (nonatomic, retain) NSString * lastLocationContent;
@property (nonatomic, retain) NSString * lastLocationPoint;
@property (nonatomic, retain) NSNumber * userId;

@end
