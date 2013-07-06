//
//  Place_Package.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Place_Package : NSManagedObject

@property (nonatomic, retain) NSNumber * packageId;
@property (nonatomic, retain) NSString * placeDesc;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSString * placePoint;
@property (nonatomic, retain) NSNumber * sequence;

-(void)initWithDictionary:(NSDictionary *)dict;
@end
