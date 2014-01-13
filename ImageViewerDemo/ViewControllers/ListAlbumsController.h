//
//  ViewController.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/19/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListAlbumsSource.h"
#import "MSNavigationPaneViewController.h"

@interface ListAlbumsController : UICollectionViewController <ListAlbumsSourceDelegate>

@property (nonatomic, strong) ListAlbumsSource *dataSource;
@property (nonatomic, weak) MSNavigationPaneViewController *navigationPaneViewController;

- (void) adjustContentInsetForLegacy;
- (void) setUpCustomLayOut;
@end
