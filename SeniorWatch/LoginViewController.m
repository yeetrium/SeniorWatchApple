//
//  LoginViewController.m
//  SeniorWatch
//
//  Created by Nestor Zepeda on 1/9/15.
//  Copyright (c) 2015 Nestor Zepeda. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

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

#pragma mark - IBActions
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    [PFUser logInWithUsernameInBackground:self.emailField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
        if(!error){
            [self performSegueWithIdentifier:@"Login to Main" sender:nil];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Your credentials were incorrect. Try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

@end
