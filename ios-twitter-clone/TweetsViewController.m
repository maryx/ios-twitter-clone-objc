//
//  TweetsViewController.m
//  ios-twitter-clone
//
//  Created by Mary Xia on 9/12/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"

@interface TweetsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@end

@implementation TweetsViewController

- (IBAction)onLogout:(id)sender {
    NSLog(@"logging out");
    [User logout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion: ^(NSArray *tweets, NSError *error) {
        for (Tweet *tweet in tweets) {
            NSLog(@"text %@", tweet.text);
            _tweetLabel.text = tweet.text;
        }
    }
     ];
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
