//
//  ImageViewController.m
//  Places
//
//  Created by Boyle, Patrick on 10/13/12.
//  Copyright (c) 2012 Pat Boyle. All rights reserved.
//

#import "ImageViewController.h"
#import "FlickrFetcher.h"
#import "DiskCache.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ImageViewController
@synthesize scrollView;
@synthesize imageView;
@synthesize photoDict;


-(void)updateRecentList {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSMutableArray *photosList = [[settings arrayForKey:@"key.recentphotos"] mutableCopy];
    NSLog(@"getting NSUserDefaults %d", [photosList count]);
    
    if (!photosList) {
        photosList = [NSMutableArray array];
    }
    
    while ([photosList count] > 19) {
        [photosList removeLastObject];
    }
    
    for (int i=0; i<[photosList count]; i++)
    {
        NSDictionary *photo = [photosList objectAtIndex:i];
        if ([[photo objectForKey:@"photoID"] isEqualToString:[self.photoDict objectForKey:@"photoID"]]){
            [photosList removeObjectAtIndex:i];
        }
    }
    
    [photosList addObject:[self photoDict]];
    [settings setObject:photosList forKey:@"key.recentphotos"];
    [settings synchronize];
    
}
-(void)updateCache: (NSData *) image{
    [DiskCache storeData:[photoDict objectForKey:@"id"]:image];
    
}


-(void)setImage:(NSDictionary *)photo withTitle:(NSString *)title{
    self.photoDict=photo;
    self.title = title;
}
 

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    NSData *image = [self getImageData];
    self.imageView.image = [UIImage imageWithData:image];
    [self updateCache:image];
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    [self updateRecentList];
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 2.0;

	float widthRatio = self.view.bounds.size.width / self.imageView.bounds.size.width;
    float heightRatio = self.view.bounds.size.height / self.imageView.bounds.size.height;
    NSLog(@"widthRatio, heightRatio is: %f, %f, %f", widthRatio, heightRatio, MAX(widthRatio, heightRatio));
    
    self.scrollView.zoomScale = MAX(widthRatio,heightRatio);
}

- (NSData *) getImageData {
    NSData *image = [DiskCache fetchData:[photoDict objectForKey:@"id"]];
    if (!image){
        image = [NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:photoDict format:FlickrPhotoFormatLarge] ];
    }
    return image;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}



@end
