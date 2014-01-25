//
//  CustomCollectionViewLayout.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 1/2/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListAlbumsSource.h"

@interface CustomCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (assign, nonatomic) float contentSizeWith;
@property (assign, nonatomic) int columnCount;

@property (assign, nonatomic) ListAlbumsSource* listAlbumSource;


- (instancetype) initWithDataSource:(ListAlbumsSource*) dataSource;

@end
