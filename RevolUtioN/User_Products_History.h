//
//  User_Products_History.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface User_Products_History : NSManagedObject

@property (nonatomic, retain) NSDate * buyTime;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSNumber * productsId;
@property (nonatomic, retain) NSNumber * scores;
@property (nonatomic, retain) NSNumber * userId;

@end
