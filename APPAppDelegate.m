#import "APPAppDelegate.h"
#import <StripeTerminal/StripeTerminal.h>
#import "APPAPIClient.h"

@implementation APPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SCPTerminal setTokenProvider:[APPAPIClient shared]];
    // ...
    return YES;
}

// ...

@end




