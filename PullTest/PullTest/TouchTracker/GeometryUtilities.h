
void getPointsFromBezier(void *info, const CGPathElement *element);
NSArray *pointsFromBezierPath(UIBezierPath *bpath);

CGPoint getRectCenter(CGRect rect);
CGPoint getRectUpperCenter(CGRect rect);
CGPoint getRectLowerCenter(CGRect rect);

CGRect rectAroundCenter(CGPoint center, float dx, float dy);
float dotproduct(CGPoint v1, CGPoint v2);
BOOL isClockwise(CGPoint v1, CGPoint v2);
float distance(CGPoint p1, CGPoint p2);
CGPoint pointWithOrigin(CGPoint pt, CGPoint origin);
CGRect boundingRect(NSArray *points);

float getTransitTolerance(CGPoint center, NSArray *points, float positive);
CGRect testForLetterO(NSArray *points, NSDate *firstTouchDate);
CGRect testForLetterS(NSArray *points, NSDate *firstTouchDate);
char *guessLetter(NSArray *points);