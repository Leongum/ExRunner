//
//  RORContextUtils.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORUtils.h"

@interface RORContextUtils : NSObject

+ (NSManagedObjectContext *)getShareContext;

+ (void)saveContext;

+ (NSArray *)fetchFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query;

+ (NSArray *)fetchFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query withOrderBy:(NSArray *) sortParams;

+ (void)deleteFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query;

+ (void)clearTableData:(NSArray *) tableArray;

@end
