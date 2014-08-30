import FRP.Yampa

-- A feedback loop of the standard form from the link below.
system = feedback (-) (gain 5) (gain 0.1) 0

-- Construct a feedback loop with forward function 'a', reverse function 'b',
-- combine with 'f', and initial feedback value 'b0'.
-- http://upload.wikimedia.org/wikipedia/commons/e/ed/Ideal_feedback_model.svg
feedback :: (a -> a -> a) -> SF a a -> SF a a -> a -> SF a a
feedback f a b b0 = loopPre b0 inner
    where
        -- The inner function has two inputs and two outputs. Passing it to
        -- 'loopPre' produces a function with one input and one output, because
        -- inner's second output is connected to its second input.
        inner = unsplit >>> a >>> identity &&& b
        -- Combine elements of a tuple using 'f'.
        unsplit = arr $ \t -> fst t `f` snd t

main = print $ embed fn signal
    where fn = system
          signal = deltaEncode dt [start .. end]
          dt = 0.1
          start = 1
          end = 10

gain x = arr (*x)
