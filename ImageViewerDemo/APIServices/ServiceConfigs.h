//
//  ServiceConfigs.h
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/27/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceConfigs : NSObject

/*API Links*/

+(NSString*) getAlbumUrl;
+(NSString*) getImagesListOfAlbum;

+(NSString*) likePhoto;
@end
