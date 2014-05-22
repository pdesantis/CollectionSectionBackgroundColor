//
//  PlainCell.m
//  CollectionSectionBackgroundColor
//
//  Created by Patrick DeSantis on 5/21/14.
//  Copyright (c) 2014 IDEO. All rights reserved.
//

#import "PlainCell.h"

@implementation PlainCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.text = @"cool";
        [self addSubview:label];
    }
    return self;
}

@end
