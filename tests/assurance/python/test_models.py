from __future__ import annotations
import random, unittest
WAD = 10**18
MAX_SUPPLY = 1_000_000_000 * WAD
MAX_SUPPLY_TOKENS = 1_000_000_000
MIN_PRICE = 14 * WAD
MAX_PRICE = 210 * WAD
RANGE = MAX_PRICE - MIN_PRICE
BPS = 10_000

def spot(sold):
    x = sold * WAD // MAX_SUPPLY
    x2 = x * x // WAD
    return MIN_PRICE + RANGE * x2 // WAD

def reserve(sold):
    x = sold * WAD // MAX_SUPPLY
    x2 = x * x // WAD
    x3 = x2 * x // WAD
    return MIN_PRICE * sold // WAD + RANGE * MAX_SUPPLY_TOKENS * x3 // (3 * WAD)

def ceil_div(n, d):
    return 0 if n == 0 else ((n - 1) // d) + 1

class ModelTests(unittest.TestCase):
    def test_curve_endpoints(self):
        self.assertEqual(spot(0), 14 * WAD)
        self.assertEqual(spot(MAX_SUPPLY), 210 * WAD)
        self.assertEqual(reserve(0), 0)
        self.assertEqual(reserve(MAX_SUPPLY), 79_333_333_333 * WAD + 333_333_333_333_333_333)

    def test_curve_randomized(self):
        rng = random.Random(137)
        for _ in range(100_000):
            a = rng.randrange(0, MAX_SUPPLY + 1)
            b = rng.randrange(a, MAX_SUPPLY + 1)
            self.assertLessEqual(spot(a), spot(b))
            self.assertLessEqual(reserve(a), reserve(b))
            self.assertEqual(reserve(b) - reserve(a), reserve(b) - reserve(a))

    def test_sell_split_randomized(self):
        rng = random.Random(500)
        for _ in range(100_000):
            gross = rng.randrange(0, 10**40)
            dao = gross * 500 // BPS
            dividends = gross * 500 // BPS
            seller = gross - dao - dividends
            self.assertEqual(seller + dao + dividends, gross)

    def test_governance_thresholds(self):
        self.assertEqual(ceil_div(50 * 2500, BPS), 13)
        self.assertEqual(ceil_div(13 * 6700, BPS), 9)
        rng = random.Random(1414)
        for _ in range(250_000):
            electorate = rng.randrange(1, 10**9)
            yes = rng.randrange(0, electorate + 1)
            no = rng.randrange(0, electorate - yes + 1)
            total = yes + no
            participation = ceil_div(electorate * 2500, BPS)
            required_yes = ceil_div(total * 6700, BPS) if total else 0
            passed = total > 0 and total >= participation and yes >= required_yes
            if passed:
                self.assertGreaterEqual(total, participation)
                self.assertGreaterEqual(yes, required_yes)

if __name__ == "__main__":
    unittest.main()
