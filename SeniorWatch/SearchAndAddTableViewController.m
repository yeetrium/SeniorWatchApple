//
//  SearchAndAddTableViewController.m
//  SeniorWatch
//
//  Created by Nestor Zepeda on 1/10/15.
//  Copyright (c) 2015 Nestor Zepeda. All rights reserved.
//

#import "SearchAndAddTableViewController.h"
#import <Parse/Parse.h>
@interface SearchAndAddTableViewController ()

@property (strong, nonatomic) NSMutableArray *userIDArray;
@property (nonatomic) int index;

@end

@implementation SearchAndAddTableViewController

//lazy intantiation
-(NSMutableArray *)patientsArray
{
    if(!_patientsArray){
        _patientsArray  = [[NSMutableArray alloc]init];
    }
    return _patientsArray;
}

-(NSMutableArray *)userIDArray{
    if(!_userIDArray){
        _userIDArray = [[NSMutableArray alloc]init];
    }
    
    return _userIDArray;
}

-(NSMutableArray *)searchResults
{
    if(!_searchResults){
        _searchResults = [[NSMutableArray alloc]init];
    }
    
    return _searchResults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup
-(void)setup
{
        PFQuery *queryForPatients = [PFQuery queryWithClassName:@"Patient"];
        [queryForPatients whereKey:@"paired" equalTo:@"0"];
        
        //query for patients
        [queryForPatients findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            self.searchResults = [objects mutableCopy];
           
            for(int i = 0; i < self.searchResults.count; i++){
                NSLog(@"%@", self.searchResults[i][@"userID"]);
                [self.userIDArray addObject:self.searchResults[i][@"userID"]];
                
            }
            
            PFQuery *queryForUsers = [PFQuery queryWithClassName:@"_User"];
            [queryForUsers whereKey:@"objectId" containedIn:self.userIDArray];
            
            [queryForUsers findObjectsInBackgroundWithBlock:^(NSArray *objects2, NSError *error) {
                
                self.patientsArray = [objects2 mutableCopy];
                [self.tableView reloadData];
            }];

            
        }];
    

    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return [self.patientsArray count];
}

#pragma mark - Search Methods


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    self.searchResults = [[self.patientsArray filteredArrayUsingPredicate:predicate]mutableCopy];
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.searchResults removeAllObjects];
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    
    return YES;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Patient Cell" forIndexPath:indexPath];
    self.patient = self.patientsArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.patient[@"firstName"], self.patient[@"lastName"]];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.index = indexPath.row;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Are you sure you want to add %@ %@ to your patients?", self.patientsArray[indexPath.row][@"firstName"], self.patientsArray[indexPath.row][@"lastName"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        //user click yes, add patients object id to array of patients, switch patients paired value to 1
        PFUser *updatedPatient = self.patientsArray[self.index];
        
        PFQuery *queryForTheUser = [PFQuery queryWithClassName:@"Patient"];
        [queryForTheUser whereKey:@"userID" equalTo:updatedPatient.objectId];
        
        [queryForTheUser getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            [object setObject:@"1" forKey:@"paired"];
            [object setObject:[PFUser currentUser] forKey:@"caretaker"];
            [object setObject:[PFUser currentUser].objectId forKey:@"caretakerID"];
            [object saveInBackground];
        }];
        
        PFQuery *queryMyself = [PFQuery queryWithClassName:@"Caretaker"];
        
        [queryMyself whereKey:@"user" equalTo:[PFUser currentUser]];
        
        [queryMyself getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            [object[@"patients"] addObject:updatedPatient.objectId];
            [object saveInBackground];
        }];
        
        
        
        
    }
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
