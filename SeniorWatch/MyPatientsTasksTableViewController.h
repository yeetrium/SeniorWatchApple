//
//  MyPatientsTasksTableViewController.h
//  SeniorWatch
//
//  Created by Nestor Zepeda on 1/11/15.
//  Copyright (c) 2015 Nestor Zepeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MyPatientsTasksTableViewController : UITableViewController

@property(strong, nonatomic) PFObject *patient;

@end
