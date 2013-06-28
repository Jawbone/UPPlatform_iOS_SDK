//
//  JBBodyEventTestViewController.m
//  PlatformTest
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBBodyEventTestViewController.h"

#import "UP.h"

@interface JBBodyEventTestViewController ()

@end

@implementation JBBodyEventTestViewController

- (void)postBodyEvent
{
	UPBodyEvent *bodyEvent = [UPBodyEvent eventWithTitle:@"160 lbs." weight:@(72.5748) bodyFat:@(20) leanMass:@(20) bmi:@(22) note:@"Weigh-in created by My App." image:nil];
	[UPBodyEventAPI postBodyEvent:bodyEvent completion:^(UPBodyEvent *event, UPURLResponse *response, NSError *error) {
		[self showResults:event];
	}];
}

- (void)getBodyEvents
{
	[UPBodyEventAPI getBodyEventsWithCompletion:^(NSArray *events, UPURLResponse *response, NSError *error) {
		[self showResults:events];
	}];
}

- (void)refreshBodyEvent
{
	[UPBodyEventAPI getBodyEventsWithCompletion:^(NSArray *events, UPURLResponse *response, NSError *error) {
		if (events.count > 0)
		{
			[UPBodyEventAPI refreshBodyEvent:events[0] completion:^(UPBodyEvent *event, UPURLResponse *response, NSError *error) {
				[self showResults:event];
			}];
		}
	}];
}

- (void)deleteBodyEvent
{
	[UPBodyEventAPI getBodyEventsWithCompletion:^(NSArray *events, UPURLResponse *response, NSError *error) {
		if (events.count > 0)
		{
			[UPBodyEventAPI deleteBodyEvent:events[0] completion:^(id result, UPURLResponse *response, NSError *error) {
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
			[self postBodyEvent];
			break;
			
		case 1:
			[self getBodyEvents];
			break;
			
		case 2:
			[self refreshBodyEvent];
			break;
			
		case 3:
			[self deleteBodyEvent];
			break;
			
		default:
			break;
	}
}

@end
