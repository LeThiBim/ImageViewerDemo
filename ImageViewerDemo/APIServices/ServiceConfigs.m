//
//  ServiceConfigs.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/27/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import "ServiceConfigs.h"

@implementation ServiceConfigs

/*API Links*/

+(NSString*) getAlbumUrl
{
    return @"api/post";
}

+(NSString*) getImagesListOfAlbum
{
    return @"api/post/%@";
}

@end
