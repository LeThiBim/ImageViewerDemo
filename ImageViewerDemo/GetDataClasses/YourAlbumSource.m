//
//  YourAlbumSource.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 1/13/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import "YourAlbumSource.h"
#import "APIService.h"
#import "DataService.h"

@implementation YourAlbumSource

- (instancetype) init {
    self = [super init];
    if (self) {
        
        
        
        
    }
    return self;
}

- (void) dealloc
{
    _delegate  = nil;
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
                                                             [self.delegate performSelector:@selector(finishGetImageLinksFromServer) withObject:nil];
                                                         });
                                      }
                                      
                                  } faildBlock:^(NSError *error) {
                                      
                                  }];
    
}


@end
