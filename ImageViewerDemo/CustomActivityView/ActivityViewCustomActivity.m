//
//  ActivityViewCustomActivity.m
//  ImageViewerDemo
//
//  Created by Nguyen Quang Huy on 1/7/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import "ActivityViewCustomActivity.h"
#import "DataService.h"
#import "IMAGE.h"
#import "APIService.h"


@implementation ActivityViewCustomActivity

- (NSString *)activityType
{
    return @"yourappname.Review.App";
}

- (NSString *)activityTitle
{
    return @"Like Photo";
}

- (UIImage *)activityImage
{
    // Note: These images need to have a transparent background and I recommend these sizes:
    // iPadShare@2x should be 126 px, iPadShare should be 53 px, iPhoneShare@2x should be 100
    // px, and iPhoneShare should be 50 px. I found these sizes to work for what I was making.
    
    return [UIImage imageNamed:@"like_icon.png"];
  
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"%s",__FUNCTION__);
}

- (UIViewController *)activityViewController
{
    NSLog(@"%s",__FUNCTION__);
    return nil;
}

- (void)performActivity
{
    // This is where you can do anything you want, and is the whole reason for creating a custom
    // UIActivity
    
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"imageId=%@", self.photo.photoId];
    NSArray* fitledArray = [[[DataService sharedInstance] selectAllByContext] filteredArrayUsingPredicate:predicate];
    
    if ([fitledArray count] == 0)
    {
        NSLog(@"Save this photo");
        
        NSString *cachedFolderPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *cachedImagePath = [cachedFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", self.photo.photoId]];
        [UIImagePNGRepresentation(self.photo.underlyingImage) writeToFile:cachedImagePath atomically:YES];
        
        NSManagedObjectContext *managedObjectContext = [[DataService sharedInstance] managedObjectContext];
        
        IMAGE *image = (IMAGE*) [NSEntityDescription insertNewObjectForEntityForName:@"IMAGE" inManagedObjectContext:managedObjectContext];
        
        image.imageId = self.photo.photoId;
        image.imagePath = cachedImagePath;
        
        
        [[DataService sharedInstance] saveContext];
        
    }
    
     if (_activityViewController)
    {
    
        [APIService likePhotoWithPhotoId:self.photo.photoId successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            NSDictionary* result = (NSDictionary*) responseObject;
            
            int successValue = [[result valueForKey:@"success"] intValue];
            
            if (successValue == 1 || successValue == 0)
            {
                
                [NSObject showAlertWithTitle:NSLocalizedString(@"SUCCESSFUL", nil)
                                  andMessage:NSLocalizedString(@"SUCCESSFUL_ALREADY_MESSAGE", nil)];
            }
            
            
        } faildBlock:^(NSError *error) {
            
            
            
        }];
    
        
        
        
        [_activityViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }
}

@end
