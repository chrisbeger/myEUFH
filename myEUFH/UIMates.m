//
//  UIMates.m
//  myEUFH
//
//  Created by Christoph Beger on 18.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import "UIMates.h"
#import "UIMatesDetail.h"

@interface UIMates ()

@end

@implementation UIMates
@synthesize nCourseID;
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
    
    self.title= @"Kommilitonen";
    
    firstletters = [[NSMutableArray alloc] init];
    flcount =[[NSMutableArray alloc] init];
    defaults = [NSUserDefaults standardUserDefaults];
    //Login Seite
    NSString * path = [NSString stringWithFormat:@"http://myeufh.beger.org/mobile.php?object=mates&mode=all&class=%i",nCourseID];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [firstletters count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

        return [firstletters objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return [[flcount objectAtIndex:section] integerValue];
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
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:16.0f];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir" size:12.0f];
    
    if (indexPath.section == 0) {
    // Jetzt die Kursbezeichnung
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[data objectAtIndex:indexPath.row] objectForKey:@"name"]];
    }
    else {
        int currentRowCount=0;
        for (int var = 0; var < indexPath.section; var++) {
            currentRowCount = currentRowCount + [[flcount objectAtIndex:var] integerValue];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[data objectAtIndex:currentRowCount+indexPath.row] objectForKey:@"name"]];
    }
        
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
		sMateID = [[NSMutableString alloc] init];
        sMateMail = [[NSMutableString alloc] init];
        sMateName = [[NSMutableString alloc] init];
        sMatePhone = [[NSMutableString alloc] init];
        currentFirstLetter = [[NSMutableString alloc] init];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
	if ([elementName isEqualToString:@"detail"]) {
		// save values to an item, then store that item into the array...
		[detail setObject:sMateID forKey:@"id"];
		[detail setObject:sMateMail forKey:@"mail"];
        [detail setObject:sMateName forKey:@"name"];
        [detail setObject:sMatePhone forKey:@"phone"];
        [detail setObject:currentFirstLetter forKey:@"firstletter"];
        
        // Hier geht um die Sectiones
        // Wieviele Buchstaben kommen wie oft vor
        // wird alles in das flcount und firstletter array geschrieben
        if(![firstletters containsObject:[currentFirstLetter capitalizedString]])
        {
            [firstletters addObject:currentFirstLetter];
            [flcount addObject:[NSNumber numberWithInt:1]];
        }
        
        else{
            int index = 0;
            int count;
            
            index = [firstletters count];
            if (index > 0) {
                index = index -1;
                count = [[flcount objectAtIndex:index] integerValue] + 1;
                
                [flcount replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:count]];
                
            }
            
            
        }
        
		[data addObject:[detail copy]];
        
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	// save the characters for the current item...
    // und die $ Zeichen mit & ersetzten
	if ([currentElement isEqualToString:@"id"]) {
		[sMateID appendString:[string stringByReplacingOccurrencesOfString:@"$" withString:@"&"]];
	} else if ([currentElement isEqualToString:@"name"]) {
		[sMateName appendString:[string stringByReplacingOccurrencesOfString:@"$" withString:@"&"]];
    } else if ([currentElement isEqualToString:@"phone"]) {
		[sMatePhone appendString:[string stringByReplacingOccurrencesOfString:@"$" withString:@"&"]];
    } else if ([currentElement isEqualToString:@"mail"]) {
		[sMateMail appendString:[string stringByReplacingOccurrencesOfString:@"$" withString:@"&"]];
	} else if ([currentElement isEqualToString:@"firstletter"]) {
		[currentFirstLetter appendString:[string stringByReplacingOccurrencesOfString:@"$" withString:@"&"]];
	}
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"matesToMatesDetails" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if([segue.identifier isEqualToString:@"matesToMatesDetails"]) {
        UIMatesDetail *matesDetails = [segue destinationViewController];
        matesDetails.title = @"Details";
        if (indexPath.section == 0) {
            matesDetails.currentPhone =  [[data objectAtIndex:indexPath.row] objectForKey:@"phone"];
            matesDetails.currentName =  [[data objectAtIndex:indexPath.row] objectForKey:@"name"];
            matesDetails.currentMail =  @"";
        }
        else {
            int currentRowCount=0;
            for (int var = 0; var < indexPath.section; var++) {
                currentRowCount = currentRowCount + [[flcount objectAtIndex:var] integerValue];
            }
            matesDetails.currentPhone =  [[data objectAtIndex:currentRowCount +indexPath.row] objectForKey:@"phone"];
            matesDetails.currentName =  [[data objectAtIndex:currentRowCount +indexPath.row] objectForKey:@"name"];
            matesDetails.currentMail =  @"";
            
            
        }
    }
}




@end
