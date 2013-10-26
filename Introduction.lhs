Introduction
============

Welcome to this brief introduction to simulating physical systems with Yampa, a Haskell library for functional reactive programming (FRP).
This file is a _literate Haskell_ file.
You can compile or run it like a regular Haskell program using `ghc --make Introduction.lhs && ./Introduction` or `runhaskell Introduction.lhs`.

> import FRP.Yampa

The fundamental type of a Yampa network is the 'signal function', analogous to a block in a block diagram or Simulink model.
It is represented in code by the type `SF a b`, where `a` is the type of the input, and `b` that of the output.
An `SF Int Int` is, then, a signal function that takes an `Int` signal as input and produces another `Int` signal.

> system :: SF Int Int

This line just declares the type of the signal function `system` and is optional.
Haskell can often infer types automatically.
Our system is a composition of two other signal functions glued together output-to-input:

> system = gain 3 >>> offset 1

Next, we'll define the `gain` and `offset` functions.
They are not signal functions themselves, but construct signal functions when provided with an integer.
This is represented by the `Int ->` in their type signature.
Each of these functions is of domain `Int` (all integers) and range `SF Int Int` (as above, a signal function from `Int` to `Int`).

> gain, offset :: Int -> SF Int Int
> gain   x = arr (*x)
> offset x = arr (+x)

`arr` turns regular functions into 'arrows', an abstraction which Yampa uses to compose signal functions.
We've already used arrows when we connected `system` using the `>>>` function.

Finally, we're ready to simulate the system.
Yampa's `embed` function lets us run a signal through our system.
The format of the input signal is complex, but the important part is `[0 .. end]`, which constructs a list of values starting at 0 and incrementing by 1 to `end`.
The values in this list are fed as inputs to `system`.

> main = print $ embed fn signal
>     where fn = system
>           signal = deltaEncode dt [0 .. end]
>           dt = 0.1
>           end = 10
