//
//  User.h
//  ios-twitter-clone
//
//  Created by Mary Xia on 9/12/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLogInNotification;
extern NSString * const UserDidLogOutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;

- (id)initWithDictionary: (NSDictionary *)dictionary;

+ (User *) currentUser;

+ (void)setCurrentUser:(User *)currentUser;

+ (void)logout;

@end
