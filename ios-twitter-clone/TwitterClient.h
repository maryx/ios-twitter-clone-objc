//
//  TwitterClient.h
//  ios-twitter-clone
//
//  Created by Mary Xia on 9/12/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

@end
