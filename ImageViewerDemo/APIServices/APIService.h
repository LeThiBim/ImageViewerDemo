//
//  APIService.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/27/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIService : NSObject

+ (void) getListAlbumWithSuccessBlock:(void(^)(NSURLSessionDataTask * __unused task, id JSON))successBlock
                           faildBlock:(void(^)(NSError *error))faildBlock;


+ (void) getListImageInAlbumWithAlbumId:(NSString*) albumId
                           successBlock:(void(^)(NSURLSessionDataTask * __unused task, id JSON))successBlock
                             faildBlock:(void(^)(NSError *error))faildBlock;

@end
