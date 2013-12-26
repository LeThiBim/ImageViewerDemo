//
//  AppDelegate.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/19/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) DataSource *dataSource;

@end
