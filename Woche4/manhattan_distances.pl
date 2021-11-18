:-module(manhattan_distances,[a/2,b/2,c/2,d/2,e/2,f/2,g/2,h/2,i/2]).

% Tabled version for Mnahttan distances to reduce time complexity
% [a,b,c,d,e,f,g,h,i] is the puzzle field
% first value of each fact is the tile placed in the field,
% the second gives the manhttan distance of that tile to its correct position 
a(0,0). a(1,1). a(2,2). a(3,1). a(4,2). a(5,3). a(6,2). a(7,3). a(8,4).
b(0,1). b(1,0). b(2,1). b(3,2). b(4,1). b(5,2). b(6,3). b(7,2). b(8,3).
c(0,2). c(1,1). c(2,0). c(3,3). c(4,2). c(5,1). c(6,4). c(7,3). c(8,2).
d(0,1). d(1,2). d(2,3). d(3,0). d(4,1). d(5,2). d(6,1). d(7,2). d(8,3).
e(0,2). e(1,1). e(2,2). e(3,1). e(4,0). e(5,1). e(6,2). e(7,1). e(8,2).
f(0,3). f(1,2). f(2,1). f(3,2). f(4,1). f(5,0). f(6,3). f(7,2). f(8,1).
g(0,2). g(1,3). g(2,4). g(3,1). g(4,2). g(5,3). g(6,0). g(7,1). g(8,2).
h(0,3). h(1,2). h(2,3). h(3,2). h(4,1). h(5,2). h(6,1). h(7,0). h(8,1).
i(0,4). i(1,3). i(2,2). i(3,3). i(4,2). i(5,1). i(6,2). i(7,1). i(8,0).