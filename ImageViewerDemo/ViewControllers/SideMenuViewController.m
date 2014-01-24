//
//  SideMenuViewController.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 1/21/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import "SideMenuViewController.h"
#import "ListAlbumsController.h"
#import "YourAlbumViewController.h"
#import "AboutViewController.h"
#import "ListAlbumsSource.h"
#import "AppDelegate.h"
#import "CustomMasterCellBackground.h"

#import "MFSideMenu.h"

@interface SideMenuViewController ()

@property (strong, nonatomic) NSArray* mainScreenList;

@property (assign, nonatomic) int selectedIndex;

@end

@implementation SideMenuViewController

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
    
    self.mainScreenList = @[@"All Albums", @"Your Album", @"About"];

    self.selectedIndex = 0;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    // START NEW
    if (![cell.backgroundView isKindOfClass:[CustomMasterCellBackground class]]) {
        cell.backgroundView = [[CustomMasterCellBackground alloc] init];
    }
    
    if (![cell.selectedBackgroundView isKindOfClass:[CustomMasterCellBackground class]]) {
        cell.selectedBackgroundView = [[CustomMasterCellBackground alloc] init];
    }
    // END NEW
    
    
    if (indexPath.row == self.selectedIndex)
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"✓ %@", [self.mainScreenList objectAtIndex:indexPath.row]];
    else
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"  %@", [self.mainScreenList objectAtIndex:indexPath.row]];
    
    // [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.selectedIndex)
    {
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
            {

                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                ListAlbumsController *listAlbumsController = (ListAlbumsController *)[storyboard instantiateViewControllerWithIdentifier:@"ListAlbumsController"];

                listAlbumsController.dataSource = [[ListAlbumsSource alloc] init];
                listAlbumsController.dataSource.delegate = listAlbumsController;
                [listAlbumsController.dataSource getImageLinksFromServerAtPage:0];
                [listAlbumsController setUpCustomLayOut];

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
                
                
                [self.menuContainerViewController setCenterViewController:paneNavigationViewController];
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

                
            }


                break;
            case 1:
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                YourAlbumViewController *yourAlbumsController = (YourAlbumViewController *)[storyboard instantiateViewControllerWithIdentifier:@"YourAlbumViewController"];
                
                
                UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:yourAlbumsController];
                
                paneNavigationViewController.navigationBar.barStyle = UIBarStyleBlack;
                
                
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
                {
                    [yourAlbumsController setWantsFullScreenLayout:YES];
                    
                }
                else
                {
                    paneNavigationViewController.navigationBar.translucent = YES;
                }
                
                
                [self.menuContainerViewController setCenterViewController:paneNavigationViewController];
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
                
                

            }

                break;

            case 2:
            {
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                AboutViewController *aboutViewController = (AboutViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
                
                
                UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
                
                paneNavigationViewController.navigationBar.barStyle = UIBarStyleBlack;
                
                
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
                {
                    [aboutViewController setWantsFullScreenLayout:YES];
                    
                }
                else
                {
                    paneNavigationViewController.navigationBar.translucent = YES;
                }
                
                
                [self.menuContainerViewController setCenterViewController:paneNavigationViewController];
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];



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
