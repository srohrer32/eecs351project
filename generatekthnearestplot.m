x = [1 3 2 6 2 7 1 9 2 8 7 4 7 3];
y = [6 3 8 2 6 3 4 1 2 7 2 5 6 5];
a = [2 5 1 3 5 8 2 3 8 4 6 3 2 4];
b = [1 2 6 4 5 7 3 4 6 1 3 7 7 6];

plot(x,y, 'x', 'Color', 'g'); 
hold on; 
plot(a,b, 'o', 'Color', 'r');
plot(3, 6.8, '.', 'MarkerSize', 20, 'Color', 'b');


t = 1:0.001:4*pi;
pyah = 3*cos(t) + 3;
dingle = 3*sin(t) + 6.8;
plot(pyah, dingle, '.', 'MarkerSize', 4, 'Color', 'k');
axis equal;