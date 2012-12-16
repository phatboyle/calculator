//
//  DestinationTableViewController.m
//  Places
//
//  Created by Boyle, Patrick on 10/13/12.
//  Copyright (c) 2012 Pat Boyle. All rights reserved.
//

#import "DestinationTableViewController.h"
#import "ImageViewController.h"
#import "FlickrAnnotation.h"
#import "MapViewController.h"

@interface DestinationTableViewController ()

@end

@implementation DestinationTableViewController

@synthesize photos = _photos;

/*
-(void)setPhotos:(NSArray *)photos{
    _photos = photos;
    NSLog(@"setPhotos setting %d", [photos count]);
}
 */

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
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger x =[[self photos] count];
    NSLog(@"number of rows %d", x);
    return x;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Place Descriptions";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *photosInPlace = [self.photos objectAtIndex:indexPath.row];
    
    NSString *title = [photosInPlace valueForKey:@"title"];
    NSString *description = [photosInPlace valueForKeyPath:@"description._content"];
    
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    description = [description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (title && ![title isEqualToString:@""]){
        cell.textLabel.text=title;
        cell.detailTextLabel.text=description;
    } else if (description && ![description isEqualToString:@""]){
        cell.textLabel.text=description;
        cell.detailTextLabel.text=@"";
    } else {
        cell.textLabel.text = @"Unknown";
        cell.detailTextLabel.text=@"";
    }
    return cell;
}

- (void)setPhotoList: (NSArray *)photoList withTitle:(NSString *)title{
    self.photos=photoList;
    NSInteger x =[self.photos count];
    NSLog(@"number of rows %d", x);
    
    self.title=title;
    
}

- (NSArray*) getAnnotations{
    NSMutableArray* annoList = [NSMutableArray arrayWithCapacity:[self.photos count]];
    for (NSDictionary* p in self.photos){
        FlickrAnnotation* f = [FlickrAnnotation annotation:p];
        NSLog(@"title: %@", [f title]);
        NSLog(@"title: %@", [f subtitle]);
        NSLog(@"lat: %f", [f coordinate].latitude);
        NSLog(@"long: %f", [f coordinate].longitude);
        
        [annoList addObject: f];
    }
    NSLog(@"print annolist %@", annoList);
    return annoList;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loadMap"]){
        NSLog(@"prepareForSegue");
        [[segue destinationViewController] setAnnotations:self.getAnnotations];
    }
    if ([segue.identifier isEqualToString:@"showPhoto"]){
        NSDictionary *imageDictionary = [self.photos objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        [[segue destinationViewController] setImage:imageDictionary withTitle:self.title];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
