//
//  PlacesTableViewController.m
//  Places
//
//  Created by Pat Boyle on 10/7/12.
//  Copyright (c) 2012 Pat Boyle. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "FlickrFetcher.h"
@interface PlacesTableViewController ()

@end


@implementation PlacesTableViewController

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
    
    self.topPlaces = [FlickrFetcher topPlaces];
    NSArray *sortDescripters = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:CONTENT_KEY ascending:YES]];
    self.topPlaces = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:sortDescripters];
    

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
    
    // Configure the cell...
    // get the object from the cell
    // get the description from the object
    //assign the description to the cell
    
    
    NSDictionary *topPlaceDictionary = [self.topPlaces objectAtIndex:indexPath.row];
    NSString *description = [topPlaceDictionary objectForKey:CONTENT_KEY];
    
    cell.textLabel.text = description;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSDictionary *description = [self.topPlaces objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    [segue destinationViewController] setPhotoList:[FlickrFetcher photosInPlace:description maxResults: 50] withTitle:[[sender textLabel]];
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
