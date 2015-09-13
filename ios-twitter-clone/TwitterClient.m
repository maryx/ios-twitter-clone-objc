//
//  TwitterClient.m
//  ios-twitter-clone
//
//  Created by Mary Xia on 9/12/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

#import "TwitterClient.h"

NSString * const kTwitterConsumerKey = @"yJ4FZlwxIy2nZ46yQZUXuMU9K";
NSString * const kTwitterConsumerSecret = @"oOl638YG0Ceo4VRHtkAZ41sM3H5uEXEM6cCC6bbUQKepCZNCVL";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@implementation TwitterClient

// Allows one instance to be used in the entire app
+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil; // only gets set once
    static dispatch_once_t onceToken; // Only runs once. prevents accidentally running multiple times when init
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc]
                        initWithBaseURL: [NSURL URLWithString: kTwitterBaseUrl]
                        consumerKey: kTwitterConsumerKey
                        consumerSecret: kTwitterConsumerSecret
                        ];
        }
    });
    return instance;
}

@end
