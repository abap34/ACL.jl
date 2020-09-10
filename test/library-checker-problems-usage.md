# library-checker-problemsを使う

https://github.com/yosupo06/library-checker-problems

上記を参考に。

```
$ git clone https://github.com/yosupo06/library-checker-problems.git
```

で、適当なディレクトリにおいておく（100 MB単位のテストファイルが生成されることもあるので余裕のあるストレージがよい）

使うためにはpythonとgcc/clangが必要なので注意。

あとは、```runtest.jl```中の```checker_path```を適宜変えるのみで、testができるようになる。