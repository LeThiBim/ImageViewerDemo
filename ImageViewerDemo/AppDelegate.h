//
//  AppDelegate.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/19/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListAlbumsSource.h"
#import "ListAlbumsController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readwrite) ListAlbumsSource *listAlbumSource;

@property (strong, nonatomic) UINavigationController* listAlbumController;


@property (assign, nonatomic) int currentMainScreenIndex;
@end
