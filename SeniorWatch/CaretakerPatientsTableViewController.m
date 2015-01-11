//
//  CaretakerPatientsTableViewController.m
//  SeniorWatch
//
//  Created by Nestor Zepeda on 1/10/15.
//  Copyright (c) 2015 Nestor Zepeda. All rights reserved.
//

#import "CaretakerPatientsTableViewController.h"
#import <Parse/Parse.h>

@interface CaretakerPatientsTableViewController ()

@property (strong, nonatomic) NSMutableArray *myPatients;
@property (strong, nonatomic) NSMutableArray *patientObjects;

@end

@implementation CaretakerPatientsTableViewController

-(NSMutableArray *)myPatients
{
    if(!_myPatients){
        _myPatients = [[NSMutableArray alloc]init];
    }
    return _myPatients;
    
}

-(NSMutableArray *)patientObjects
{
    if(!_patientObjects){
        _patientObjects = [[NSMutableArray alloc]init];
    }
    return _patientObjects;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPatients];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source
-(void)getPatients
{
    //get patients array from caretaker class
    PFQuery *queryForMyPatients = [PFQuery queryWithClassName:@"Caretaker"];
    [queryForMyPatients whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [queryForMyPatients getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.myPatients = object[@"patients"];
        NSLog(@"%@", self.myPatients);
        [self.tableView reloadData];
    }];
    
    //query the user class in order to get full patient objects //
    PFQuery *queryForUsers = [PFQuery queryWithClassName:@"_User"];
    [queryForUsers whereKey:@"objectId" containedIn:self.myPatients];
    
    [queryForUsers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.patientObjects = [objects mutableCopy];
        [self.tableView reloadData];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.myPatients count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"My Patient Cell" forIndexPath:indexPath];
    
    PFObject *patient = self.patientObjects[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", patient[@"firstName"], patient[@"lastName"]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
