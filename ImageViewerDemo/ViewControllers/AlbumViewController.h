//
//  AlbumViewController.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/23/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumSource.h"

@interface AlbumViewController : UICollectionViewController <GetAlbumSourceDelegate>

@property (nonatomic, strong) AlbumSource *albumSource;

@end
