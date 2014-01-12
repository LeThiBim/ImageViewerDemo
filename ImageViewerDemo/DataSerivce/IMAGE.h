//
//  IMAGE.h
//  ImageViewerDemo
//
//  Created by Nguyen Quang Huy on 1/12/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IMAGE : NSManagedObject

@property (nonatomic, retain) NSString * imageId;
@property (nonatomic, retain) NSString * imagePath;

@end
