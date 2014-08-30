import FRP.Yampa
import Graphics.Gnuplot.Simple

system = force >>> displacement

force = constant (m * g)

displacement = feedback (-) (velocity >>> integrate) (gain $ k / m) 0
velocity     = feedback (-) (integrate)              (gain $ c / m) 0

m, g, k, c :: Double
m = 1
g = 9.81
k = 10
c = 1

main = plotPath [] (embed fn signal) where
    -- 'time' again integrates the timestep to provide a definite output time
    -- at each step, which we pass through to the output for plotting.
    fn = time >>> pass &&& system
    steps = 50
    dt = 0.1
    signal = deltaEncode dt $ replicate steps 0

integrate = imIntegral 0

pass = identity

gain x = arr (*x)

feedback op a b b0 = loopPre b0 inner
    where inner = arr (uncurry op) >>> a >>> (identity &&& b)
