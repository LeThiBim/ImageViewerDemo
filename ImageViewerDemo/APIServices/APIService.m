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

+ (void) getListAlbumWithSuccessBlock:(void(^)(NSURLSessionDataTask * __unused task, id JSON))successBlock
                           faildBlock:(void(^)(NSError *error))faildBlock
{
    [[AFAppDotNetAPIClient sharedClient] GET:[ServiceConfigs getAlbumUrl]
                                  parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON)
     {
         if (successBlock)
             successBlock(task, JSON);
         
     } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
         
     }];

}

+ (void) getListImageInAlbumWithAlbumId:(NSString*) albumId
                           successBlock:(void(^)(NSURLSessionDataTask * __unused task, id JSON))successBlock
                             faildBlock:(void(^)(NSError *error))faildBlock
{
    [[AFAppDotNetAPIClient sharedClient] GET:[NSString stringWithFormat:[ServiceConfigs getImagesListOfAlbum], albumId]
                                  parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON)
     {
         
         if (successBlock)
             successBlock(task, JSON);
         
     } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
         
     }];

}


@end
