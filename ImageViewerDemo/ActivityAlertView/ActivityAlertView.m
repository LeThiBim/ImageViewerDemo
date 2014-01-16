//
//  Created by Huy Nguyen on 10/01/12.
//  Copyright (c) 2012 GNT Vietnam. All rights reserved.
//

#import "ActivityAlertView.h"

@implementation ActivityAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		_activityView = [[UIActivityIndicatorView alloc] init];
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [_activityView sizeToFit];

        _activityView.frame = CGRectMake(125, 60, _activityView.frame.size.width, _activityView.frame.size.height);
        [self addSubview:_activityView];

		[_activityView startAnimating];
    }
    return self;
}

- (void) dealloc
{
	_activityView = nil;
}

- (void) close
{
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

@end
