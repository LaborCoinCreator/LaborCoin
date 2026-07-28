import bisect
import random
import unittest


def total_members_before(timestamps, timestamp_exclusive):
    """Solidity-equivalent upper-midpoint binary search with zero-based data."""
    low = 0
    high = len(timestamps)
    while low < high:
        mid_member_number = low + ((high - low + 1) // 2)
        if timestamps[mid_member_number - 1] < timestamp_exclusive:
            low = mid_member_number
        else:
            high = mid_member_number - 1
    return low


class DeadlineElectorateTests(unittest.TestCase):
    def test_zero_members(self):
        self.assertEqual(total_members_before([], 100), 0)

    def test_strict_deadline_boundary(self):
        timestamps = [10, 20, 30, 40]
        self.assertEqual(total_members_before(timestamps, 30), 2)
        self.assertEqual(total_members_before(timestamps, 31), 3)

    def test_repeated_block_timestamps(self):
        timestamps = [10, 20, 20, 20, 30]
        self.assertEqual(total_members_before(timestamps, 20), 1)
        self.assertEqual(total_members_before(timestamps, 21), 4)

    def test_joiners_before_deadline_are_included(self):
        created_with = [10] * 50
        later_joiners = [20] * 50
        timestamps = created_with + later_joiners
        self.assertEqual(total_members_before(timestamps, 30), 100)
        self.assertEqual((100 * 25 + 99) // 100, 25)

    def test_post_deadline_growth_does_not_change_final_electorate(self):
        before_close = list(range(1, 101))
        final_at_close = total_members_before(before_close, 101)
        after_close = before_close + list(range(101, 201))
        self.assertEqual(final_at_close, 100)
        self.assertEqual(total_members_before(after_close, 101), 100)

    def test_randomized_against_linear_count(self):
        rng = random.Random(71)
        timestamps = []
        current = 1
        for _ in range(250_000):
            current += rng.randrange(0, 3)
            timestamps.append(current)
        for _ in range(10_000):
            deadline = rng.randrange(0, current + 3)
            expected = bisect.bisect_left(timestamps, deadline)
            self.assertEqual(total_members_before(timestamps, deadline), expected)


if __name__ == "__main__":
    unittest.main()
