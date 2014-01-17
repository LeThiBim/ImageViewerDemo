//
//  NSObject+Utilities.m
//  ImageViewerDemo
//
//  Created by Nguyen Quang Huy on 1/12/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import "NSObject+Utilities.h"
#import "KeychainItemWrapper.h"

#define SAVED_DEVICE_IDENTIFIERFORVENDOR kSecAttrService

@implementation NSObject (Utilities)

static NSString* staticUUID = nil;
static UIAlertView* staticAlertView = nil;
static float staticConstraintAlbumCellWidth = 150;

+ (NSString*) getUUID
{
    if (staticUUID)
        return staticUUID;
    

    KeychainItemWrapper* keychain = nil;
    
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TATABIM" accessGroup:nil];
    
    @synchronized ([NSObject class])
    {
        if (keychain)
        {
            id savedIdentifierForVendor = [keychain objectForKey:(__bridge id)SAVED_DEVICE_IDENTIFIERFORVENDOR];
            
            if (savedIdentifierForVendor != nil && ((NSString*)savedIdentifierForVendor).length > 0)
            {
                
                staticUUID = [[NSString alloc] initWithFormat:@"%@", savedIdentifierForVendor];
                return (NSString*)staticUUID;
            }
        }
    }
    
        
      
    // >= iOS6 return identifierForVendor
    UIDevice *device = [UIDevice currentDevice];
    
    if ([device respondsToSelector:@selector(identifierForVendor)] && [NSUUID class])
    {
        
        @synchronized ([NSObject class])
        {
            // Save IdentifierForVendor
            [keychain setObject:[UIDevice currentDevice].identifierForVendor.UUIDString forKey:(__bridge id)SAVED_DEVICE_IDENTIFIERFORVENDOR];
            
            staticUUID = [[NSString alloc] initWithFormat:@"%@", [UIDevice currentDevice].identifierForVendor.UUIDString];
        }
        
        
        return staticUUID;
    }
    
    
    return @"";
    
}

+ (void) showAlertWithTitle:(NSString*) title andMessage:(NSString*) message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!staticAlertView)
        {
        
            staticAlertView = [[UIAlertView alloc] initWithTitle:title message:message  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
        }
        else
        {
            staticAlertView.title = title;
            staticAlertView.message = message;
        }
        
        [staticAlertView show];
        
    });

}

+ (void) setConstraintWidthForAlbumCellWithValue:(float) value
{
    staticConstraintAlbumCellWidth = value;
}

+ (float) getConstraintWidthForAlbumCell
{
    return staticConstraintAlbumCellWidth;
}

+ (CGRect) getScreenFrameForOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds;
    BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    
    //implicitly in Portrait orientation.
    if(orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft)
    {
        CGRect temp = CGRectZero;
        temp.size.width = fullScreenRect.size.height;
        temp.size.height = fullScreenRect.size.width;
        fullScreenRect = temp;
    }
    
    if(!statusBarHidden)
    {
        CGFloat statusBarHeight = 20;//Needs a better solution, FYI statusBarFrame reports wrong in some cases..
        fullScreenRect.size.height -= statusBarHeight;
    }
    
    return fullScreenRect;
}

+ (float) getScreenWidthForOrientation
{
    return [self getScreenFrameForOrientation].size.width;
}

+ (float) getScreenHeightForOrientation
{
    return [self getScreenFrameForOrientation].size.height;
}
@end
