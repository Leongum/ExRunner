//
//  Products.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Products : NSManagedObject

@property (nonatomic, retain) NSNumber * baseAcc;
@property (nonatomic, retain) NSNumber * crit;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * discount;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * endurance;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * inertiaAcc;
@property (nonatomic, retain) NSNumber * levelLimit;
@property (nonatomic, retain) NSNumber * luck;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSString * productDesc;
@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSNumber * rapidly;
@property (nonatomic, retain) NSNumber * scores;
@property (nonatomic, retain) NSNumber * spirit;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * triggerType;


@end
