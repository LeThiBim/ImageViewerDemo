//
//  NSObject+Utilities.h
//  ImageViewerDemo
//
//  Created by Nguyen Quang Huy on 1/12/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Utilities)

+ (NSString*) getUUID;
+ (void) showAlertWithTitle:(NSString*) title andMessage:(NSString*) message;


+ (void) setConstraintWidthForAlbumCellWithValue:(float) value;
+ (float) getConstraintWidthForAlbumCell;

+ (CGRect) getScreenFrameForOrientation;

+ (float) getScreenWidthForOrientation;
+ (float) getScreenHeightForOrientation;


+ (void) showWaitingAlert;
+ (void) hideWaitingAlert;

@end