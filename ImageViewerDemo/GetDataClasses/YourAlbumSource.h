//
//  YourAlbumSource.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 1/13/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetYourAlbumSourceDelegate <NSObject>

- (void) finishGetYourAlbumFromServer;

@end


@interface YourAlbumSource : NSObject

@property (assign, nonatomic) id <GetAlbumSourceDelegate> delegate;
@property (strong, nonatomic) NSMutableArray* photos;
@property (strong, nonatomic) NSArray* yourAlbum;

@end
