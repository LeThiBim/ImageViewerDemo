//
//  AlbumViewController.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/23/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumSource.h"
#import "MWPhotoBrowser.h"

@interface AlbumViewController : UICollectionViewController <GetAlbumSourceDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) AlbumSource *albumSource;

@end
