---
title: Collections in Scala
author: Raffi Khatchadourian (based on "Scala for the Impatient" 2nd Edition by Cay Horstmann)
date: October 20, 2020
---

# Collections

## Main Collections Traits 

```plantuml
hide members
interface Iterable << trait >>
interface Seq << trait >>
interface Set << trait >>
interface Map << trait >>
interface IndexedSeq << trait >>
interface SortedSeq << trait >>
interface SortedMap << trait >>

Iterable <|-- Seq
Seq <|-- IndexedSeq
Iterable <|-- Set
Set <|-- SortedSeq
Iterable <|-- Map
Map <|-- SortedMap
```

## `Iterable`s

An `Iterable` is any collection that can yield an `Iterator`, which allows you to systematically access each element of the collection (see the [Iterator Pattern](https://en.wikipedia.org/wiki/Iterator_pattern)).

### Example

```scala
val coll = Array(1, 7, 2, 9) // some Iterable
val iter = coll.iterator
while (iter.hasNext)
  println(iter.next())
```

## `Seq`uences

- A `Seq` is an ordered sequence of values like an array or a `List`.
- An `IndexedSeq` allows fast random access through an integer index.

### Example

An `ArrayBuffer` is an `IndexedSeq` but a `LinkedList` is not.

## `Set`s

- A `Set` is an **ordered** collection of values.
- A `SortedSet` maintains an **sorted** visitation order.
    - Elements are traversed in sorted order.

## `Map`s

- A `Map` is a set of $(\mathit{key},\mathit{value})$ pairs.
- A `SortedMap` maintains a sorted visitation order by the keys.

## Constructing Collections

Each Scala collection trait or class has a companion object with an `apply` method that constructs instances of the collection.

### Example

```scala
Iterable(0xFF, 0xFF00, 0xFF0000)
Set(Color.RED, Color.GREEN, Color.BLUE)
Map(Color.RED -> 0xFF0000, Color.GREEN -> 0xFF00, Color.BLUE -> 0xFF)
SortedSet("Hello", "World")
```

## Converting Between Collection Types

- Can use `toSeq`, `toSet`, `toMap`, etc. to convert between collection types.
- There is also a *generic* `to[C]` for type `C` (the *target* collection type).

```scala
val col = mutable.ArrayBuffer(1, 1, 2, -4, 2, 100)
val set = col.toSet
val list = col.to[List]
```

## Mutable and Immutable Collections

- As we have seen previously, you can make both *mutable* and *immutable* collection objects.
- An *immutable* collection never changes.
  - Allows safe reference sharing in concurrent programs.
    - No data *races* since there are no (concurrent) data *writes*.

### Example

- `scala.collection.mutable.Map`
- `scala.collection.immutable.Map`

### Immutability Preference

The preference is to immutability.

#### Example

```scala
val map = Map("Hello" -> 42) // : Map[String, Int] = Map("Hello" -> 42)
map.getClass() // : Class[T] = class scala.collection.immutable.Map$Map1
```

## Using Immutable Collections

Compute the set of all digits of an integer:

```scala
def digits(n: Int): Set[Int] = n match {
    case _ if n < 0 => digits(-n)
    case _ if n < 10 => Set(n)
    case _ => digits(n / 10) + (n % 10)
}

digits(1729) // : Set[Int] = Set(1, 7, 2, 9)
```

## Sequences

```plantuml
hide members
interface Seq << trait >>
interface IndexedSeq << trait >>
Seq <|-- IndexedSeq
IndexedSeq <|.. Vector
IndexedSeq <|.. Range
Seq <|.. List
Seq <|.. Stream
Seq <|.. Stack
Seq <|.. Queue
```

- A `Vector` is the **immutable** equivalent of an `ArrayBuffer`. 
- A `Range` is an integer sequence, e.g., `1 to 10` or `10.to(30, 10)`.

## Lists

- A list is either `Nil` (empty) or an object with a `head` and a `tail`.
- The `tail` is *also* a `List`.
- Similar to the `car` and `cdr` operations in Lisp.

```scala
val lst = List(4, 2) // : List[Int] = List(4, 2)
lst.head // : Int = 4
lst.tail // : List[Int] = List(2)
lst.tail.head // : Int = 2
lst.tail.tail // : List[Int] = List()
```

### Creating `List`s

You can use `::` to create a `List` with a given `head` and `tail`:

```scala
9 :: List(4, 2)
9 :: 4 :: 2 :: Nil
9 :: (4 :: (2 :: Nil)) // right-associative.
```

- All of these create a `List(9, 4, 2)`.
- Similar to the `cons` operator in Lisp for constructing lists.

## Summing `List`s

Natural fit for recursion:

```scala
def sum(lst: List[Int]): Int =
  if (lst == Nil) 0 else lst.head + sum(lst.tail)

sum(List(9, 4, 2)) // : Int = 15
```

Use pattern matching:

```scala
def sum(lst: List[Int]): Int = lst match {
  case Nil => 0
  case h :: t => h + sum(t) // h is lst.head, t is lst.tail
}

sum(List(9, 4, 2)) // : Int = 15
```

This is just for demonstration purposes. Should really just use the built-in method:

```scala
List(9, 4, 2).sum // : Int = 15
```

## `Set`s

- A `Set` is an *unordered* collection of unique elements.
- Adding an element to a `Set` that already exists in the `Set` has no effect.

```scala
Set(2, 0, 1) + 1 == Set(2, 0, 1) // : Boolean = true
Set(2, 0, 1) + 4 == Set(2, 0, 1, 4) // : Boolean = true
```

- Ordering is *not* guaranteed.
- By default, implemented as *hash sets*.
  - Constant-time look-up.

### `LinkedHashSet`s

Elements are traversed in the order for which they were inserted:

```scala
val weekdays = scala.collection.mutable.LinkedHashSet("Mo", "Tu", "We", "Th", "Fr")
weekdays.mkString(", ") // : String = Mo, Tu, We, Th, F
```

### `SortedSet`s

Elements are traversed in the *sorted* order:

```scala
val nums = collection.immutable.SortedSet(5, 2, -2, 5, 2, -100)
nums.mkString(", ") // : String = -100, -2, 2, 5
```

## `Set` Operations

### Containment

```scala
val digits = Set(1, 7, 2, 9)
digits contains 0 // : Boolean = false
```

### Subset

```scala
Set(1, 2) subsetOf digits // : Boolean = true
```

### Union, Intersection, and Set Difference

```scala
val primes = Set(2, 3, 5, 7)
digits union primes // : Set[Int] = Set(5, 1, 9, 2, 7, 3)
digits & primes // : Set[Int] = Set(7, 2)
digits -- primes // : Set[Int] = Set(1, 9)
```