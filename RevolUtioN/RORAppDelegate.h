//
//  RORAppDelegate.h
//  RevolUtioN
//
//  Created by Beyond on 13-4-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WBApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <RennSDK/RennSDK.h>
#import <ShareSDK/ShareSDK.h>
#import "RORShareViewDelegate.h"
#import "Reachability.h"
#import <CoreMotion/CoreMotion.h>

@interface RORAppDelegate : UIResponder <UIApplicationDelegate>
{
    RORShareViewDelegate *_viewDelegate;
    Reachability* hostReach;
    CMMotionManager *motionmanager;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly,strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly,strong,nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly,strong,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSDictionary *userInfo;
@property (readonly) NetworkStatus networkStatus;
@property (nonatomic,readonly) RORShareViewDelegate *viewDelegate;
@property (strong, nonatomic, readonly) CMMotionManager *sharedManager;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
