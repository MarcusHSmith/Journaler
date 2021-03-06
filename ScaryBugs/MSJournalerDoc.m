//
//  MSJournalerDoc.m
//  Journaler
//
//  Created by Marcus Smith on 4/5/14.
//  Copyright (c) 2014 Marcus Smith. All rights reserved.
//

#import "MSJournalerDoc.h"
#import "MSJournalerData.h"
#import "MSUIImageExtras.h"
#import <Parse/Parse.h>
#include <stdlib.h>

@implementation MSJournalerDoc
@synthesize data = _data;
@synthesize thumbImage = _thumbImage;
@synthesize fullImage = _fullImage;
@synthesize content = _content;
@synthesize hash = _hash;
@synthesize cat = _cat;
@synthesize count = _count;
@synthesize objectId = _objectId;

- (id)initWithTitle:(NSString*)title rating:(float)rating thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage content:(NSString *)content hash:(NSString*)hash cat:(NSString*)cat
{
    if ((self = [super init])) {
        self.data = [[MSJournalerData alloc] initWithTitle:title rating:rating];
        self.thumbImage = [fullImage imageByScalingAndCroppingForSize:CGSizeMake(44, 44)];
        self.fullImage = fullImage;
        self.content = content;
        self.hash = hash;
        self.cat = cat;
        self.count = @"2";
    }
    return self;
}

- (id)initNewWithTitle:(NSString*)title rating:(float)rating thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage content:(NSString *)content cat:(NSString*)cat
{
    NSString *hash_holder = 0;
    if ((self = [super init])) {
        self.data = [[MSJournalerData alloc] initWithTitle:title rating:rating];
        self.thumbImage = [fullImage imageByScalingAndCroppingForSize:CGSizeMake(44, 44)];
        self.fullImage = fullImage;
        self.content = content;
        hash_holder = [[NSString alloc ] initWithFormat:@"%d", arc4random()];
        self.hash = hash_holder;
        self.cat = cat;
        self.count = @"1";
    }
    UIImage *image = fullImage;
    NSString *imageName = title;
    NSData* data = UIImageJPEGRepresentation(image, 1.0f);
    PFFile *imageFile = [PFFile fileWithName:imageName data:data];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *post = [PFObject objectWithClassName:@"Post"];
            [post setObject:imageFile forKey:@"imageFile"];
            
            // Set the access control list to current user for security purposes
            if([cat isEqualToString:@"1"]){
                post[@"User"] = [PFUser currentUser];
            }
            post[@"Title"] = title;
            post[@"Rating"] = @ 1;
            post[@"Photo"] = title;
            post[@"Content"] = content;
            post[@"Cat"] = cat;
            post[@"Hash"] =  hash_holder;
            post[@"Count"] = @"1";
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
    
//
    
    return self;
}

- (id)initNewUploadWithTitle:(NSString*)title rating:(float)rating fullImage:(UIImage *)fullImage content:(NSString *)content cat:(NSString*)cat
{
    UIImage *image = fullImage;
    NSString *imageName = title;
    NSData* data = UIImageJPEGRepresentation(image, 1.0f);
    PFFile *imageFile = [PFFile fileWithName:imageName data:data];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *post = [PFObject objectWithClassName:@"Post"];
            [post setObject:imageFile forKey:@"imageFile"];
            // Set the access control list to current user for security purposes
            if([cat isEqualToString:@"1"]){
                post[@"User"] = [PFUser currentUser];
            }
            post[@"Title"] = title;
            post[@"Rating"] = @ 1;
            post[@"Photo"] = title;
            post[@"Content"] = content;
            post[@"Cat"] = cat;
            post[@"Count"] = @"2";
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
    
    //
    
    return self;
}


@end
