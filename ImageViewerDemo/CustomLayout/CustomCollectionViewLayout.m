//
//  CustomCollectionViewLayout.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 1/2/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import "CustomCollectionViewLayout.h"
#import "AppDelegate.h"

@interface CustomCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *columnHeights; // height for each column

@end

@implementation CustomCollectionViewLayout

#pragma mark UICollectionViewLayoutDelegate

- (instancetype) init {
    self = [super init];
    if (self) {
        
        self.columnCount = 2;
        
        self.columnHeights = [[NSMutableArray alloc] init];
        self.itemAttributes = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)dealloc {

    _columnHeights = nil;
    _itemAttributes = nil;
}



- (void) prepareLayout
{
    [super prepareLayout];
    
   
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.totalHeight = 0;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(2, 2, 2, 2);
    
    
    int itemCount = [appDelegate.listAlbumSource.imageList count];
    
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
    
    
    CGSize contentSize = CGSizeZero;
    
    contentSize.width      = self.contentSizeWith;
    
    if ([self.columnHeights count] >0)
    {
    
        int longestColumnIndex = [self longestColumnIndex];
        float contentHeight    = [[self.columnHeights objectAtIndex:longestColumnIndex] floatValue];
        contentSize.height     = contentHeight;
    }
    
    NSLog(@"TOTAL HEIGHT : %f", contentSize.height );
    
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
    return UIEdgeInsetsMake(2, 2, 2, 2);
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
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    CGSize size = [appDelegate.listAlbumSource getSizeForItemAtIndexPath:index];
    
    float scaledWidth  = size.width;
    float scaledHeight = size.height;
    
    float positionX    = 0;
    float positionY    = 0;
    
    if ([self.columnHeights count] == self.columnCount)
    {
    
        int shortestColumnIndex = [self shortestColumnIndex];
        
        NSLog(@"SHORTEST COLUMN INDEX : %d", shortestColumnIndex);
        
        positionX = 150*shortestColumnIndex;
        positionY = 0;
        
        if ([self.columnHeights count] == self.columnCount)
            positionY = [[self.columnHeights objectAtIndex:shortestColumnIndex] floatValue];
            
        
        self.columnHeights[shortestColumnIndex] = @(positionY + scaledHeight);
        
    }
    else
    {
        positionX = [self.columnHeights count]*150;
        positionY = 0;
        [self.columnHeights addObject:@(positionY + scaledHeight)];
    }
    
    
    return CGRectMake(positionX, positionY, scaledWidth, scaledHeight);
    
}

@end
