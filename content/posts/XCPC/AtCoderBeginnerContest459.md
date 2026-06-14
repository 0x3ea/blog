---
date: '2026-05-23T21:15:47+08:00'
title: 'AtCoderBeginnerContest459'
categories:
  - XCPC
tags:
---
# A - Hell, World!
```Go
func solve(in *FastScanner, out *bufio.Writer) {

	s := "HelloWorld"
	n := in.NextInt()
	for idx, val := range s {
		if idx == n-1 {
			continue
		}
		fmt.Fprintf(out, "%c", val)
	}
}
```
# B - 459
```Go
func solve(in *FastScanner, out *bufio.Writer) {
	n := in.NextInt()
	for range n {
		s := in.Next()
		if s[0] <= 'o' {
			t := (s[0]-'a')/3 + 2
			fmt.Fprint(out, t)
		} else if s[0] >= 'p' && s[0] <= 's' {
			fmt.Fprint(out, 7)
		} else if s[0] >= 't' && s[0] <= 'v' {
			fmt.Fprint(out, 8)
		} else {
			fmt.Fprint(out, 9)
		}
	}
}
```
# C - Drop Blocks

`cnt[i]` 表示第 `i` 格放了多少块

`num[i]` 表示有多少位置的数量 $\ge i$

`mn` 表示 发生了多少次全局 `-1`

注意判断 $y+mn < q$

```Go
func solve(in *FastScanner, out *bufio.Writer) {
	n, q := in.NextInt(), in.NextInt()
	cnt := make([]int, n+1)
	num := make([]int, q+1)
	mn := 0
	for range q {
		opt, val := in.NextInt(), in.NextInt()
		if opt == 1 {
			cnt[val]++
			num[cnt[val]]++
			if num[cnt[val]] == n {
				mn = cnt[val]
			}
		} else {
			if val+mn > q {
				fmt.Fprintln(out, 0)
			} else {
				fmt.Fprintln(out, num[val+mn])
			}
		}
	}
}
```
# D - Adjacent Distinct String

鸽巢原理的结论

最多的数量不超过 $\left\lceil \frac{n}{2} \right\rceil$ 即可

相邻不相等，那数量最多的字符一定是放在 `1,3,5...` ，如果这个数量大于 $\left\lceil \frac{n}{2} \right\rceil$，那一定有一个放在了偶数位置

放置方案就是先把最多的放奇数位，其他数字继续填奇数位(如果还有位置)，剩下的随便放即可

比如:

`1 2 1 2 1 4 3 4 3`
```Go
func solve(in *FastScanner, out *bufio.Writer) {
	n := in.NextInt()
	var cnt [26]int
	for range n {
		for i := range cnt {
			cnt[i] = 0
		}

		s := in.Next()
		cho := 0
		for _, val := range s {
			cnt[int32(val-'a')]++
			if cnt[int32(val-'a')] > cnt[cho] {
				cho = int(val - 'a')
			}
		}
		if cnt[cho] > (len(s)+1)/2 {
			fmt.Fprintln(out, "No")
		} else {
			fmt.Fprintln(out, "Yes")
			ans := make([]byte, len(s))

			p := 0
			idx := 0
			for ; p < len(s) && cnt[cho] > 0; p += 2 {
				ans[p] = byte('a' + cho)
				cnt[cho]--
			}

			for ; p < len(s); p += 2 {
				for cnt[idx] == 0 {
					idx++
				}
				ans[p] = byte('a' + idx)
				cnt[idx]--
			}
			p = 1
			for ; p < len(s); p += 2 {
				for cnt[idx] == 0 {
					idx++
				}
				ans[p] = byte('a' + idx)
				cnt[idx]--
			}
			fmt.Fprintln(out, string(ans))
		}
	}
}
```
# E - Select from Subtrees

以样例`1`为例子

$f_i$ 表示以 $i$ 为根的子树的方案数


先考虑叶子的方案数:

$f_4=\binom{C_4}{D_4},f_5=\binom{C_5}{D_5}$

怎么从叶子转移到父节点，比如`3`号点

$f_3=f_4 * f_5 *\binom{剩余可选节点}{D_3}$

剩余可选点可以在 `dp` 的时候顺便算出来

注意 $C_i$ 很大，算组合数时需要直接用$\binom{n}{m}=\frac{n*(n-1)*...*(n-m+1)}{m!}$

$m!$ 可以预处理
```Go
var fac [1_000_100]int64

// 处理阶乘的逆元
fac[1] = 1
for i := 2; i <= 1_000_000; i++ {
  fac[i] = fac[i-1] * int64(i) % mod
}
fac[1_000_000] = powMod(fac[1_000_000], mod-2, mod)
for i := 1_000_000 - 1; i >= 1; i-- {
  fac[i] = fac[i+1] * int64(i+1) % mod
}

const mod = 998_244_353

func solve(in *FastScanner, out *bufio.Writer) {
	n := in.NextInt()
	e := make([][]int, n+1)
	c := make([]int64, n+1)
	d := make([]int64, n+1)
	f := make([]int64, n+1)
	for i := 2; i <= n; i++ {
		x := in.NextInt()
		e[x] = append(e[x], i)
	}
	for i := 1; i <= n; i++ {
		c[i] = in.NextInt64()
	}
	for i := 1; i <= n; i++ {
		d[i] = in.NextInt64()
	}

	C := func(n, m int64) int64 {
		if m > n {
			return int64(0)
		}
		ans := int64(1)
		for i := n; i >= n-m+1; i-- {
			ans = ans * int64(i) % mod
		}
		ans = ans * fac[m] % mod
		return ans
	}

	var dfs func(int)
	dfs = func(x int) {
		if len(e[x]) == 0 {
			f[x] = C(c[x], int64(d[x]))
			return
		}
		totnum := c[x]
		totsub := int64(0)
		for _, to := range e[x] {
			dfs(to)
			totsub += d[to]
			totnum = (totnum + c[to]) % mod
		}
		f[x] = 1
		for _, to := range e[x] {
			f[x] = f[x] * f[to] % mod
		}
		f[x] = f[x] * C((totnum-totsub+mod)%mod, d[x]) % mod
		c[x] = totnum
		d[x] = d[x] + totsub
	}
	dfs(1)

	fmt.Fprintln(out, f[1])

}
```

# F - -1, +1

题目要求 $A_i < A_{i+1}$ ,可以转化为 $ B_i =A_i -i$

这样等效为 $ B_i \le B_{i+1}$

令操作后的 $B$ 数组为 $C$ ,它们的前缀和分别为$ Sb,Sc$

每对 $i$ 操作时，$B_i-1,B_{i+1}+1$,可以转化为 $B_i$ 的前缀和 $(Sb_i)$ 的和 $-1$

那么答案就是 $\sum_{i=1}^n Sb_i-Sc_i $，$Sb_i$ 是固定值，所以要让 $\sum_{i=1}^n Sc_i $ 尽可能大

现在的问题转化为:

保证 $ B_i \le B_{i+1}$ 的前提下，让 $\sum_{i=1}^n Sc_i $ 尽可能大

前缀和的性质决定了，一定是前面的越大越好，再结合 $ B_i \le B_{i+1}$，就得到了最优方案一定是尽量平均，也就是 $x,x,...,x+1,x+1$ 这样的形式

把每个 $B_i$ 看成一个区间，会有以下情况

$B_i \le B_{i+1}$ 满足性质

$B_i > B_{i+1}$ 需要尽量平均，也就是平均为一个新区间 $now: [x,x+1/x] $

下一个区间$ B_{i+2} $ 就要和 $now[1]$ 重复上面的比较

这个冲突合并可以用单调栈实现
```Go
func floorDiv(a, b int64) int64 {
	q := a / b
	r := a % b
	if r != 0 && a < 0 {
		q--
	}
	return q
}

func ceilDiv(a, b int64) int64 {
	q := a / b
	r := a % b
	if r != 0 && a > 0 {
		q++
	}
	return q
}
func solve(in *FastScanner, out *bufio.Writer) {
	n := in.NextInt()
	a := make([]int64, n+1)
	b := make([]int64, n+1)
	for i := 1; i <= n; i++ {
		a[i] = in.NextInt64() - int64(i)
	}

	cmp := func(a, b Pair[int64]) bool {
		return upperBySign(a.x, a.y) > lowerBySign(b.x, b.y)
	}
	// sum,len
	q := []Pair[int64]{}
	for i := 1; i <= n; i++ {
		now := Pair[int64]{a[i], 1}
		if len(q) == 0 || !cmp(q[len(q)-1], now) {
			q = append(q, now)
			continue
		}
		for len(q) != 0 && cmp(q[len(q)-1], now) {
			now = Pair[int64]{q[len(q)-1].x + now.x, q[len(q)-1].y + now.y}
			q = q[:len(q)-1]
		}
		q = append(q, now)
	}

	idx := int64(1)
	for _, val := range q {
		lo := floorDiv(val.x, val.y)
		hi := ceilDiv(val.x, val.y)
		r := val.x - lo*val.y

		for i := int64(0); i < val.y; i++ {
			if i < val.y-r {
				b[idx+i] = lo
			} else {
				b[idx+i] = hi
			}
		}
		idx += val.y
	}

	ans := int64(0)
	for i := 1; i <= n; i++ {
		a[i] = a[i-1] + a[i]
		b[i] = b[i-1] + b[i]
		ans += a[i] - b[i]
	}
	fmt.Fprintln(out, ans)
}
```