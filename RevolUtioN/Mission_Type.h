//
//  Mission_Type.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Mission_Type : NSManagedObject

@property (nonatomic, retain) NSString * missionName;
@property (nonatomic, retain) NSNumber * missionTypeId;

@end
