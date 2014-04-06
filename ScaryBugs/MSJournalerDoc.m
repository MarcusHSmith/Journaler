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

@implementation MSJournalerDoc
@synthesize data = _data;
@synthesize thumbImage = _thumbImage;
@synthesize fullImage = _fullImage;
@synthesize content = _content;


- (id)initWithTitle:(NSString*)title rating:(float)rating thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage content:(NSString *)content
{
    NSLog(@"POST %@  with %@", title, content);
    if ((self = [super init])) {
        self.data = [[MSJournalerData alloc] initWithTitle:title rating:rating];
        self.thumbImage = [fullImage imageByScalingAndCroppingForSize:CGSizeMake(44, 44)];
        self.fullImage = fullImage;
        self.content = content;
    }
    return self;
}

- (id)initNewWithTitle:(NSString*)title rating:(float)rating thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage content:(NSString *)content
{
        NSLog(@"NEW POST %@  with %@", title, content);
    if ((self = [super init])) {
        self.data = [[MSJournalerData alloc] initWithTitle:title rating:rating];
        self.thumbImage = [fullImage imageByScalingAndCroppingForSize:CGSizeMake(44, 44)];
        self.fullImage = fullImage;
        self.content = content;
    }
    //
    
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
            post.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            PFUser *user = [PFUser currentUser];
            [post setObject:user forKey:@"user"];
            NSLog(@"TITTITTT = %@", title);
            post[@"Title"] = title;
            post[@"Rating"] = @ 1;
            post[@"Photo"] = title;
            post[@"Content"] = content;
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

- (id)initNewUploadWithTitle:(NSString*)title rating:(float)rating fullImage:(UIImage *)fullImage content:(NSString *)content
{
    NSLog(@"NEW UPLOAD %@  with %@", title, content);

    
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
            post.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            PFUser *user = [PFUser currentUser];
            [post setObject:user forKey:@"user"];
            NSLog(@"TITTITTT = %@", title);
            post[@"Title"] = title;
            post[@"Rating"] = @ 1;
            post[@"Photo"] = title;
            post[@"Content"] = content;
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
