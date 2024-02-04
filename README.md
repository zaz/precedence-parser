# PEMDAS Parser

The inventor's paradox is that often a general solution is easier than a specific solution. So this parser takes in a list of symbols, a list of commands, and a string. It splits the string recursively by each symbol in the list, forming a tree of commands. It also parses the leafs as numbers.

During implementation, I discovered that PEMDAS is a lie! If we group multiplication before division we get this:

$$ 2 × 3 / 4 × 5 = (2 × 3) / (4 × 5) $$

Instead of the correct version:

$$ 2 × 3 / 4 × 5 = 2 × ( 3 / 4) × 5 $$

So it is actually PEDMSA along with a left-to-right rule on division and a right-to-left rule on exponentiation.
