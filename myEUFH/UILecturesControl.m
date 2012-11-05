//
//  UILecturesControl.m
//  myEUFH
//
//  Created by Christoph Beger on 18.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import "UILecturesControl.h"
#import "UILectures.h"

@interface UILecturesControl ()

@end

@implementation UILecturesControl

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
    self.title = @"Vorlesungen";
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dynamische Höhne der Zeilen, abhänging von Anzahl Status
    return (tableView.frame.size.height / 3);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell %i, %i",indexPath.section, indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:20.0f];
     cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir" size:16.0f];
    cell.textLabel.opaque = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.detailTextLabel.backgroundColor = [UIColor whiteColor];
    cell.detailTextLabel.opaque = YES;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Heute";
        cell.detailTextLabel.text = @"Dein Vorlesungstag";;
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"Diese Woche";
        cell.detailTextLabel.text = @"Überblick über deine Vorlesungswoche";;
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"Alle Termine";
        cell.detailTextLabel.text = @"All deine Vorlesungstermine";;
    }
    
    return cell;
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
    [self performSegueWithIdentifier:@"lectureControlToLecture" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"lectureControlToLecture"]) {
        NSIndexPath *indexPath= [self.tableView indexPathForSelectedRow];
        UILectures *lectures = [segue destinationViewController];
        switch (indexPath.row) {
            case 0:
                lectures.nModeID = 1;
                break;
            case 1:
                lectures.nModeID = 2;
                break;
            case 2:
                lectures.nModeID = 3;
                break;
            default:
                break;
        }
    }
}

@end
