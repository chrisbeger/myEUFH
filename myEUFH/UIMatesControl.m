//
//  UIMatesControl.m
//  myEUFH
//
//  Created by Christoph Beger on 22.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import "UIMatesControl.h"
#import "UIMates.h"

@interface UIMatesControl ()

@end

@implementation UIMatesControl

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
    self.title = @"Kommilitonen";

    defaults = [NSUserDefaults standardUserDefaults];
    //Login Seite
    NSString * path = [NSString stringWithFormat:@"http://myeufh.beger.org/mobile.php?object=mates&mode=control&user=%i",[[defaults objectForKey:@"myeufh_userid"] integerValue]];
    //XML holen
    [self parseXMLFileAtURL:path];
    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dynamische Höhne der Zeilen, abhänging von Anzahl Status
    return (tableView.frame.size.height / [data count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell %i, %i",indexPath.section, indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    cell.textLabel.opaque = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.detailTextLabel.backgroundColor = [UIColor whiteColor];
    cell.detailTextLabel.opaque = YES;
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:20.0f];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir" size:16.0f];
    
    // Jetzt die Kursbezeichnung
    cell.textLabel.text = [NSString stringWithFormat:@"Kurs %@", [[data objectAtIndex:indexPath.row] objectForKey:@"course"]];
            
    return cell;
}

- (void)parseXMLFileAtURL:(NSString *)URL
{
	data = [[NSMutableArray alloc] init];
	
    //you must then convert the path to a proper NSURL or it won't work
    NSURL *xmlURL = [NSURL URLWithString:URL];
    // here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
    // this may be necessary only for the toolchain
    rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [rssParser setDelegate:self];
	
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
	
    [rssParser parse];
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Die Daten konnten nicht abgerufen werden.\nFehler %i", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Fehler" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"detail"]) {
		// clear out our story item caches...
		detail = [[NSMutableDictionary alloc] init];
		sCourseID = [[NSMutableString alloc] init];
        sCourseName = [[NSMutableString alloc] init];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
	if ([elementName isEqualToString:@"detail"]) {
		// save values to an item, then store that item into the array...
		[detail setObject:sCourseID forKey:@"id"];
		[detail setObject:sCourseName forKey:@"course"];
        
		[data addObject:[detail copy]];
        
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	// save the characters for the current item...
    // und die $ Zeichen mit & ersetzten
	if ([currentElement isEqualToString:@"id"]) {
		[sCourseID appendString:[string stringByReplacingOccurrencesOfString:@"$" withString:@"&"]];
	} else if ([currentElement isEqualToString:@"course"]) {
		[sCourseName appendString:[string stringByReplacingOccurrencesOfString:@"$" withString:@"&"]];
	}
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"matesControlToMates" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"matesControlToMates"]) {
        UIMates *mates = [segue destinationViewController];
        mates.nCourseID = [[[data objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
    }
}

@end
