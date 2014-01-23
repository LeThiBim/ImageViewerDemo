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

+(NSString*) getAlbumUrlAtPage
{
    return @"api/posts/%d";
}

+(NSString*) getImagesListOfAlbum
{
    return @"api/post/%@";
}

+(NSString*) likePhoto
{
    return @"http://m.source.vn/api/photo/like/%@/%@";
}

+(NSString*) unLikePhoto
{
    return @"http://m.source.vn/api/photo/unlike/%@/%@";
}
@end
