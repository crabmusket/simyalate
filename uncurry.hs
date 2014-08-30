import FRP.Yampa

system :: SF (Int, Int) (Int, Int)
system = (arr $ uncurry (+)) >>> (identity &&& identity)

main = print $ embed fn signal
    where fn = system
          signal = deltaEncode dt $ replicate count (1, 2)
          dt = 0.1
          count = 10
