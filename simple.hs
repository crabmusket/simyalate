import FRP.Yampa

-- Read 'SF' as 'signal function'. An 'SF Int Int' is therefore a signal with an
-- Int input and an Int output. This line just declares a type and is optional.
-- Haskell can normally deduce types automatically.
system :: SF Int Int

-- Our system is a composition of two other stream functions glued together
-- output-to-input.
system = gain 3 >>> offset 1

-- These functions construct signal functions from an int.
gain, offset :: Int -> SF Int Int

-- 'arr' turns regular functions into 'arrows', an abstraction which Yampa uses
-- to compose signal functions.
gain   x = arr (*x)
offset x = arr (+x)

-- Run a signal through the system.
main = print $ embed fn signal
    where fn = system
          signal = deltaEncode dt [0 .. end]
          dt = 0.1
          end = 10
