//
//  CustomCollectionViewLayout.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 1/2/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (assign, nonatomic) float totalHeight;

@property (assign, nonatomic) float contentSizeWith;

@property (assign, nonatomic) int columnCount;

@end
