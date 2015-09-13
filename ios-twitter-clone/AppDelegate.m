//
//  AppDelegate.m
//  ios-twitter-clone
//
//  Created by Mary Xia on 9/12/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TwitterClient.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[LoginViewController alloc] init]; // Sets first page as the login page
    [self.window makeKeyAndVisible];
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    [[TwitterClient sharedInstance]
     fetchAccessTokenWithPath: @"oauth/access_token"
     method: @"POST"
     requestToken: [BDBOAuth1Credential credentialWithQueryString: url.query]
     success: ^(BDBOAuth1Credential *accessToken){
         NSLog(@"got token");
         [[TwitterClient sharedInstance].requestSerializer saveAccessToken: accessToken];
         // Future requests will be authenticated requests
         [[TwitterClient sharedInstance]
          GET:@"1.1/account/verify_credentials.json"
          parameters: nil
          success: ^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"current User: %@", responseObject);
          }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"failed to get user");
          }];
     }
     failure:^(NSError *error){
         NSLog(@"failed token");
     }];
    
    return YES;
}

@end
