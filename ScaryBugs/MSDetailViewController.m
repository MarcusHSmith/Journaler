//
//  MSDetailViewController.m
//  Journaler
//
//  Created by Marcus Smith on 4/5/14.
//  Copyright (c) 2014 Marcus Smith. All rights reserved.
//

#import "MSDetailViewController.h"
#import "MSJournalerDoc.h"
#import "MSJournalerData.h"
#import "MSUIImageExtras.h"
#import "SVProgressHUD.h"
#import <Parse/Parse.h>

@interface MSDetailViewController ()
- (IBAction)Submit:(id)sender;
- (void)configureView;
@end

@implementation MSDetailViewController

@synthesize picker = _picker;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self configureView];
    }
}

- (IBAction)Submit:(id)sender {
    NSLog(@"SUBMIT");
    NSLog(@"%@", self.detailItem.data.title);
    NSLog(@"%@", self.detailItem.data.rating);
    NSLog(@"%@", self.detailItem.content);
    [[MSJournalerDoc alloc] initNewUploadWithTitle:self.detailItem.data.title rating:self.detailItem.data.rating fullImage:self.detailItem.fullImage content: self.detailItem.content];
}



- (void)configureView
{
    // Update the user interface for the detail item.
    self.rateView.notSelectedImage = [UIImage imageNamed:@"shockedface2_empty.png"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"shockedface2_half.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"shockedface2_full.png"];
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    if (self.detailItem) {
        self.titleField.text = self.detailItem.data.title;
        self.content.text = self.detailItem.content;
        self.rateView.rating = self.detailItem.data.rating;
        self.imageView.image = self.detailItem.fullImage;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation {
    return YES;
}

- (IBAction)titleFieldTextChanged:(id)sender {
    self.detailItem.data.title = self.titleField.text;
    NSString *hash = self.detailItem.hash;
    NSString *title = self.titleField.text;
        NSMutableArray *bugs = [NSMutableArray arrayWithObjects: nil];
        PFQuery *queryJournal = [PFQuery queryWithClassName:@"Post"];
        [queryJournal whereKey:@"Hash" equalTo: hash];
        [queryJournal getFirstObjectInBackgroundWithBlock:^(PFObject * reportStatus, NSError *error)        {
        if (!error) {
            [reportStatus setObject:title forKey:@"Title"];
            [reportStatus saveInBackground];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (IBAction)contentFieldTextChanged:(id)sender {
    self.detailItem.content = self.content.text;
    NSString *hash = self.detailItem.hash;
    NSString *content = self.content.text;
    NSMutableArray *bugs = [NSMutableArray arrayWithObjects: nil];
    PFQuery *queryJournal = [PFQuery queryWithClassName:@"Post"];
    [queryJournal whereKey:@"Hash" equalTo: hash];
    [queryJournal getFirstObjectInBackgroundWithBlock:^(PFObject * reportStatus, NSError *error)        {
        if (!error) {
            [reportStatus setObject:content forKey:@"Content"];
            [reportStatus saveInBackground];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark MSRateViewDelegate

- (void)rateView:(MSRateView *)rateView ratingDidChange:(float)rating {
    self.detailItem.data.rating = rating;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPictureTapped:(id)sender {
    if (self.picker == nil) {
        
        // 1) Show status
        [SVProgressHUD showWithStatus:@"Loading picker..."];
        
        // 2) Get a concurrent queue form the system
        dispatch_queue_t concurrentQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        // 3) Load picker in background
        dispatch_async(concurrentQueue, ^{
            
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.delegate = self;
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.picker.allowsEditing = NO;
            
            // 4) Present picker in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:_picker animated:YES completion:nil];
                [SVProgressHUD dismiss];
            });
            
        });
        
    }  else {
        [self presentViewController:_picker animated:YES completion:nil];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *fullImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 1) Show status
    [SVProgressHUD showWithStatus:@"Resizing image..."];
    
    // 2) Get a concurrent queue form the system
    dispatch_queue_t concurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 3) Resize image in background
    dispatch_async(concurrentQueue, ^{
        
        UIImage *thumbImage = [fullImage imageByScalingAndCroppingForSize:CGSizeMake(44, 44)];
        
        // 4) Present image in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            self.detailItem.fullImage = fullImage;
            self.detailItem.thumbImage = thumbImage;
            self.imageView.image = fullImage;
            [SVProgressHUD dismiss];
        });
        
    });
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
