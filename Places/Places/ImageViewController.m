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


-(void)setImagex:(NSDictionary *)pd withTitle:(NSString *)title{
    self.photoDict=pd;
    self.title = title;
}
 

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.scrollView.delegate = self;
    NSLog(@"ImageViewController %@", photoDict);
    NSData *image = [self getImageData];
    self.imageView.image = [UIImage imageWithData:image];
    [self updateCache:image];
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    
    [self updateRecentList];
    //scrollView.minimumZoomScale = 0.5;
    //scrollView.maximumZoomScale = 2.0;
}

- (NSData *) getImageData {
    NSData *image = [DiskCache fetchData:[photoDict objectForKey:@"id"]];
    if (!image){
        image = [NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:photoDict format:FlickrPhotoFormatLarge] ];
    }
    return image;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
