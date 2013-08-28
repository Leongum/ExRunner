//
//  Communication.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Communication : NSManagedObject

@property (nonatomic, retain) NSNumber * communicationId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * fromUserId;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * toUserId;

@end
