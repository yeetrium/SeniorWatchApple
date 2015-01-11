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
@property (strong, nonatomic) IBOutlet UITextField *messageField;

@end

@implementation LoggedInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.connectedWatch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *watch, NSDictionary *update) {
        NSLog(@"Received message: %@", update);
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"New Message" message:[NSString stringWithFormat:@"%@", update] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        return YES;
    }];
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
    //get property from our app delegate
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.messageSent = @{ @(0):[NSNumber numberWithUint8:42],
                              @(1):self.messageField.text };
    self.connectedWatch = myDelegate.connectedWatch;
    
    //send our message
    [self.connectedWatch appMessagesPushUpdate:self.messageSent onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        if (!error) {
            NSLog(@"Successfully sent message.");
        }
        else {
            NSLog(@"Error sending message: %@", error);
        }
    }];
    
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
