# oystercard_too
A small Ruby replication of the Oystercard system.

## Motivation
This is a second go at the challenge. Trying to reinforce prior learning.

## Build status
[![Build Status](https://travis-ci.com/chriswhitehouse/oystercard_too.svg?branch=main)](https://travis-ci.com/chriswhitehouse/oystercard_too)

## Code style
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)

## Screenshots
Include logo/demo screenshot etc.

## Tech/framework used
Ruby 2.7.1 with Rspec for testing.

## Features
### User Story 1
```
In order to use public transport
As a customer
I want money on my card
```

|Objects |Messages |
|---|---|
|Card | balance |

### User Story 2
```
In order to keep using public transport
As a customer
I want to add money to my card
```

|Objects |Messages |
|---|---|
|Card | add_money |

### User Story 3
```
In order to protect my money
As a customer
I don't want to put too much money on my card
```

|Objects |Messages |
|---|---|
|Card | MAXIMUM_BALANCE |

### User Story 4
```
In order to pay for my journey
As a customer
I need my fare deducted from my card
```

|Objects |Messages |
|---|---|
|Card | deduct_fare |

### User Story 5
```
In order to get through the barriers
As a customer
I need to touch in and out
```

|Objects |Messages |
|---|---|
|Card | touch_in, touch_out, in_journey? |

### User Story 6
```
In order to pay for my journey
As a customer
I need to have the minimum amount (£1) for a single journey
```

|Objects |Messages |
|---|---|
|Card | MINIMUM_BALANCE |

### User Story 7
```
In order to pay for my journey
As a customer
I need to pay for my journey when it's complete
```

|Objects |Messages |
|---|---|
|Card | deduct(), touch_out |

### User Story 8
```
In order to pay for my journey
As a customer
I need to know where I've travelled from
```

|Objects |Messages |
|---|---|
|Card | touch_in(entry_station), entry_station |

### User Story 9
```
In order to know where I have been
As a customer
I want to see to all my previous trips
```

|Objects |Messages |
|---|---|
|Card | touch_out(exit_station), exit_station, journeys |

### User Story 10
```
In order to know how far I have travelled
As a customer
I want to know what zone a station is in
```
|Objects |Messages |
|---|---|
|Station | name, zone  |

### User Story 11
```
In order to be charged correctly
As a customer
I need a penalty charge deducted if I fail to touch in or out
```

### User Story 12
```
In order to be charged the correct amount
As a customer
I need to have the correct fare calculated
```

## Code Example
Show what the library does as concisely as possible, developers should be able to figure out **how** your project solves their problem by looking at the code example. Make sure the API you are showing off is obvious, and that your code is short and concise.

## Installation
1. Create project folder `$ mkdir oystercard_too`
2. Clone or Fork Repository into project folder
3. Bundle gems with `$ bundle`
4. Check all tests are passing with `$ rspec`

## Tests
Describe and show how to run the tests with code examples.

## How to use?
Use IRB. Require each of:

## Credits
Built on the Makers Academy framework: [Oystercard](https://github.com/makersacademy/course/tree/master/oystercard)
