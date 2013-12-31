//
//  APIService.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/27/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@interface APIService : NSObject

+ (void) getListAlbumWithSuccessBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                           faildBlock:(void(^)(NSError *error))faildBlock;


+ (void) getListImageInAlbumWithAlbumId:(NSString*) albumId
                           successBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                             faildBlock:(void(^)(NSError *error))faildBlock;

@end
