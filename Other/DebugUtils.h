#import <Cocoa/Cocoa.h>

#ifdef DEBUG
#  define LOG(...) NSLog(__VA_ARGS__)
#  define LOGRECT(r) NSLog(@"(%.1fx%.1f)-(%.1fx%.1f)", r.origin.x, r.origin.y, r.size.width, r.size.height)
#  define __FUNC_NAME__ NSLog(NSStringFromSelector(_cmd));
#else
#  define LOG(...) ;
#  define LOGRECT(r) ;
#endif

