//
//  SectionColorLayout.m
//  CollectionSectionBackgroundColor
//
//  Created by Patrick DeSantis on 5/21/14.
//  Copyright (c) 2014 IDEO. All rights reserved.
//

#import "SectionColorLayout.h"

@interface SectionColorLayout ()
@property (strong, nonatomic) NSMutableDictionary *backgroundAttributes;
@end

NSString *const IDEOCollectionElementKindSectionBackground = @"IDEOCollectionElementKindSectionBackground";

@implementation SectionColorLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // Get the existing attributes from the super class
    NSArray *oldAttributes = [super layoutAttributesForElementsInRect:rect];

    // Find each unique visible section
    NSMutableSet *sections = [NSMutableSet set];
    for (UICollectionViewLayoutAttributes *attributes in oldAttributes) {
        [sections addObject:@(attributes.indexPath.section)];
    }

    // Insert attributes for the supplementary view for each visible section
    NSMutableArray *attributesToReturn = [oldAttributes mutableCopy];
    for (NSNumber *section in sections) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:[section integerValue]];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:IDEOCollectionElementKindSectionBackground atIndexPath:indexPath];
        [attributesToReturn addObject:attributes];
    }
    return attributesToReturn;
}

- (void)prepareLayout
{
    // Clear the cache
    self.backgroundAttributes = [NSMutableDictionary dictionary];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    // If we have cached attributes for this index path, just return them
    if (self.backgroundAttributes[indexPath]) {
        return self.backgroundAttributes[indexPath];
    }

    NSInteger section = indexPath.section;
    NSInteger items = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];

    // Get the origin from the first cell in this section
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *firstCellAttributes = [self layoutAttributesForItemAtIndexPath:firstIndexPath];
    CGPoint origin = firstCellAttributes.frame.origin;

    // Get the size
    CGFloat maxWidth = 0;
    CGFloat maxHeight = 0;

    // Set the max width or height, depending on our scroll direction
    // This is necessary in case the section doesn't have enough items to fill its width or height
    // We still want this supplementary view to stretch to fill its bounds
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        maxHeight = self.collectionView.bounds.size.height;
    } else {
        maxWidth = self.collectionView.bounds.size.width;
    }

    // Iterate through the items and find the max width & height
    for (int i = (items - 1); i >= 0; i--) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
        UICollectionViewLayoutAttributes *currentCellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        maxWidth = MAX(maxWidth, CGRectGetMaxX(currentCellAttributes.frame));
        maxHeight = MAX(maxHeight, CGRectGetMaxY(currentCellAttributes.frame));
    }

    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];

    // Set the frame
    CGRect frame = CGRectMake(origin.x, origin.y, maxWidth - origin.x, maxHeight - origin.y);

    // TODO: Adjust for section insets?
//    frame = UIEdgeInsetsInsetRect(frame, self.sectionInset);
    attributes.frame = frame;

    // Position the view behind the others
    attributes.zIndex = -1;

    return attributes;
}

@end
