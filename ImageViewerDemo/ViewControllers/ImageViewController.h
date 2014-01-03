//
//  ImageViewController.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/23/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumSource.h"

@interface ImageViewController : UIViewController

@property (assign, nonatomic) NSInteger currentImageIndex;
@property (strong, nonatomic) AlbumSource* albumSource;


- (void) loadImages;
@end
