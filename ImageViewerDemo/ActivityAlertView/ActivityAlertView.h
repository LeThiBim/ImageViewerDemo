//
//  Created by Huy Nguyen on 10/01/12.
//  Copyright (c) 2012 GNT Vietnam. All rights reserved.
//

@interface ActivityAlertView : UIAlertView
{
    UIActivityIndicatorView* _activityView;
}

- (void) close;

@end
