//
//  SearchAndAddTableViewController.h
//  SeniorWatch
//
//  Created by Nestor Zepeda on 1/10/15.
//  Copyright (c) 2015 Nestor Zepeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface SearchAndAddTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) NSMutableArray *patientsArray;

@property (strong, nonatomic) PFUser *patient;



@end
