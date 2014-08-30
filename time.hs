import FRP.Yampa
import Text.Printf

-- 'time' outputs a constantly-increasing value representing the accumulated
-- time. The 'dt' value in the main function determines the timestep, encoded
-- into the signal and ignored in the previous examples. Here we make a
-- contrived example that generates values of sin(t).
system :: SF Time Double
system = time >>> arr sin

-- Use pretty printing!
main = mapM_ (printf "%.3f\n") $ embed fn signal
    where fn = system
          steps = 4
          dt = pi / steps
          signal = deltaEncode dt [0 .. steps]
