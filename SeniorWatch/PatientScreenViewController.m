//
//  PatientScreenViewController.m
//  SeniorWatch
//
//  Created by Nestor Zepeda on 1/10/15.
//  Copyright (c) 2015 Nestor Zepeda. All rights reserved.
//

#import "PatientScreenViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import <PebbleKit/PebbleKit.h>

@interface PatientScreenViewController ()

@property (strong, nonatomic) NSMutableArray *myTasksArray;
@property (strong, nonatomic) NSDictionary *messageSent;
@property (strong, nonatomic) PBWatch *connectedWatch;

@end

@implementation PatientScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMyTasks];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getMyTasks
{
    PFUser *user = [PFUser currentUser];
    
    PFQuery *queryForTasks = [PFQuery queryWithClassName:@"Tasks"];
    [queryForTasks whereKey:@"toWhichUser" equalTo:(NSString *)user.objectId];
    
    [queryForTasks findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.myTasksArray = [objects mutableCopy];
            NSLog(@"%lu", (unsigned long)objects.count);
            
    
           [self sendTasksToWatch];
        }
        else{
            //handle error
        }
    }];

}

-(void)sendTasksToWatch
{
    //get property from our app delegate
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    NSMutableArray *taskNames = [[NSMutableArray alloc]init];
    for(int i = 0; i < self.myTasksArray.count; i++){
        [taskNames addObject:self.myTasksArray[i][@"name"]];
        NSLog(self.myTasksArray[i][@"name"]);
    }
    
    [taskNames addObject:@"Cool"];
    
   // NSDictionary *tasks = [[NSDictionary alloc]initWithObjects:taskNames forKeys:@[@"4",@"5"]];
    NSDictionary *tasks = [[NSDictionary alloc]initWithObjects:taskNames forKeys:@[@(4),@(5), @(6)]];
    //NSLog(@"%@", tasks);
    
//    NSError *error;
//    NSData *jsonData = [[NSData alloc]init];
//    NSString *jsonString;
//    jsonData = [NSJSONSerialization dataWithJSONObject:tasks
//                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//                                                         error:&error];
//    if (!jsonData) {
//        NSLog(@"Got an error: %@", error);
//    } else {
//        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"Data: %@", [NSString stringWithFormat:@"%@\0", jsonString]);
//    }
//    
//    self.messageSent = @{ @(0):[NSNumber numberWithUint8:255],
//                             @(4): jsonString};
    self.messageSent = tasks;
    
    self.connectedWatch = myDelegate.connectedWatch;
        
        //send our message
    
        
    [self.connectedWatch appMessagesPushUpdate:self.messageSent onSent:^(PBWatch *watch, NSDictionary *update, NSError *error){
        if (!error) {
            NSLog(@"Successfully sent message.");
        }
        else {
            NSLog(@"Error sending message: %@", error);
        }
    }];
    
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
