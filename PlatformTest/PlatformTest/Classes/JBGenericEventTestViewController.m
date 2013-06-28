//
//  JBGenericEventTestViewController.m
//  PlatformTest
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBGenericEventTestViewController.h"

#import "UP.h"

@interface JBGenericEventTestViewController ()

@end

@implementation JBGenericEventTestViewController

- (void)postGenericEvent
{
	UPGenericEvent *newEvent = [UPGenericEvent eventWithTitle:@"Generic Event" verb:@"tested the API" attributes:nil note:@"Here's a note." image:nil];
	[UPGenericEventAPI postGenericEvent:newEvent completion:^(UPGenericEvent *event, UPURLResponse *response, NSError *error) {
		[self showResults:event];
	}];
}

- (void)getGenericEvents
{
	[UPGenericEventAPI getGenericEventsWithCompletion:^(NSArray *events, UPURLResponse *response, NSError *error) {
		[self showResults:events];
	}];
}

- (void)refreshEvent
{
	[UPGenericEventAPI getGenericEventsWithCompletion:^(NSArray *events, UPURLResponse *response, NSError *error) {
		if (events.count > 0)
		{
			[UPGenericEventAPI refreshGenericEvent:events[0] completion:^(UPGenericEvent *event, UPURLResponse *response, NSError *error) {
				[self showResults:event];
			}];
		}
	}];
}

- (void)deleteEvent
{
	[UPGenericEventAPI getGenericEventsWithCompletion:^(NSArray *events, UPURLResponse *response, NSError *error) {
		if (events.count > 0)
		{
			[UPGenericEventAPI deleteGenericEvent:events[0] completion:^(UPGenericEvent *event, UPURLResponse *response, NSError *error) {
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
			[self postGenericEvent];
			break;
			
		case 1:
			[self getGenericEvents];
			break;
			
		case 2:
			[self refreshEvent];
			break;
			
		case 3:
			[self deleteEvent];
			break;
			
		default:
			break;
	}
}

@end
