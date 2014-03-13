//
//  JBCardiacEventTestViewController.m
//  APIExplorer
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBCardiacEventTestViewController.h"

#import "UP.h"

@interface JBCardiacEventTestViewController ()

@end

@implementation JBCardiacEventTestViewController

- (void)postCardiacEvent
{
	UPCardiacEvent *newEvent = [UPCardiacEvent eventWithTitle:@"Heart Stuff" heartRate:@(120) systolicPressure:@(50) diastolicPressure:@(70) note:@"Just testing" imageURL:@"http://eofdreams.com/data_images/dreams/heart/heart-03.jpg"];
	[UPCardiacEventAPI postCardiacEvent:newEvent completion:^(UPCardiacEvent *event, UPURLResponse *response, NSError *error) {
		[self showResults:event];
	}];
}

- (void)getCardiacEvents
{
	[UPCardiacEventAPI getCardiacEventsWithCompletion:^(NSArray *events, UPURLResponse *response, NSError *error) {
		[self showResults:events];
	}];
}

- (void)refreshCardiacEvent
{
	[UPCardiacEventAPI getCardiacEventsWithCompletion:^(NSArray *events, UPURLResponse *response, NSError *error) {
		if (events.count > 0)
		{
			[UPCardiacEventAPI refreshCardiacEvent:events[0] completion:^(UPCardiacEvent *event, UPURLResponse *response, NSError *error) {
				[self showResults:event];
			}];
		}
	}];
}

- (void)deleteCardiacEvent
{
	[UPCardiacEventAPI getCardiacEventsWithCompletion:^(NSArray *events, UPURLResponse *response, NSError *error) {
		if (events.count > 0)
		{
			[UPCardiacEventAPI deleteCardiacEvent:events[0] completion:^(id result, UPURLResponse *response, NSError *error) {
				[self showResults:response.metadata];
			}];
		}
	}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
	{
		case 0:
			[self postCardiacEvent];
			break;
			
		case 1:
			[self getCardiacEvents];
			break;
			
		case 2:
			[self refreshCardiacEvent];
			break;
			
		case 3:
			[self deleteCardiacEvent];
			break;
			
		default:
			break;
	}
}

@end
