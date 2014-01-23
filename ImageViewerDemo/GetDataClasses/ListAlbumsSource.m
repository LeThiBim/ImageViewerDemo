/*
     File: DataSource.m
 Abstract: 
Data Source to manage assets used by the app.
 
  Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 
 Copyright © 2013 Apple Inc. All rights reserved.
 WWDC 2013 License
 
 NOTE: This Apple Software was supplied by Apple as part of a WWDC 2013
 Session. Please refer to the applicable WWDC 2013 Session for further
 information.
 
 IMPORTANT: This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and
 your use, installation, modification or redistribution of this Apple
 software constitutes acceptance of these terms. If you do not agree with
 these terms, please do not use, install, modify or redistribute this
 Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple
 Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple. Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis. APPLE MAKES
 NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE
 IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 EA1002
 5/3/2013
 */

#import "ListAlbumsSource.h"
#import "AFAppDotNetAPIClient.h"
#import "ServiceConfigs.h"
#import "APIService.h"
#import "NSObject+Utilities.h"

@interface ListAlbumsSource ()


@end

@implementation ListAlbumsSource

- (instancetype) init {
    self = [super init];
    if (self) {
        
   //     _currentOldPage = 0;
    }
    return self;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    
    if (self.imageList)
        return [self.imageList count];

    return 0;
}

- (NSString *)identifierForIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"%ld", (long)indexPath.row];
}

- (NSString *)titleForIdentifier:(NSString *)identifier {
    NSString *title = identifier ? [self.data objectForKey:identifier] : nil;
    if (title == nil) {
        title = @"Image";
    }
    return title;
}

- (UIImage *)thumbnailForIdentifier:(NSString *)identifier {
    if (identifier == nil) {
        return nil;
    }
    NSString *thumbnailName = [NSString stringWithFormat:@"%@.JPG", identifier];
    return [UIImage imageNamed:thumbnailName];
}

- (UIImage *)imageForIdentifier:(NSString *)identifier {
    if (identifier == nil) {
        return nil;
    }
    NSString *imageName = [NSString stringWithFormat:@"%@_full", identifier];
    NSString *pathToImage = [[NSBundle mainBundle] pathForResource:imageName ofType:@"JPG"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathToImage];
    return image;
}

- (NSString*) getTitleOfIndex:(NSInteger) index
{
    NSDictionary* item = (NSDictionary*) [self.imageList objectAtIndex:index];
    
    NSString* title = [item objectForKey:@"title"];
    
    if (title == nil)
    {
        title = @"Image";
    }
    return title;

    
}

- (NSString*) getAlbumId:(NSInteger) index
{
    NSDictionary* item = (NSDictionary*) [self.imageList objectAtIndex:index];
    
    NSString* albumId = [item objectForKey:@"id"];
    
    if (albumId == nil)
    {
        albumId = @"762";
    }
    return albumId;

}

- (NSURL*) getImageURLOfIndex:(NSInteger)index
{
    NSDictionary* item  = (NSDictionary*) [self.imageList objectAtIndex:index];
    
    NSString* imageLink = [item objectForKey:@"thumb"];
    NSURL *imageURL     = [NSURL URLWithString:imageLink];
    
    return imageURL;
}

- (float) getScaledHeightOfImageAtIndexPath:(NSInteger) index
{
    NSDictionary* item  = (NSDictionary*) [self.imageList objectAtIndex:index];
    
    NSString* widthStr  = [item objectForKey:@"width"];
    NSString* heightStr = [item objectForKey:@"height"];
    
    
    float realWidth  = [widthStr floatValue];
    float realHeight = [heightStr floatValue];
    
    float scaledHeight = realHeight*[NSObject getConstraintWidthForAlbumCell]/realWidth;
    
    return scaledHeight;
    
}

- (float) getScaledHeightOfCellAtIndexPath:(NSInteger) index
{
    return ([self getScaledHeightOfImageAtIndexPath:index] + 21);
}

- (CGSize) getSizeForItemAtIndexPath:(NSInteger) index
{
    
    float scaledWidth  = [NSObject getConstraintWidthForAlbumCell];
    float scaledHeight = [self getScaledHeightOfCellAtIndexPath:index] + 5;
    
    return CGSizeMake(scaledWidth, scaledHeight);

}

//FOR OLD ALBUM

- (NSString*) getOldTitleOfIndex:(NSInteger) index
{
    NSDictionary* item = (NSDictionary*) [self.oldAlbumsList objectAtIndex:index];
    
    NSString* title = [item objectForKey:@"title"];
    
    if (title == nil)
    {
        title = @"Image";
    }
    return title;
    
    
}

- (NSURL*) getOldImageURLOfIndex:(NSInteger)index
{
    NSDictionary* item  = (NSDictionary*) [self.oldAlbumsList objectAtIndex:index];
    
    NSString* imageLink = [item objectForKey:@"thumb"];
    NSURL *imageURL     = [NSURL URLWithString:imageLink];
    
    return imageURL;
}


- (void) getImageLinksFromServerAtPage:(int) pageIndex
{

    [APIService getListAlbumAtPage:pageIndex WithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(pageIndex == 0)
        {
        
            
            if (self.imageList)
            {
                NSArray* listNewestAlbums = responseObject;
                NSDictionary* newestAlbum = (NSDictionary*) [listNewestAlbums objectAtIndex:0];
                NSString* newestAlbumId = [newestAlbum objectForKey:@"id"];
                
                
                NSDictionary* currentAlbum = (NSDictionary*) [self.imageList objectAtIndex:0];
                NSString* currentAlbumId = [currentAlbum objectForKey:@"id"];
                
                if ([newestAlbumId isEqualToString:currentAlbumId])
                {
                    //TODO: DON'T REFRESH
                    if (self.delegate && [self.delegate respondsToSelector:@selector(finishGetImageLinksFromServerSuccessful)])
                    {
                        self.isNeedToUpdate = NO;
                        [self.delegate performSelector:@selector(finishGetImageLinksFromServerSuccessful) withObject:nil];
                        return;
                    }
                    
                }
                
            }
            
            
            self.imageList = nil;
            
            self.imageList = [responseObject mutableCopy];
            if (self.delegate)
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   if (self.delegate && [self.delegate respondsToSelector:@selector(finishGetImageLinksFromServerSuccessful)])
                                   {
                                       self.isNeedToUpdate = YES;
                                       [self.delegate performSelector:@selector(finishGetImageLinksFromServerSuccessful) withObject:nil];
                                   }
                               });
            }
            
        }
        else  //Get old albums
        {
            self.oldAlbumsList = nil;
            
            self.oldAlbumsList = [responseObject mutableCopy];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(finishGetOldAlbumsFromServerSuccessful)])
            {
                [self.delegate performSelector:@selector(finishGetOldAlbumsFromServerSuccessful) ];
            }
            
        }
    } faildBlock:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           
                           if (pageIndex == 0)
                           {
                                if (self.delegate && [self.delegate respondsToSelector:@selector(finishGetImageLinksFromServerFailed)])
                                    [self.delegate performSelector:@selector(finishGetImageLinksFromServerFailed) withObject:nil];
                           }
                           else
                           {
                               if (self.delegate && [self.delegate respondsToSelector:@selector(finishGetOldAlbumsFromServerFailed)])
                                   [self.delegate performSelector:@selector(finishGetOldAlbumsFromServerFailed) withObject:nil];

                           }
                       });

        
    }];

}




@end
