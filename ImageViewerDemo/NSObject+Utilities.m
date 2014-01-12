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

@end
