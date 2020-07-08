//
//  AppDelegate.m
//  H5Pay
//
//  Created by huweinan on 2020/6/10.
//  Copyright © 2020 hwn. All rights reserved.
//

#import "AppDelegate.h"
#import "WebViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    WebViewController *vc = [WebViewController new];
    self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    return YES;
}



@end
