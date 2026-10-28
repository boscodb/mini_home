---
name: tdd-and-automated-tests
description: This skill provides you with the exact guidelines that you must follow when writing automated tests, including the tests you write for TDD purposes. Tests must primarily focus on the clarity of their INPUT, SUT (Subject Under Test), and Assert (EXPECTATION, ACTUAL).
---

# Essential format of the Test Data

The Test Data is the sole place where the INPUT and the EXPECTATION must be specified, and ideally fed in a parametrized manner to the Test Body.

# Essential format of the Test Function

The Test Function defines the SUT and feeds the paramterized INPUT to it, thus producing an ACTUAL output. This ACTUAL is then asserted/matched with the EXPECTATION to produce the tfinal Test Result.

# Example of a `correctly-formatted` Test for 'adding 2 numbers'.
``` pseudocode
``` pseudocode
import add_2_numbers

test_data = 
[{test_id = 1, INPUT__num1 = 2, INPUT__num2 = 3, EXPECTAION == 5},
{test_id = 2, INPUT__num1 = 1, INPUT__num2 = 7, EXPECTAION == 8},
{test_id = 3, INPUT__num1 = 1, INPUT__num2 = 1, EXPECTAION == 3}]

// Note: test_id 3 is deliberately incorrect, to better convey the Test Result.

@feed test_data
test_func(INPUT__num1, INPUT__num2, EXPECTATION) {
  SUT = add_2_numbers

  ACTUAL = SUT(INPUT__num1, INPUT__num2)

  assert(EXPECTATION, ACTUAL)
}


``` Test Result
2/3 Tests passed

test_id 3 failed; EXPECTED 3, Received 2
```
```
```
```
```

