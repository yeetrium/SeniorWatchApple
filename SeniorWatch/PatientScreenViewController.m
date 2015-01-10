//
//  PatientScreenViewController.m
//  SeniorWatch
//
//  Created by Nestor Zepeda on 1/10/15.
//  Copyright (c) 2015 Nestor Zepeda. All rights reserved.
//

#import "PatientScreenViewController.h"
#import <Parse/Parse.h>

@interface PatientScreenViewController ()

@end

@implementation PatientScreenViewController

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
- (IBAction)logoutButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [PFUser logOut];
    }];
}

@end
