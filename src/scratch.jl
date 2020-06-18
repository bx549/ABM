using Gadfly

t = [ 0.1:0.01:4; ]
f = 2 .^ t

plot(x=t, y=f, Geom.line)
