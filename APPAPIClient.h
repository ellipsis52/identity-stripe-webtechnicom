#import <StripeTerminal/StripeTerminal.h>

// Example API client class for communicating with your backend
@interface APPAPIClient : NSObject <SCPConnectionTokenProvider>

// For simplicity, this example class is a singleton
+ (instancetype)shared;

@end