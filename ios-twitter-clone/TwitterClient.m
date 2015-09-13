//
//  TwitterClient.m
//  ios-twitter-clone
//
//  Created by Mary Xia on 9/12/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"yJ4FZlwxIy2nZ46yQZUXuMU9K";
NSString * const kTwitterConsumerSecret = @"oOl638YG0Ceo4VRHtkAZ41sM3H5uEXEM6cCC6bbUQKepCZNCVL";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";
@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

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

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken]; // can get 401 if you havent logged out previously
    [self
     fetchRequestTokenWithPath:@"oauth/request_token"
     method: @"GET"
     callbackURL: [NSURL URLWithString: @"hammytwitter://oauth"]
     scope: nil
     success: ^(BDBOAuth1Credential *requestToken) {
         NSLog(@"got request token");
         NSURL *authURL = [NSURL URLWithString: [NSString stringWithFormat: @"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
             [[UIApplication sharedApplication] openURL: authURL];
     }
     failure: ^(NSError *error) {
         NSLog(@"failed request token");
         self.loginCompletion(nil, error);
     }];
}

-(void)openURL:(NSURL *)url {
    [self
     fetchAccessTokenWithPath: @"oauth/access_token"
     method: @"POST"
     requestToken: [BDBOAuth1Credential credentialWithQueryString: url.query]
     success: ^(BDBOAuth1Credential *accessToken){
         NSLog(@"got token");
         [self.requestSerializer saveAccessToken: accessToken];
         // Future requests will be authenticated requests
         
         // get user
         [self
          GET:@"1.1/account/verify_credentials.json"
          parameters: nil
          success: ^(AFHTTPRequestOperation *operation, id responseObject) {
              User *user = [[User alloc] initWithDictionary: responseObject];
              [User setCurrentUser:user];
              NSLog(@"current User: %@", user.name);
              self.loginCompletion(user, nil);
          }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"failed to get user");
              self.loginCompletion(nil, error);
          }];
     }
     failure:^(NSError *error){
         NSLog(@"failed token");
     }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    [self
     GET:@"1.1/statuses/home_timeline.json"
     parameters: params
     success: ^(AFHTTPRequestOperation *operation, id responseObject) {
         NSArray *tweets = [Tweet tweetsWithArray:responseObject];
         completion(tweets, nil);
//         for (Tweet *tweet in tweets) {
//              NSLog(@"tweet: %@ created: %@", tweet.text, tweet.createdAt);
//         }
     }
     failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
         completion(nil, error);
     }];
}
@end
