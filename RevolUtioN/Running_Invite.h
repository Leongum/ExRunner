//
//  Running_Invite.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Running_Invite : NSManagedObject

@property (nonatomic, retain) NSNumber * inviteId;
@property (nonatomic, retain) NSNumber * inviteType;
@property (nonatomic, retain) NSDate * runningTime;
@property (nonatomic, retain) NSNumber * missionId;
@property (nonatomic, retain) NSNumber * missionType;
@property (nonatomic, retain) NSString * inviteTitle;
@property (nonatomic, retain) NSString * inviteContent;
@property (nonatomic, retain) NSNumber * inviteUserId;
@property (nonatomic, retain) NSNumber * friendUserId;
@property (nonatomic, retain) NSNumber * inviteStatus;
@property (nonatomic, retain) NSDate * inviteTime;

@end
