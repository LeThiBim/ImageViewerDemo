//
//  GetAlbumSource.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/23/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetAlbumSourceDelegate <NSObject>

- (void) finishGetImageLinksFromServer;

@end


@interface AlbumSource : NSObject <UIStateRestoring>

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSArray* imageList;

@property (assign, nonatomic) id <GetAlbumSourceDelegate> delegate;
@property (strong, nonatomic) NSString* albumId;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString*)       getTitleOfIndex:(NSInteger) index;
- (NSURL*)       getImageURLOfIndex:(NSInteger)index;

- (void) getImageLinksFromServer;

@end
