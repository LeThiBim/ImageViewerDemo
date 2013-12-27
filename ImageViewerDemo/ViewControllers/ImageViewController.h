//
//  ImageViewController.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/23/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (assign, nonatomic) NSInteger* currentImage;
@property (strong, nonatomic) NSArray* imageList;


- (void) loadImages;
@end
