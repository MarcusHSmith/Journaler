//
//  MSJournalerDoc.h
//  Journaler
//
//  Created by Marcus Smith on 4/5/14.
//  Copyright (c) 2014 Marcus Smith. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MSJournalerData;

@interface MSJournalerDoc : NSObject

@property (strong) MSJournalerData *data;
@property (strong) UIImage *thumbImage;
@property (strong) UIImage *fullImage;
@property (strong) NSString *content;
@property (strong) NSString *hash;
@property (strong) NSString *cat;
@property (strong) NSString *objectId;


- (id)initWithTitle:(NSString*)title rating:(float)rating thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage content:(NSString *)content hash:(NSString*)hash cat:(NSString*)cat;
- (id)initNewWithTitle:(NSString*)title rating:(float)rating thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage content:(NSString *)content cat:(NSString*)cat;
- (id)initNewUploadWithTitle:(NSString*)title rating:(float)rating fullImage:(UIImage *)fullImage content:(NSString *)content cat:(NSString*)cat;


@end