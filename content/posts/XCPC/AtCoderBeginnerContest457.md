---
date: '2026-05-10T13:54:50+08:00'
title: 'AtCoder Beginner Contest4 57'
categories:
    - XCPC
tags:
---

# A - Array

```Go
func solve(in *FastScanner, out *bufio.Writer) {
	n := in.NextInt()
	a := make([]int, n)
	for i := 0; i < n; i++ {
		a[i] = in.NextInt()
	}
	p := in.NextInt()
	fmt.Fprintln(out, a[p-1])
}

```

# B - Arrays

```Go
func solve(in *FastScanner, out *bufio.Writer) {
	n := in.NextInt()
	a := make([][]int, n)
	for i := 0; i < n; i++ {
		l := in.NextInt()
		a[i] = make([]int, l)
		for j := 0; j < l; j++ {
			a[i][j] = in.NextInt()
		}
	}
	x := in.NextInt()
	y := in.NextInt()
	fmt.Fprintln(out, a[x-1][y-1])
}
```

# C - Long Sequence

```Go
func solve(in *FastScanner, out *bufio.Writer) {
	n := in.NextInt64()
	k := in.NextInt64()
	a := make([][]int, n)
	for i := int64(0); i < n; i++ {
		l := in.NextInt()
		a[i] = make([]int, l)
		for j := 0; j < l; j++ {
			a[i][j] = in.NextInt()
		}
	}
	c := make([]int64, n)
	for i := int64(0); i < n; i++ {
		c[i] = in.NextInt64()
	}
	for i := int64(0); i < n && k > 0; i++ {
		length := int64(len(a[i]))
		if k-length*c[i] <= 0 {
			k %= length
			fmt.Fprintln(out, a[i][(k-1+length)%length])

		}
		k -= length * c[i]
	}
}
```
# D - Raise Minimum

二分答案
```Go
func solve(in *FastScanner, out *bufio.Writer) {
	n := in.NextInt()
	k := in.NextInt64()
	a := make([]int64, n)
	for i := 0; i < n; i++ {
		a[i] = in.NextInt64()
	}
	l := int64(1)
	r := int64(3_000_000_000_000_000_000)
	chk := func(x int64) bool {
		tar := k
		for idx, val := range a {
			if val >= x {
				continue
			}
			div := int64(idx + 1)
			tar -= (x - val + div - 1) / div
			if tar < int64(0) {
				return false
			}
		}
		return true
	}
	for l < r {
		mid := (l + r + 1) >> 1
		if chk(mid) {
			l = mid
		} else {
			r = mid - 1
		}
	}
	fmt.Fprintln(out, l)
}
```

# E - Crossing Table Cloth 

```Go
func solve(in *FastScanner, out *bufio.Writer) {
	n, m := in.NextInt(), in.NextInt()
	mp := make(map[Pair]int)
	le := make([][]int, n+1)
	ri := make([][]int, n+1)
	minRAL := make([]int, n+2)
	for i := range minRAL {
		minRAL[i] = 1_000_000_000
	}
	for range m {
		s, t := in.NextInt(), in.NextInt()
		minRAL[s] = min(minRAL[s], t)
		mp[Pair{s, t}]++
		le[t] = append(le[t], s)
		ri[s] = append(ri[s], t)
	}
	for i := n; i >= 1; i-- {
		minRAL[i] = min(minRAL[i+1], minRAL[i])
		slices.Sort(le[i])
		slices.Sort(ri[i])
	}
	q := in.NextInt()
	for range q {
		s, t := in.NextInt(), in.NextInt()
		if mp[Pair{s, t}] > 0 {
			ok := false
			ok = ok || mp[Pair{s, t}] >= 2
			ok = ok || minRAL[s] <= t-1
			ok = ok || minRAL[s+1] <= t
			if ok {
				fmt.Fprintln(out, "Yes")
			} else {
				fmt.Fprintln(out, "No")
			}
			continue
		}

		posr := sort.Search(len(ri[s]), func(i int) bool {
			return ri[s][i] > t
		}) - 1
		posl := sort.Search(len(le[t]), func(i int) bool {
			return le[t][i] >= s
		})
		if posr >= 0 && posl < len(le[t]) {
			posr = ri[s][posr]
			posl = le[t][posl]

			if posr+1 >= posl {
				fmt.Fprintln(out, "Yes")
				continue
			}
		}

		fmt.Fprintln(out, "No")
	}

}
```
# F - Second Gap
```Go

```

# G - Catch All Apples
```Go
```
