% Inheritance Details in Scala
% <a href="mailto:raffi.khatchadourian@hunter.cuny.edu">Raffi Khatchadourian</a>
% September 22, 2020

# Inheritance Details

## Highlights

- `extends` and `final` keywords are similar to those in Java.
- Like Java, Scala supports only single-class inheritance.
- You must use the `override` keyword when you override a method.
    - This is similar to the `@Override` annotation in Java.
- You can override fields.

## Extending a Class

```scala
class Employee extends Person {
    var salary = 0.0
    // ...
}
```

## Overriding a Method

```scala
class Person(val name: String) {
    override def toString = s"${getClass.getName}[name=$name]"
}

val p = new Person("Juan")
println(p)
```

. . .

Outputs:
```
Person[name=Juan]
```

## Protected Fields and Methods

- Like C++ and Java, you can declare a member to be `protected`.
- The member is accessible from subclasses only.
    - Unlike Java, it is not "package protected."
    - Use *package objects* for that.

## Overriding Fields

Recall that a *field* in Scala consists of:

1. A private instance field.
1. Accessors/mutators for the field.

You can override a `val` (or parameterless `def`) with another `val` field of the same name.

Then, the subclass will have a private field and a public accessor, which overrides the one from the super class.

```scala
class Person(val name: String) {
    override def toString = s"${getClass.getName}[name=$name]"
}

class SecretAgent(codename: String) extends Person(codename) {
    override val name = "secret"
    override def toString = "shh"
}

val s = new SecretAgent("1234")
println(s)
```
. . .

Outputs:
```
shh
```

## Abstract Classes & Methods

Can also override an *abstract* `def` with a `val`:

```scala
abstract class Person {
    def id: Int // No implementataion, specific to each kind of person.
    // ...
}

/**
 * A concrete implementation of Person.
 */
class Student(override val id: Int) extends Person {
    // The student ID is supplied by the ctor.
    // ...
    override def toString = s"Student with ID: ${id}"
}

val s = new Student("54321")
println(s)
```

. . .

Outputs:
```
Student with ID: 54321
```

 `override` keyword not required when providing an implementation for an abstract method.

## Abstract Fields

Can also have *abstract* fields, i.e., fields without an initial value:

```scala
abstract class Person {
    val id: Int // No initializer---abstract field and accessor.
    var name: String // No initializer---abstract field, accessor, and mutator.
    // ...
}
```

- Class in Java bytecode has *no* fields.
- Concrete subclasses must "fill" these in:

```scala
class Employee(val id: Int) extends Person { // Has a concrete id property.
    var name = "John Doe"  // and a concrete name property that can be concretized.
    override def toString = s"Employee ${name} with ID: ${id}"
}

val e = new Employee(5)
println(e)
```

. . .

Outputs:
```
Employee John Doe with ID: 5
```
What if we did not override `name`? What would happen? 
