//
//  AsyncImageView.m
//  Lecker
//
//  Created by Koegler, Stefan on 26.06.13.
//  Copyright (c) 2013 Bauer Digital KG. All rights reserved.
//

#import "AsyncImageView.h"

@interface AsyncImageView()
@property (nonatomic, retain) NSTimer *timer; // for delayed loading
@property (nonatomic, retain) NSOperationQueue *queue; // stop loading?
@property (nonatomic, retain) UIActivityIndicatorView *activityView; // activity
// TODO: Default Image?
@end

@implementation AsyncImageView

#pragma mark - Init

- (id)init
{
    if (self = [super init])
    {
        self.userInteractionEnabled = YES;
        self.activityView = nil;
        self.queue = nil;
        self.timer = nil;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.autoresizesSubviews = YES;
        self.clipsToBounds = YES;
    }
    return self;
}

- (id)initWithUrl:(NSURL*)aUrl
{
    if (self = [self init])
    {
        self.url = aUrl;
    }
    return self;    
}

- (id)initWithUrl:(NSURL*)aUrl frame:(CGRect)frame contentMode:(UIViewContentMode)contentMode
{
    if (self = [self initWithUrl:aUrl])
    {
        self.frame = frame;
        self.contentMode = contentMode;
    }
    return self;
}

- (id)initWithUrl:(NSURL*)aUrl frame:(CGRect)frame contentMode:(UIViewContentMode)contentMode activityIndicatorType:(UIActivityIndicatorViewStyle)indicatorStyle
{
    if (self = [self initWithUrl:aUrl frame:frame contentMode:contentMode])
    {
        // Set Activity
        CGPoint center = CGPointMake((int)(self.bounds.size.width/2), (int)(self.bounds.size.height/2));
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:indicatorStyle];
        self.activityView.hidesWhenStopped = YES;
        [self.activityView stopAnimating];
        [self.activityView setCenter:center];
        
        [self addSubview:self.activityView];
    }
    return self;
}

#pragma mark - Start / Stop Loading

- (void)startLoadImage
{
    [self.timer invalidate];
    self.timer = nil;
    self.queue = [[NSOperationQueue alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
        {
            if (!error)
            {
                if (data)
                {
                    UIImage *image = [UIImage imageWithData:data];
                    if (image)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self setImage:image];
                            [self.activityView stopAnimating];
                        });
                    }
                }
                else
                {
                    NSLog(@"No data?!");
                    [self.activityView stopAnimating];
                    // Show Default Image?
                }
            }
            else
            {
                NSLog(@"Error: %@", error);
                [self.activityView stopAnimating];
                // Show Default Image?
            }
        }
    ];
}

- (void)startLoadImageAfterDelay:(float)delay
{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(startLoadImage) userInfo:nil repeats:NO];
}

- (void)stopLoadImage
{
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.queue)
    {
        NSLog(@"operations: %@", [self.queue operations]);
    }
}

@end
