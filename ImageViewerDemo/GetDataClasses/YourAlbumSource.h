//
//  YourAlbumSource.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 1/13/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetYourAlbumSourceDelegate <NSObject>

- (void) finishGetYourAlbumFromServerSuccessful;
- (void) finishGetYourAlbumFromServerFailed;

@end


@interface YourAlbumSource : NSObject

@property (assign, nonatomic) id <GetYourAlbumSourceDelegate> delegate;
@property (strong, nonatomic) NSArray* imageList;


- (void) getYourAlbumFromServer;
@end
