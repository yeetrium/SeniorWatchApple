//
//  ViewController.m
//  SeniorWatch
//
//  Created by Nestor Zepeda on 1/9/15.
//  Copyright (c) 2015 Nestor Zepeda. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkIfUserIsLoggedIn];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)checkIfUserIsLoggedIn
{
    //checks to see if User is currently logged in
    if([PFUser currentUser] != nil){
        [self performSegueWithIdentifier:@"Landing to Main" sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
