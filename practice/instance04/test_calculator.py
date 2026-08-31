import unittest

from calculator import safe_divide


class CalculatorTests(unittest.TestCase):
    def test_normal_division(self):
        self.assertEqual(safe_divide(9, 3), 3)

    def test_zero_is_rejected(self):
        with self.assertRaisesRegex(ValueError, "must not be zero"):
            safe_divide(9, 0)


if __name__ == "__main__":
    unittest.main()
