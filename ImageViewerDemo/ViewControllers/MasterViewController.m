//
//  MasterViewController.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 1/13/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import "MasterViewController.h"
#import "ListAlbumsController.h"
#import "YourAlbumViewController.h"
#import "ListAlbumsSource.h"
#import "AppDelegate.h"

@interface MasterViewController ()

@property (strong, nonatomic) NSArray* mainScreenList;

@property (assign, nonatomic) int selectedIndex;

@end

@implementation MasterViewController

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
    
    self.mainScreenList = @[@"All Albums", @"Your Album"];
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
       return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (self.mainScreenList)
        return [self.mainScreenList count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mainScreenCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...

    if (indexPath.row == self.selectedIndex)
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"✓ %@", [self.mainScreenList objectAtIndex:indexPath.row]];
    else
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"  %@", [self.mainScreenList objectAtIndex:indexPath.row]];

    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setBackgroundColor:[UIColor blackColor]];

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MSPaneViewControllerType paneViewControllerType = [self paneViewControllerTypeForIndexPath:indexPath];
//    [self transitionToViewController:paneViewControllerType];
//    if (self.paneViewControllerAppearanceTypes[@(paneViewControllerType)]) {
//        self.navigationPaneViewController.appearanceType = [self.paneViewControllerAppearanceTypes[@(paneViewControllerType)] unsignedIntegerValue];
//        // Update row titles
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//    }
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.selectedIndex)
    {
        [self.navigationPaneViewController setPaneState:MSNavigationPaneStateClosed animated:YES completion:nil];
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
                
            {
                
                ListAlbumsController *listAlbumsController = (ListAlbumsController *)[self.navigationPaneViewController.storyboard instantiateViewControllerWithIdentifier:@"ListAlbumsController"];
                
                
                listAlbumsController.navigationPaneViewController = self.navigationPaneViewController;
                listAlbumsController.dataSource = [[ListAlbumsSource alloc] init];
                listAlbumsController.dataSource.delegate = listAlbumsController;
                [listAlbumsController.dataSource getImageLinksFromServer];
                
                UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:listAlbumsController];
                
                
                
                paneNavigationViewController.navigationBar.barStyle = UIBarStyleBlack;
                
                
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
                {
                    [listAlbumsController setWantsFullScreenLayout:YES];
                    
                }
                else
                {
                    paneNavigationViewController.navigationBar.translucent = YES;
                }
                
                [self.navigationPaneViewController setPaneViewController:paneNavigationViewController animated:YES completion:nil];
                
                
                [listAlbumsController performSelector:@selector(setUpCustomLayOut) withObject:nil afterDelay:0.5];
            }
                
                
                break;
            case 1:
            {
                YourAlbumViewController *yourAlbumController = (YourAlbumViewController *)[self.navigationPaneViewController.storyboard instantiateViewControllerWithIdentifier:@"YourAlbumViewController"];

                yourAlbumController.navigationPaneViewController = self.navigationPaneViewController;
                
                UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:yourAlbumController];
                
                paneNavigationViewController.navigationBar.barStyle = UIBarStyleBlack;
                
                
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
                {
                    [yourAlbumController setWantsFullScreenLayout:YES];
                    
                }
                else
                {
                    paneNavigationViewController.navigationBar.translucent = YES;
                }
                
                [self.navigationPaneViewController setPaneViewController:paneNavigationViewController animated:YES completion:nil];

            

        
            }
                
                break;
                
            case 2:
            {
                
            }
                
                break;
                
            default:
                break;
        }
    }
    
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.currentMainScreenIndex = indexPath.row;
    
    self.selectedIndex = indexPath.row;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
