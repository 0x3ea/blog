---
date: '2026-05-16T16:11:07+08:00'
title: 'AtCoderBeginnerContest458'
categories:
  - XCPC
tags:
---
# A - Chompers
```Go
func solve(in *FastScanner, out *bufio.Writer) {
	s := in.Next()
	n := in.NextInt()
	fmt.Fprintln(out, s[n:len(s)-n])
}
```
# B - Count Adjacent Cells
```Go
func solve(in *FastScanner, out *bufio.Writer) {
	n, m := in.NextInt(), in.NextInt()
	for i := range n {
		for j := range m {
			ans := 0

			if i == 0 || i == n-1 {
				ans += 1
			} else {
				ans += 2
			}
			if m == 1 {
				ans--
			}

			if j == 0 || j == m-1 {
				ans += 1
			} else {
				ans += 2
			}

			if n == 1 {
				ans--
			}
			fmt.Fprint(out, ans, " ")
		}
		fmt.Fprintln(out)
	}
}
```
# C - C Stands for Center
```Go
func solve(in *FastScanner, out *bufio.Writer) {
	s := in.Next()
	var ans int64 = 0
	for i := 0; i < len(s); i++ {
		if s[i] == 'C' {
			r := int64(min(i+1, len(s)-i))
			ans += r
		}
	}
	fmt.Fprintln(out, ans)
}
```

# D - Chalkboard Median

动态维护中位数,用两个堆,一个小根堆维护大于中位数的数,一个大根堆维护小于中位数的数
```Go
type Heap[T any] struct {
	data []T
	less func(a, b T) bool
}

func NewHeap[T any](less func(a, b T) bool) *Heap[T] {
	return &Heap[T]{less: less}
}

func (h *Heap[T]) Len() int           { return len(h.data) }
func (h *Heap[T]) Less(i, j int) bool { return h.less(h.data[i], h.data[j]) }
func (h *Heap[T]) Swap(i, j int)      { h.data[i], h.data[j] = h.data[j], h.data[i] }
func (h *Heap[T]) Push(x any)         { h.data = append(h.data, x.(T)) }
func (h *Heap[T]) Pop() any           { old := h.data; x := old[len(old)-1]; h.data = old[:len(old)-1]; return x }

func (h *Heap[T]) PushVal(x T)    { heap.Push(h, x) }
func (h *Heap[T]) PopVal() T      { return heap.Pop(h).(T) }
func (h *Heap[T]) Top() T         { return h.data[0] }
func (h *Heap[T]) String() string { return fmt.Sprint(h.data) }

type Gate struct {
	pos, l, r int
}

var ans = make([]int, 100_010)

func solve(in *FastScanner, out *bufio.Writer) {
	x, q := in.NextInt(), in.NextInt()
	maxH := NewHeap[int](func(a, b int) bool {
		return a > b
	})
	minH := NewHeap[int](func(a, b int) bool {
		return a < b
	})
	maxH.PushVal(x)

	add := func(x int) {
		if x <= maxH.Top() {
			maxH.PushVal(x)
		} else {
			minH.PushVal(x)
		}
	}

	move := func() {
		for maxH.Len() > 0 && maxH.Len()-1 > minH.Len()+1 {
			minH.PushVal(maxH.PopVal())

		}
		for minH.Len() > 0 && maxH.Len() <= minH.Len() {
			maxH.PushVal(minH.PopVal())
		}
	}
	for range q {
		a, b := in.NextInt(), in.NextInt()
		if a > b {
			a, b = b, a
		}
		add(a)
		add(b)
		move()
		fmt.Fprintln(out, maxH.Top())
	}

}
```
# E - Count 123

1,3都必须与2相邻,所以先考虑放2

2能够提供 $x_2+1$ 个位置放1,3

再考虑放1,$i$ 表示从 $x_2+1$ 个位置里选 $i$ 个 放 1, $i\le min(x_2,x1)$,这个方案数是 $\binom{x_2+1}{i}$

这个 $i$ 个盒子放 $x_1$ 个 $1$ 的方案数是 $\binom{x_1-1}{i-1}$

再考虑放3,$j$ 表示从 $x_2+1-i$ 个位置里选 $j$ 个 放 $3$, $j\le min(x_2+1-i,x_3)$,这个方案数是 $\binom{x2+1-i}{j}$

这个 $j$ 个盒子放 $x_3$ 个 $3$ 的方案数是 $\binom{x_3-1}{j-1}$

用范德蒙卷积把内部的$\sum_j \binom{x2+1-i}{j}\binom{x_3-1}{j-1}$优化为

```Go
const n int32 = 2_000_000
const mod int64 = 998_244_353

var fac [n + 10]int64
var invfac [n + 10]int64

func solve(in *FastScanner, out *bufio.Writer) {
	fac[0] = 1
	for i := 1; i <= int(n); i++ {
		fac[i] = fac[i-1] * int64(i) % mod
	}
	invfac[n] = powMod(fac[n], mod-2, mod)
	for i := n - 1; i >= 0; i-- {
		invfac[i] = invfac[i+1] * int64(i+1) % mod
	}

	C := func(n, m int64) int64 {
		if n < 0 || m < 0 || n < m || n > int64(len(fac)-1) {
			return 0
		}
		return fac[n] * invfac[n-m] % mod * invfac[m] % mod
	}

	x1, x2, x3 := in.NextInt64(), in.NextInt64(), in.NextInt64()
	var ans int64 = 0
	for i := int64(1); i <= min(x1, x2); i++ {
		var res int64 = 1
		res = res * C(x2+int64(1), int64(i)) % mod
		res = res * C(x1-1, i-1) % mod

		res = res * C(x2+x3-i, x3) % mod
		ans = (ans + res) % mod
		// for j := int64(1); j <= min(x2+1-i, x3); j++ {
		// 	var t int64 = 1
		// 	t = t * C(x2+1-i, j) % mod
		// 	t = t * C(x3-1, j-1) % mod
		// ans = (ans + (res * t % mod)) % mod
		// }
	}
	fmt.Fprintln(out, ans)
}
```