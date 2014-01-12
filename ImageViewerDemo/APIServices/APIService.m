//
//  APIService.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/27/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import "APIService.h"
#import "AFAppDotNetAPIClient.h"
#import "ServiceConfigs.h"
#import "NSObject+Utilities.h"

@implementation APIService

+ (void) getListAlbumWithSuccessBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                           faildBlock:(void(^)(NSError *error))faildBlock
{
    [[AFAppDotNetAPIClient sharedClient] GET:[ServiceConfigs getAlbumUrl]
                                  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"LIST ALBUMS : %@", responseObject);
         
         if (successBlock)
             successBlock(operation, responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         [self showErrorAlert:error];
         
     }];

}

+ (void) getListImageInAlbumWithAlbumId:(NSString*) albumId
                           successBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                             faildBlock:(void(^)(NSError *error))faildBlock
{
    [[AFAppDotNetAPIClient sharedClient] GET:[NSString stringWithFormat:[ServiceConfigs getImagesListOfAlbum], albumId]
                                  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"LIST PHOTOS : %@", responseObject);
         
         if (successBlock)
             successBlock(operation, responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         [self showErrorAlert:error];

     }];

}

+ (void) likePhotoWithPhotoId:(NSString*) photoId
                 successBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                   faildBlock:(void(^)(NSError *error))faildBlock
{
    
    [[AFAppDotNetAPIClient sharedClient] GET:[NSString stringWithFormat:[ServiceConfigs likePhoto], [self getUUID], photoId]
                                  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"LIKE PHOTO RESULT: %@", responseObject);
         
         if (successBlock)
             successBlock(operation, responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         [self showErrorAlert:error];
         
     }];

}

+ (void)showErrorAlert:(NSError *)error{
    
    NSString *msg = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    if([msg isEqualToString:@"The Internet connection appears to be offline."])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        
            UIAlertView* internetErrorAlert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"The Internet connection appears to be offline." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [internetErrorAlert show];
            
        });

        
    }
}


@end
