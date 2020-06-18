# fiddling with the post from
# https://doktormike.gitlab.io/post/covid-19/

using DifferentialEquations
using Gadfly
using DataFrames

function seir_ode(dY,Y,p,t)
    beta, sigma, gamma, mu = p[1], p[2], p[3], p[4]
    S, E, I = Y[1], Y[2], Y[3]
    dY[1] = mu*(1-S)-beta*S*I
    dY[2] = beta*S*I-(sigma+mu)*E
    dY[3] = sigma*E - (gamma+mu)*I
end

# 
function seir(beta, sigma, gamma, mu, tspan=(0.0,100.0);
              S0=0.99, E0=0, I0=0.01, R0=0)
    par=[beta, sigma, gamma, mu]
    init=[S0, E0, I0]
    seir_prob = ODEProblem(seir_ode,init,tspan,par)
    sol = solve(seir_prob);

    # recovered population is computed from the other 3
    R = ones(1,size(sol)[2]) - sum(sol,dims=1);

    # return a data frame in "long" format
    n = length(sol.t)
    DataFrame(
        t = repeat(sol.t, outer=[4]),
        val = vcat(sol[1,:], sol[2,:], sol[3,:], R[1,:]),
        series = vcat(fill("Susceptible",n), fill("Exposed",n),
                      fill("Infected",n), fill("Recovered",n)),
    )
end

r0(beta, sigma, gamma, mu) = (sigma/(sigma+mu))*(beta/(gamma+mu))

p = 0.04      # probability of transmitting the virus when you meet someone
n = 10        # avg number of people you meet per day
beta = p*n    # infection rate (from S to E) = p*n
sigma = 0.25  # incubation period: 4 days on avg from E to I
gamma = 0.143 # recovery rate
mu = 6e4/(5.8e6*365) # birth/death rate ( for Denmark it's 6e4/(5.8e6 * 365) )
# note that mu is per day as a fraction of the total population

tspan=(0.0,100.0)
S0=0.99   # initial conditions
E0=0
I0=0.01
R0=0

df = seir(beta, sigma, gamma, mu, tspan)

println("basic reproduction number = ",
        round(r0(beta,sigma,gamma,mu), digits=2))

plot(df, x=:t, y=:val, color=:series, Geom.line)
