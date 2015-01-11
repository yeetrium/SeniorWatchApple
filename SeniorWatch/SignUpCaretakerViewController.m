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

@property (strong, nonatomic) IBOutlet UISwitch *careTakerSwitch;
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;

@property (strong, nonatomic) NSString *userType; //1 for caretaker, 2 for patient

@end

@implementation SignUpCaretakerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.careTakerSwitch setOn:false];
    self.userType = @"2";
    
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
    newUser[@"userType"] = self.userType;
    newUser[@"firstName"] = self.firstNameField.text;
    newUser[@"lastName"] = self.lastNameField.text;
   // newUser[]
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            if([self.userType isEqualToString:@"1"]){
                
                //create a new entry in the caretaker field
                PFObject *newCaretaker = [[PFObject alloc]initWithClassName:@"Caretaker"];
                newCaretaker[@"userID"]= [PFUser currentUser].objectId;
                newCaretaker[@"user"] = [PFUser currentUser];
                newCaretaker[@"patients"] = @[];
                [newCaretaker saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [self performSegueWithIdentifier:@"SignUpC to Main" sender:nil];
                }];
                
                
            }
            else{
                //create a new patient object
                NSLog(@"Added patient!");
                PFObject *newPatient = [[PFObject alloc]initWithClassName:@"Patient"];
                newPatient[@"userID"] = [PFUser currentUser].objectId;
                newPatient[@"paired"] = @"0";
                newPatient[@"user"] = [PFUser currentUser];
                
                
                [newPatient saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [self performSegueWithIdentifier:@"SignUpP to Main" sender:nil];
                }];
                
                
            }
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

- (IBAction)switchPressed:(UISwitch *)sender
{
    if([self.careTakerSwitch isOn]){
        self.userType = @"1";
        
    }
    else{
        self.userType = @"2";
    }
}

#pragma mark - Methods for dismissing keyboard
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


@end
