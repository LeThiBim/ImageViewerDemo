//
//  YourAlbumViewController.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 1/13/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "MSNavigationPaneViewController.h"

@interface YourAlbumViewController : UICollectionViewController <MWPhotoBrowserDelegate>

@property (nonatomic, weak) MSNavigationPaneViewController *navigationPaneViewController;

@end
