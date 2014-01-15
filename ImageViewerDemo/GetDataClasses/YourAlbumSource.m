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
        
        
        self.imageList = [[DataService sharedInstance] selectAllByContext];
        
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
    IMAGE* image = (IMAGE*) [self.imageList objectAtIndex:index];
    return image.imageId;
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

- (void) getYourAlbumFromServer
{
    
    [APIService getYourAlbumWithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSArray* photosArray = [responseObject objectForKey:@"photos"];
        
        NSLog(@" THE NUMBER OF YOUR PHOTO FROM SERVER : %d", [photosArray count]);
        
        if ([photosArray count] >0)
        {
            [[DataService sharedInstance] deleteAllDataInEntity];

            for (int i = 0; i < [photosArray count]; i++)
            {
                NSDictionary* photoDictionary = (NSDictionary*) [photosArray objectAtIndex:i];
                
                NSManagedObjectContext *managedObjectContext = [[DataService sharedInstance] managedObjectContext];
                IMAGE *image = (IMAGE*) [NSEntityDescription insertNewObjectForEntityForName:@"IMAGE" inManagedObjectContext:managedObjectContext];
                
                image.imageId   = [photoDictionary valueForKey:@"id"];
                
                NSString *cachedFolderPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *cachedImagePath = [cachedFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", image.imageId]];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:cachedImagePath])
                    image.imagePath = cachedImagePath;
                else
                    image.imagePath = [photoDictionary valueForKey:@"url"];
            }
            [[DataService sharedInstance] saveContext];

             self.imageList = [[DataService sharedInstance] selectAllByContext];
            
            if (self.delegate)
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   
                                   [self.delegate performSelector:@selector(finishGetYourAlbumFromServerSuccessful) withObject:nil];
                               });
            }

        }
        
        
       
        
        
    } failBlock:^(NSError *error) {
        
        if (self.delegate)
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               
                               [self.delegate performSelector:@selector(finishGetYourAlbumFromServerFailed) withObject:nil];
                    });
        }
        
    }];
    
}

@end
