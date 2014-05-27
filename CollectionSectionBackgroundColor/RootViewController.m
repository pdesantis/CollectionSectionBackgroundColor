//
//  RootViewController.m
//  CollectionSectionBackgroundColor
//
//  Created by Patrick DeSantis on 5/21/14.
//  Copyright (c) 2014 IDEO. All rights reserved.
//

#import "RootViewController.h"
#import "SectionColorLayout.h"
#import "PlainCell.h"

@interface RootViewController ()

@end

static NSString *const CellReuseIdentifier = @"CoolCell";
static NSString *const BackgroundReuseIdentifier = @"CoolBackground";

static int baseNumberOfItems = 1;

@implementation RootViewController

- (instancetype)init
{
    SectionColorLayout *layout = [[SectionColorLayout alloc] init];
    layout.itemSize = CGSizeMake(50, 50);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    self = [self initWithCollectionViewLayout:layout];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView registerClass:[PlainCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:IDEOCollectionElementKindSectionBackground withReuseIdentifier:BackgroundReuseIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (baseNumberOfItems * (section + 1));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BackgroundReuseIdentifier forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            view.backgroundColor = [UIColor yellowColor];
            break;
        case 1:
            view.backgroundColor = [UIColor magentaColor];
            break;
        case 2:
            view.backgroundColor = [UIColor greenColor];
            break;
        case 3:
            view.backgroundColor = [UIColor redColor];
            break;
        case 4:
        default:
            view.backgroundColor = [UIColor lightGrayColor];
            break;
    }

    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    baseNumberOfItems++;
    if (baseNumberOfItems > 10) {
        baseNumberOfItems = 1;
    }
    [self.collectionView reloadData];
}

@end
