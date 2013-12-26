//
//  ViewController.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/19/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"

@interface ViewController : UICollectionViewController <DataSourceDelegate>
@property (nonatomic, strong) DataSource *dataSource;
@end
