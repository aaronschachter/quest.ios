#import <Foundation/Foundation.h>

@interface IVQGame : NSObject

@property (strong, nonatomic, readonly) NSArray *gameQuestions;
@property (strong, nonatomic, readonly) NSDate *date;

- (instancetype)initWithFirebaseId:(NSString *)id;
- (instancetype)initWithQuestions:(NSArray *)questions;

@end
