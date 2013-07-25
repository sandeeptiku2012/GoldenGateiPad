// #define RUN_SLOW_TESTS

#ifndef RUN_SLOW_TESTS
#define __SLOW_TEST__ { NSLog(@"Warning! Ignoring %@::%@", [self class], NSStringFromSelector(_cmd)); return;}
#else
#define __SLOW_TEST__ {}
#endif
