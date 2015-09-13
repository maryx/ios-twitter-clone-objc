//
//  User.m
//  ios-twitter-clone
//
//  Created by Mary Xia on 9/12/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const UserDidLogInNotification = @"UserDidLogInNotification";
NSString * const UserDidLogOutNotification = @"UserDidLogOutNotification";

@interface User()
@property (nonatomic, strong) NSDictionary *dictionary;
@end

@implementation User

- (id)initWithDictionary: (NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenname = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.tagline = dictionary[@"description"];
    }
    return self;
}

static User *_currentUser = nil;

NSString * const kCurrentUserKey = @"kCurrentUserKey";

+ (User *) currentUser {
    if (_currentUser == nil) { // if logged out
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey: kCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary =
                [NSJSONSerialization
                 JSONObjectWithData: data
                 options: 0
                 error: NULL
                 ];
            _currentUser = [[User alloc] initWithDictionary: dictionary];
                                        
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    if (_currentUser != nil) {
        // null is nil in a dictionary
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
}

+ (void)logout {
    [User setCurrentUser: nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: UserDidLogOutNotification object: nil];
}

@end