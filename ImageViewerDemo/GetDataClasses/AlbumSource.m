//
//  GetAlbumSource.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/23/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import "AlbumSource.h"
#import "AFAppDotNetAPIClient.h"
#import "APIService.h"
#import "UIImageView+WebCache.h"

@interface AlbumSource()

@end

@implementation AlbumSource

- (instancetype) init {
    self = [super init];
    if (self) {
               
    }
    return self;
}

- (void) dealloc
{
    _data = nil;
    _imageList = nil;
    _delegate  = nil;
    _albumId   = nil;
    
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    
    if (self.imageList)
        return [self.imageList count];
    return 0;
}

- (NSString*) getTitleOfIndex:(NSInteger) index
{
    NSDictionary* item = (NSDictionary*) [self.imageList objectAtIndex:index];
    
    NSString* title = [item objectForKey:@"id"];
    
    if (title == nil)
    {
        title = @"Image";
    }
    return title;
    
    
}

- (NSURL*) getThumbImageURLOfIndex:(NSInteger)index
{
    NSDictionary* item = (NSDictionary*) [self.imageList objectAtIndex:index];
    NSString* imageLink = [item objectForKey:@"thumb"];
    NSURL *imageURL = [NSURL URLWithString:imageLink];
    
//    NSString* imageLink1 = [item objectForKey:@"image"];
//    NSURL *imageURL1 = [NSURL URLWithString:imageLink1];
//    
//    UIImageView* tempImage = [[UIImageView alloc] init];
//    [tempImage setImageWithURL:imageURL1 placeholderImage:[UIImage imageNamed:@"media_app.png"]];
    
    return imageURL;
}

- (NSURL*) getLargeImageURLOfIndex:(NSInteger)index
{
    NSDictionary* item = (NSDictionary*) [self.imageList objectAtIndex:index];
    NSString* imageLink = [item objectForKey:@"image"];
    NSURL *imageURL = [NSURL URLWithString:imageLink];
    
    return imageURL;
}

- (void) getImageLinksFromServer
{
    [APIService getListImageInAlbumWithAlbumId:self.albumId
                                  successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.imageList = [responseObject objectForKey:@"pictures"];

        if (self.delegate)
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [self.delegate performSelector:@selector(finishGetImageLinksFromServerSuccessful) withObject:nil];
                           });
        }

    } failBlock:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self.delegate performSelector:@selector(finishGetImageLinksFromServerFailed) withObject:nil];
                       });

        
    }];
    
}

- (CGSize) getSuitableScaledSizeOfItemAtIndex:(NSInteger) index FromGeneralScaledWith:(float) generalScaledWidth AndGeneralScaledHeight:(float) generalScaledHeight
{
    CGSize sizeResult = CGSizeZero;
    
    NSDictionary* item  = (NSDictionary*) [self.imageList objectAtIndex:index];
    
    NSString* widthStr  = [item objectForKey:@"width"];
    NSString* heightStr = [item objectForKey:@"height"];
    
    float realWidth  = [widthStr floatValue];
    float realHeight = [heightStr floatValue];
    
    
    sizeResult.width  = generalScaledWidth;
    sizeResult.height = realHeight*generalScaledWidth/realWidth;
    
    if (sizeResult.height > generalScaledHeight)
    {
        sizeResult.width  = realWidth*generalScaledHeight/realHeight;
        sizeResult.height = generalScaledHeight;
    }
    
    return sizeResult;

}


@end
