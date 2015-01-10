//
//  SignUpCaretakerViewController.m
//  SeniorWatch
//
//  Created by Nestor Zepeda on 1/9/15.
//  Copyright (c) 2015 Nestor Zepeda. All rights reserved.
//

#import "SignUpCaretakerViewController.h"
#include <Parse/Parse.h>

@interface SignUpCaretakerViewController ()

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;


@end

@implementation SignUpCaretakerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - Helper Methods
-(void)checkFields //checks to see if any fields are left blank
{
    if([self.nameField.text isEqualToString:@""] || [self.emailField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""] || [self.confirmPassword.text isEqualToString:@""]){
        
        //if any field is left blank, show alert
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"You can't leave any fields blank!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else{
        [self checkPasswords];
    }
}

-(void)checkPasswords //checks to see if passwords are matching
{
    if([self.passwordField.text isEqualToString: self.confirmPassword.text]){
            
        [self signUpUser];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Your passwords dont match!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

-(void)signUpUser
{
    PFUser *newUser = [PFUser user];
    newUser.username = [self.nameField.text lowercaseString];
    newUser.password = self.passwordField.text;
    newUser.email = self.emailField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"You successfully signed up!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Sorry, there was an error!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

#pragma mark - UIButton Actions
- (IBAction)signUpButtonPressed:(UIButton *)sender
{
    [self checkFields];

}


@end
