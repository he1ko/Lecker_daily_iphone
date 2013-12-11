//
//  LeckerSingleRecipeOverviewModel.h
//  Lecker
//
//  Created by Naujeck, Marcel on 05.03.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsycImageLoader.h"


@protocol LeckerSingleRecipeOverviewModelProtocol <NSObject>

@optional
-(void) loadingFinished;

@end

@interface LeckerSingleRecipeOverviewModel : NSObject <AycnImageLoaderProtocol>
@property NSString *contendId;
@property NSString *description;
@property NSString *thumbnailUrl;
@property NSString *title;
@property UIImage *image;
@property UIImage *thumbnail;
@property (nonatomic,weak) id <LeckerSingleRecipeOverviewModelProtocol> delegate;
-(void) loadThumbnail;
@end
