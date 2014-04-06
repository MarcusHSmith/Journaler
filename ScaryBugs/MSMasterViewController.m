//
//  MSMasterViewController.m
//  Journaler
//
//  Created by Marcus Smith on 4/5/14.
//  Copyright (c) 2014 Marcus Smith. All rights reserved.
//

#import "MSMasterViewController.h"
#import "MSDetailViewController.h"
#import "MSJournalerDoc.h"
#import "MSJournalerData.h"
#import "IPAddress.h"
#import <Parse/Parse.h>

@interface MSMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MSMasterViewController

@synthesize bugs = _bugs;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    NSLog(@"CURRENT USER %@", [PFUser currentUser]);
//    [PFUser logOut];
    NSLog(@"CURRENT USER %@", [PFUser currentUser]);
    if ([PFUser currentUser]) {
        NSLog(@"PULL DOWN");
        //[self createBug];
        [self pullDown];
        
    }
    else{
        NSLog(@"CreateUser");
        [self createUser];
        
    }
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    //Change the Title
    self.title = @"Posts";
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self action:@selector(addTapped:)];
}

- (NSString *) macAddress{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    int i;
    NSString *deviceIP = nil;
    for (i=0; i<MAXADDRS; ++i)
    {
        static unsigned long localHost = 0x7F000001;        // 127.0.0.1
        unsigned long theAddr;
        
        theAddr = ip_addrs[i];
        
        if (theAddr == 0) break;
        if (theAddr == localHost) continue;
        
        NSLog(@"Name: %s MAC: %s IP: %s\n", if_names[i], hw_addrs[i], ip_names[i]);
        NSLog(@"i = %i", i);
        if (i == 1){
            NSString *product = [NSString stringWithFormat:@"%s", hw_addrs[i]];
            NSLog(@"Username is %@", product);
            return product;
        }
        //decided what adapter you want details for
        if (strncmp(if_names[i], "en", 2) == 0)
        {
            NSLog(@"Adapter en has a IP of %s", ip_names[i]);
        }
    }
    return @"unfound mac address";
}

-(void)createUser{
    NSLog(@"CREATE NEW USER");
    PFUser *user = [PFUser user];
    user.username = [self macAddress];
    user.password = @"mypass";
    //user.email = @"email@example.com";
    // other fields can be set just like with PFObject
    //user[@"phone"] = @"415-392-0202";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //        //user defaults
    //        [defaults setObject:firstName forKey:@"firstName"];
    //        [defaults synchronize];
    //        NSLog(@"Data saved");
    //        //user defaults
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //[self createBug];
            // Hooray! Let them use the app now.
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
        }
    }];
}


-(void)pullDown{
    NSMutableArray *bugs = [NSMutableArray arrayWithObjects: nil];
    //NSMutableArray *bugs = [NSMutableArray arrayWithObjects: nil];
    PFQuery *queryJournal = [PFQuery queryWithClassName:@"Post"];
    [queryJournal whereKey:@"user" equalTo:[PFUser currentUser]];
    [queryJournal findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (!error) {
            // The find succeeded.
            //NSLog(@"Successfully retrieved %@ Posts.", posts);
            // Do something with the found objects
            
            for (PFObject *object in posts) {
                int rating = object[@"Rating"];
                PFFile *fileObject = object[@"imageFile"];
                [fileObject getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        
                        UIImage *image = [UIImage imageWithData:data];
                        
                        // UIImage *image = [UIImage imageNamed:@"Marcus.jpg"];
                        MSJournalerDoc *post = [[MSJournalerDoc alloc] initWithTitle:object[@"Title"] rating:0 thumbImage:image fullImage:image content:object[@"Content"]];
                        
                        
                        [bugs addObject:post];
                        [self.tableView reloadData];
                    }
                }];
                
            }
            NSLog(@"THE LIST: %@", bugs);
            self.bugs = bugs;
            NSLog(@"END OF LOOOOOOOOOOOOOOOPS %lu", bugs.count);
            [self.tableView reloadData];
            
            //[self.tableView setNeedsDisplay];
            NSLog(@"MOAR");
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
    
    
}



-(void)createBug{
    UIImage *image = [UIImage imageNamed:@"Marcus.jpg"];
    NSString *imageName = @"Marcus.jpg";
    NSData* data = UIImageJPEGRepresentation(image, 1.0f);
    PFFile *imageFile = [PFFile fileWithName:imageName data:data];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *post = [PFObject objectWithClassName:@"Post"];
            [post setObject:imageFile forKey:@"imageFile"];
            
            // Set the access control list to current user for security purposes
            post.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            PFUser *user = [PFUser currentUser];
            [post setObject:user forKey:@"user"];
            post[@"Title"] = @"Marcus";
            post[@"Rating"] = @ 1;
            post[@"Photo"] = @"Marcus.jpg";
            post[@"Content"] = @"MARCUS's FIRST JOURNAL POST";
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"no error, Succeeded!");
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"TABLE COUNT %lu", self.bugs.count);
    return _bugs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"MyBasicCell"];
    MSJournalerDoc *bug = [self.bugs objectAtIndex:indexPath.row];
    cell.textLabel.text = bug.data.title;
    cell.imageView.image = bug.thumbImage;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_bugs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


-(void)didMoveToParentViewController:(UIViewController *)parent{
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MSDetailViewController *detailController = segue.destinationViewController;
    MSJournalerDoc *bug = [self.bugs objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    detailController.detailItem = bug;
}

- (void)addTapped:(id)sender {
    MSJournalerDoc *newDoc = [[MSJournalerDoc alloc] initWithTitle:@"New Post Title" rating:0 thumbImage:nil fullImage:[UIImage imageNamed:@"new.jpg"] content:@"Your Post Content Here" ];
    
    [_bugs addObject:newDoc];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_bugs.count-1 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:YES];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self performSegueWithIdentifier:@"MySegue" sender:self];
}

@end