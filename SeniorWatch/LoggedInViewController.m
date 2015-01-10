//
//  LoggedInViewController.m
//  SeniorWatch
//
//  Created by Nestor Zepeda on 1/9/15.
//  Copyright (c) 2015 Nestor Zepeda. All rights reserved.
//

#import "LoggedInViewController.h"
#import <Parse/Parse.h>
#import <PebbleKit/PebbleKit.h>
#import "AppDelegate.h"


@interface LoggedInViewController ()

@property (strong, nonatomic) NSDictionary *messageSent;
@property (strong, nonatomic) PBWatch *connectedWatch;

@end

@implementation LoggedInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (IBAction)logOutButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
       [PFUser logOut];
    }];
}
- (IBAction)sendMessageButtonPressed:(UIButton *)sender
{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.messageSent = @{ @(0):[NSNumber numberWithUint8:42],
                              @(1):@"Yo lol" };
    self.connectedWatch = myDelegate.connectedWatch;
    
    [self.connectedWatch appMessagesPushUpdate:self.messageSent onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        if (!error) {
            NSLog(@"Successfully sent message.");
        }
        else {
            NSLog(@"Error sending message: %@", error);
        }
    }];
    
}

@end
