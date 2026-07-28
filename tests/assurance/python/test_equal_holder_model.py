import random, unittest
MAG=2**128
class Model:
    def __init__(self):
        self.g=0; self.count=0; self.e={}; self.c={}; self.w={}; self.deposited=0
    def set(self,a,on):
        old=self.e.get(a,False)
        if old==on:return
        self.c[a]=self.c.get(a,0)+ (self.g if old else -self.g)
        self.e[a]=on; self.count += 1 if on else -1
    def deposit(self,v):
        if self.count:
            self.g += v*MAG//self.count; self.deposited += v
    def accum(self,a):return (self.g*(1 if self.e.get(a,False) else 0)+self.c.get(a,0))//MAG
    def claim(self,a):
        x=self.accum(a)-self.w.get(a,0); self.w[a]=self.w.get(a,0)+x; return x
class EqualHolderTests(unittest.TestCase):
    def test_unequal_balances_equal_weight(self):
        m=Model()
        for a in 'abc':m.set(a,True)
        m.deposit(90)
        self.assertEqual([m.accum(x) for x in 'abc'],[30,30,30])
    def test_exit_reentry_excludes_absence(self):
        m=Model();m.set('a',1);m.set('b',1);m.deposit(10);m.set('a',0);m.deposit(6);m.set('a',1);m.deposit(8)
        self.assertEqual(m.accum('a'),9);self.assertEqual(m.accum('b'),15)
    def test_random_state_never_negative(self):
        r=random.Random(7);m=Model();accounts=list(range(30))
        for _ in range(100000):
            a=r.choice(accounts)
            if r.random()<.55:m.set(a,not m.e.get(a,False))
            else:m.deposit(r.randrange(1,10**12))
            self.assertGreaterEqual(m.accum(a),0)
