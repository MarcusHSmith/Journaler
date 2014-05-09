//
//  MSDetailViewController.h
//  Journaler
//
//  Created by Marcus Smith on 4/5/14.
//  Copyright (c) 2014 Marcus Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSJournalerDoc;

@interface MSDetailViewController : UIViewController <UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UINavigationBarDelegate, UITextViewDelegate>

@property (strong, nonatomic) MSJournalerDoc *detailItem;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImagePickerController *picker;

//Functions

- (IBAction)addPictureTapped:(id)sender;
- (IBAction)titleFieldTextChanged:(id)sender;
- (IBAction)contentviewTextChanged:(id)sender;

@end
