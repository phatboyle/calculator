//
//  PlacesTableViewController.m
//  Places
//
//  Created by Pat Boyle on 10/7/12.
//  Copyright (c) 2012 Pat Boyle. All rights reserved.
//

#import "TopPlacesViewController.h"
#import "FlickrFetcher.h"
#import "DestinationTableViewController.h"
@interface TopPlacesViewController ()

@end


@implementation TopPlacesViewController

#define CONTENT_KEY @"_content"

@synthesize topPlaces = _topPlaces;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *sortDescripters = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:CONTENT_KEY ascending:YES]];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    dispatch_queue_t downloadQueue = dispatch_queue_create("places.flickrfetcher", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *photos = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:sortDescripters];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.topPlaces = photos;
            [self.tableView reloadData];
            //NSLog(@"printing inside block viewDidload %@", self.topPlaces );
        });
    });
    dispatch_release(downloadQueue);
    //NSLog(@"printing exit of viewDidload %@", self.topPlaces );
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Place Descriptions";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *topPlaceDictionary = [self.topPlaces objectAtIndex:indexPath.row];
    NSString *description = [topPlaceDictionary objectForKey:CONTENT_KEY];
    NSString *title = @"";
    NSString *detail = @"";
    //NSLog(@"%@",title);
    NSRange firstComma = [description rangeOfString:@","];
    if (firstComma.location == NSNotFound){
        title = description;
    } else {
        title = [description substringToIndex:firstComma.location];
        detail = [description substringFromIndex:firstComma.location+1];
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSDictionary *placeDictionary = [self.topPlaces objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    dispatch_queue_t dispatchQueue = dispatch_queue_create("places.segue.flickrfetcher", nil);
    dispatch_async(dispatchQueue, ^(void){
        
        UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
        [spinner startAnimating];
        
        
        
        NSArray* photos = [FlickrFetcher photosInPlace:placeDictionary maxResults:50];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [[segue destinationViewController] setPhotoList:photos
                                                   withTitle:[[sender textLabel] text]];
            [[[ segue destinationViewController] tableView] reloadData];
            
            [spinner stopAnimating];
        });
    });
    dispatch_release(dispatchQueue);
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
