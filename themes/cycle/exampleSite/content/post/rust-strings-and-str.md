---
title: "Understanding Rust Strings and str inside structs."
date: 2020-01-08T10:26:02-05:00
lastmod: 2020-07-03T23:20:47-04:00
slug: rust-strings-and-str
excerpt: "Rust is a challenging language to work in coming from a more dynamic language like Javascript or Ruby. Here's a short breakdown of a compiler error message around Strings and ownership that stumped me for a bit."
---

Rust is a challenging language to work in coming from a more dynamic language like Javascript or Ruby. Here's a short breakdown of a compiler error message that stumped me for a bit.


# Background

First, some background about Rust. Rust is a strongly-typed language, which means variables and return values from functions usually require a type annotation that looks like this:

```rust
let favorite_number: u32 = 12;
```

The type annotation on the variable `favorite_number` is `u32`. This should look familiar to anyone who has used a strongly typed language before.

A struct in Rust is a way for the user to define any data type. Here's an example:

```rust
struct Config {
  name: String,
  id: u32
}
```

Here is how we would approximate this in Javascript:

```js
const config = {
  name: "Adam",
  id: 4
}
```

Notice how, in Javascript, we use an Object named `config` to hold some config for our application. In Rust, we create a `struct` called `Config` and define the various fields we need. Rust is strongly typed, so even the fields in the `Config` struct are type-annotated. Let's move to where I got tripped up.


# Stumped

I created a `Vector` (a mutable Array data structure) that contained a couple of instances of a struct. It looked something like this:

```rust
struct Example {
    id: String
}

fn main() {
    let example: Vec<Example> = vec![Example{id: "one".to_string()}, Example{id: "two".to_string()}];
    println!("{:?}", example);
}
```

So far, so good. However, I now wanted to `map` over the collection and create a new collection that just contained the `id`. Here's what I tried and what failed:

```rust
struct Example {
    id: String
}

fn main() {
    let example: Vec<Example> = vec![Example{id: "one".to_string()}, Example{id: "two".to_string()}];
    let map_fail: Vec<String> = example.iter().map(|item| item.id).collect();
    println!("{:?}", map_fail);
}
```

[Rust playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2018&gist=50f404dd47af19b0f4373fea1f7a3719)


# Understanding the problem

What's happening here? Well, the compiler message is instructive:

```shell
  error[E0507]: cannot move out of `item.id` which is behind a shared reference
    --> src/main.rs:10:59
      |
  10 |     let map_fail: Vec<String> = example.iter().map(|item| item.id).collect();
      |                                                           ^^^^^^^ move occurs because `item.id` has type `std::string::String`, which does not implement the `Copy` trait

  error: aborting due to previous error

  For more information about this error, try `rustc --explain E0507`.
```

In Rust there is no [Garbage collection](https://en.wikipedia.org/wiki/Garbage_collection_(computer_science)) (automatic memory management). Instead, Rust requires you, the programmer, to indicate to the Rust compiler [what variables have ownership over the value they represent](https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html). If that ownership moves in an invalid way, Rust will throw a compile error to prevent a memory error at runtime. The benefit in not having Garbage Collection is two-fold:

1. Faster code without a GC process.
2. Whole classes of bugs are impossible due to Rust's ownership rules.

In our error case, mapping over our vector moves the data stored at `id` to a new `Vector`. This shift to a new `Vector` means Rust can no longer guarantee the safety of that portion of memory. Let's look at the documentation around this error code from the compiler.

The [explainer page for this error](https://doc.rust-lang.org/stable/error-index.html#E0507) gives us three options:

> 1.  Try to avoid moving the variable.
> 2.  Somehow reclaim the ownership.
> 3.  Implement the Copy trait on the type.

\#3 sounded like too much for this specific case. #2 also seemed like the wrong approach because I didn't want to change the ownership, I just wanted a copy or reference to it. #1 was the right answer, but how do I avoid moving the variable?


# The Solution

This is where it's important to understand the two basic types for strings in Rust, `String` and `str`. The [doc page for `String`](https://doc.rust-lang.org/std/string/struct.String.html) states (I added the underlines for emphasis):

> The String type is the most common string type that has <span class="underline">ownership</span> over the contents of the string. It has a close relationship with its <span class="underline">borrowed</span> counterpart, the primitive str.

Aha, so we're dealing with a `String` here, and it sounds like we need a `str`. A quick glance at the `String` doc page again [reveals just the function we need: `as_str`](https://doc.rust-lang.org/std/string/struct.String.html#method.as_str). `as_str` gives us a reference [called a `slice`](https://doc.rust-lang.org/book/ch04-03-slices.html#string-slices) to the value of a `String`. Armed with this new knowledge, here's the solution to this compiler error:

```rust
struct Example {
    id: String
}

fn main() {
    let example: Vec<Example> = vec![Example{id: "one".to_string()}, Example{id: "two".to_string()}];
    println!("{:?}", example);

    let map_str: Vec<&str> = example.iter().map(|item| item.id.as_str()).collect();
    println!("{:?}", map_str);
}
```

[Rust playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2018&gist=fa5624ee76fbecafbe282de6190b079c)

# Fin

Rust has proven challenging to learn, but I think the journey and difficulty is worth it. Ownership, the type-system, and the excellent performance continue to impress me. I hope this post encourages folks to give Rust a try! I'm happy to answer any questions via the comments or [twitter](https://twitter.com/a_simpson) or wherever else.
