//
//  Recommend_App.h
//  Cyberace
//
//  Created by Bjorn on 14-1-10.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Recommend_App : NSManagedObject

@property (nonatomic, retain) NSString * appIcon;
@property (nonatomic, retain) NSString * appName;
@property (nonatomic, retain) NSString * appDescription;
@property (nonatomic, retain) NSString * appAddress;
@property (nonatomic, retain) NSDate * lastUpdateTime;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * sequence;

@end
