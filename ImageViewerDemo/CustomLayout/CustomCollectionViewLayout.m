//
//  CustomCollectionViewLayout.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 1/2/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import "CustomCollectionViewLayout.h"
#import "AppDelegate.h"
#import "NSObject+Utilities.h"

@interface CustomCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *columnHeights; // height for each column

@end

@implementation CustomCollectionViewLayout

#pragma mark UICollectionViewLayoutDelegate

- (instancetype) initWithDataSource:(ListAlbumsSource*) dataSource {
    self = [super init];
    if (self) {
        
        self.listAlbumSource = dataSource;
        
        self.columnCount = 2;
        
        self.columnHeights = [[NSMutableArray alloc] init];
        self.itemAttributes = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)dealloc {

    self.columnHeights = nil;
    self.itemAttributes = nil;
    self.listAlbumSource = nil;
}



- (void) prepareLayout
{
    [super prepareLayout];
    
   
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    int itemCount = 0;
    
    if (self.listAlbumSource)
        itemCount = (int) [self.listAlbumSource.imageList count];
    
    NSLog(@"Total Item : %d", itemCount);
    
    
    if (self.itemAttributes && [self.itemAttributes count] > 0)
    {
        [self.itemAttributes removeAllObjects];
    }
    
    if (self.columnHeights && [self.columnHeights count] > 0)
    {
        [self.columnHeights removeAllObjects];
    }
    
    
    
    //Caculate positions for items
    for (int i = 0; i < itemCount; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

        CGRect frame = [self getFrameForItemAtIndexPath:indexPath.row];
        
        attributes.frame = UIEdgeInsetsInsetRect(frame, insets);
        [self.itemAttributes addObject:attributes];

    }
    
}

- (CGSize)collectionViewContentSize
{
    
    CGSize contentSize = CGSizeMake( self.contentSizeWith, 1000);
    
    contentSize.width      = self.contentSizeWith;
    
    if ([self.columnHeights count] >0)
    {
    
        int longestColumnIndex = (int) [self longestColumnIndex];
        float contentHeight    = [[self.columnHeights objectAtIndex:longestColumnIndex] floatValue];
        contentSize.height     = contentHeight;
    }
    
//    NSLog(@"TOTAL HEIGHT : %f", contentSize.height);
    
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    return self.itemAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.itemAttributes objectAtIndex:indexPath.row];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - Private Methods

// Find out shortest column.
- (NSUInteger)shortestColumnIndex {
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = MAXFLOAT;
    
    [self.columnHeights enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height < shortestHeight) {
            shortestHeight = height;
            index = idx;
        }
    }];
    
    return index;
}

// Find out longest column.
- (NSUInteger)longestColumnIndex {
    __block NSUInteger index = 0;
    __block CGFloat longestHeight = 0;
    
    [self.columnHeights enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height > longestHeight) {
            longestHeight = height;
            index = idx;
        }
    }];
    
    return index;
}


- (CGRect) getFrameForItemAtIndexPath:(NSInteger) index
{
    CGSize size = [self.listAlbumSource getSizeForItemAtIndexPath:index];
    
    float interItemSpacing = (self.contentSizeWith - [NSObject getConstraintWidthForAlbumCell]*self.columnCount)/(self.columnCount + 1);
    
    
    float scaledWidth  = size.width;
    float scaledHeight = size.height;
    
    float positionX    = interItemSpacing;
    float positionY    = 0;
    
    if ([self.columnHeights count] == self.columnCount)
    {
    
        int shortestColumnIndex = (int) [self shortestColumnIndex];
        

        positionX = [NSObject getConstraintWidthForAlbumCell]*shortestColumnIndex + (shortestColumnIndex + 1)*interItemSpacing;
        
        positionY = 0;
        
        if ([self.columnHeights count] == self.columnCount)
            positionY = [[self.columnHeights objectAtIndex:shortestColumnIndex] floatValue] + interItemSpacing;
            
        
        self.columnHeights[shortestColumnIndex] = @(positionY + scaledHeight);
        
    }
    else
    {
        positionX = [self.columnHeights count]*[NSObject getConstraintWidthForAlbumCell] + ([self.columnHeights count] + 1)*interItemSpacing;
        positionY = interItemSpacing;
        [self.columnHeights addObject:@(positionY + scaledHeight)];
    }
    
    
    return CGRectMake(positionX, positionY, scaledWidth, scaledHeight);
    
}

@end
