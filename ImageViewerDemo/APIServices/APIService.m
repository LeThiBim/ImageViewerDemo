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
         
     }];

}

+ (void) getListImageInAlbumWithAlbumId:(NSString*) albumId
                           successBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                             faildBlock:(void(^)(NSError *error))faildBlock
{
    [[AFAppDotNetAPIClient sharedClient] GET:[NSString stringWithFormat:[ServiceConfigs getImagesListOfAlbum], albumId]
                                  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if (successBlock)
             successBlock(operation, responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];

}


@end
