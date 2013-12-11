//
//  LeckerSearchMainView.m
//  Lecker
//
//  Created by Naujeck, Marcel on 22.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "LeckerSearchMainView.h"
#import "LeckerTools.h"


@interface LeckerSearchMainView()
@property UIView *leckerHeader;
@property UIView *contentView;
//@property UIScrollView *scrollView; // SK unused
@property LeckerSearchSelectionView *selectionView;
@end

@implementation LeckerSearchMainView

- (id)initWithFrame:(CGRect)frame andFacetGroupList:(NSArray*) facetList
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.leckerHeader=[[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
        [self.leckerHeader.layer insertSublayer:[LeckerTools headerGradientwithFrame:self.leckerHeader.bounds] atIndex:0];
        UIImageView *logo=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lecker-logo.png"]];
        CGRect frame=logo.frame;
        frame.origin.x=self.leckerHeader.frame.size.width/2- frame.size.width/2;
        frame.origin.y=self.leckerHeader.frame.size.height/2- frame.size.height/2;
        logo.frame=frame;
        [self.leckerHeader addSubview:logo];
        [self addSubview:self.leckerHeader];
        
        self.contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, self.bounds.size.height-40)];
        UIImageView *bg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"holz.png"]];
        bg.frame=self.contentView.bounds;
        bg.contentMode=UIViewContentModeScaleAspectFill;
        bg.clipsToBounds=YES;
        [self.contentView addSubview:bg];
        [self addSubview:self.contentView];
        
        self.selectionView=[[LeckerSearchSelectionView alloc] initWithFrame:self.contentView.bounds andFacetGroupList:facetList];
        [self.contentView addSubview:self.selectionView];
        self.selectionView.searchdelegate=self;
    }
    return self;
}

-(void) doSearchWithSearchObject:(SearchObject *)search {
    if([self.delegate respondsToSelector:@selector(doSearchWithSearchObject:)]) {
        [self.delegate doSearchWithSearchObject:search];
    }
}

@end
