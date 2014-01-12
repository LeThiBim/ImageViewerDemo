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
    
 //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=yourappid"]];
 //   [self activityDidFinish:YES];
    if (_activityViewController)
    {
    
        NSString *cachedFolderPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *cachedImagePath = [cachedFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", self.photo.photoId]];
        [UIImagePNGRepresentation(self.photo.underlyingImage) writeToFile:cachedImagePath atomically:YES];
        
        NSManagedObjectContext *managedObjectContext = [[DataService sharedInstance] managedObjectContext];
    
        IMAGE *image = (IMAGE*) [NSEntityDescription insertNewObjectForEntityForName:@"IMAGE" inManagedObjectContext:managedObjectContext];
        
        image.imageId = [NSString stringWithFormat:@"%@", self.photo.photoId];
        image.imagePath = [NSString stringWithFormat:@"%@", cachedImagePath];
        
        [[DataService sharedInstance] saveContext];
        
        [APIService likePhotoWithPhotoId:self.photo.photoId successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"LIKE RESULT : %@", responseObject);
            NSDictionary* result = (NSDictionary*) responseObject;
            
            if ([[result valueForKey:@"success"] intValue] == 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView* internetErrorAlert = [[UIAlertView alloc] initWithTitle:@"SUCCESSFUL" message:@"This photo is added to your album!!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [internetErrorAlert show];
                    
                });
                
                
            }

            
            
        } faildBlock:^(NSError *error) {
            
            
            
        }];
    
        
        
        
        [_activityViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }
}

@end
