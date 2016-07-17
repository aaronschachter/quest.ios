#import <Foundation/Foundation.h>

@interface IVQGame : NSObject

@property (strong, nonatomic, readonly) NSArray *gameQuestions;

- (instancetype)initWithFirebaseId:(NSString *)id;
- (instancetype)initWithQuestions:(NSArray *)questions;

@end
