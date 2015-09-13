//
//  LoginViewController.m
//  ios-twitter-clone
//
//  Created by Mary Xia on 9/12/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken]; // can get 401 if you havent logged out previously

    [[TwitterClient sharedInstance]
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
     }
    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
