//
//  GetAlbumSource.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/23/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import "GetAlbumSource.h"
#import "AFAppDotNetAPIClient.h"

@interface GetAlbumSource()

@end

@implementation GetAlbumSource

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

- (NSURL*) getImageURLOfIndex:(NSInteger)index
{
    NSDictionary* item = (NSDictionary*) [self.imageList objectAtIndex:index];
    NSString* imageLink = [item objectForKey:@"url"];
    NSURL *imageURL = [NSURL URLWithString:imageLink];
    
    return imageURL;
}


- (void) getImageLinksFromServer
{
    
    [[AFAppDotNetAPIClient sharedClient] GET:[NSString stringWithFormat:@"api/post/%@", self.albumId]
                                  parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON)
     {
         
         self.imageList = [JSON objectForKey:@"pictures"];
         
         NSLog(@" DATA : %@", self.imageList);
         
         if (self.delegate)
         {
             dispatch_async(dispatch_get_main_queue(),
                            ^{
                                [self.delegate performSelector:@selector(finishGetImageLinksFromServer) withObject:nil];
                            });
             
             
         }
         
     } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
         
     }];
    
}


@end
