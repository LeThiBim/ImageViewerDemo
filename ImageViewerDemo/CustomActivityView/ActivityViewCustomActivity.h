//
//  ActivityViewCustomActivity.h
//  ImageViewerDemo
//
//  Created by Nguyen Quang Huy on 1/7/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhoto.h"
#import "NSObject+Utilities.h"

@interface ActivityViewCustomActivity : UIActivity

@property (weak, nonatomic) UIActivityViewController* activityViewController;
@property (weak, nonatomic) MWPhoto* photo;

@end
