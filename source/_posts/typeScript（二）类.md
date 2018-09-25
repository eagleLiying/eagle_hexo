# 类 classes

### 类的继承

类的继承是使用 extends：
```js
class Animal {
    name: string;
    constructor(theName: string) { this.name = theName; }
    move(distanceInMeters: number = 0) {
        console.log(`${this.name} moved ${distanceInMeters}m.`);
    }
}

class Snake extends Animal {
    constructor(name: string) { super(name); }
    move(distanceInMeters = 5) {
        console.log("Slithering...");
        super.move(distanceInMeters);
    }
}

class Horse extends Animal {
    constructor(name: string) { super(name); }
    move(distanceInMeters = 45) {
        console.log("Galloping...");
        super.move(distanceInMeters);
    }
}

let sam = new Snake("Sammy the Python");
let tom: Animal = new Horse("Tommy the Palomino");

sam.move();
tom.move(34);
```
执行结果：
```js
Slithering...
Sammy the Python moved 5m.
Galloping...
Tommy the Palomino moved 34m.
```

以上的例子是 Snake 和 Horse 继承自 Animal，而 Snake 和 Horse 就称为 <b>派生类 / 子类</b>，而 Animal 就被称为 <b>基类 / 超类</b>。

如果派生类内包含了构造函数，在构造函数中必须访问 `super()`，它会执行基类的构造函数。尤其是在调用 `this` 之前，使用`super` 进行重写了基类的 move 方法。



### Public, private, and protected modifiers

#### public 默认值
```
class Animal {
    public name: string;
    public constructor(theName: string) { this.name = theName; }
    public move(distanceInMeters: number) {
        console.log(`${this.name} moved ${distanceInMeters}m.`);
    }
}
```
#### private

当成员被标记成 private时，它就不能在声明它的类的外部访问。

```js
class Animal {
    private name: string;
    constructor(theName: string) { this.name = theName; }
}

new Animal("Cat").name; // 错误: 'name' 是私有的.
```

#### protected

1. protected 和 private 很相似，唯一不同的地方是 protected 成员在派生类中是可以被访问的。

```js
class Person {
    protected name: string;
    constructor(name: string) { this.name = name; }
}

class Employee extends Person {
    private department: string;

    constructor(name: string, department: string) {
        super(name)
        this.department = department;
    }

    public getElevatorPitch() {
    <!--在这里访问 this.name 是继承自基类的 name -->
        return `Hello, my name is ${this.name} and I work in ${this.department}.`;
    }
}

let howard = new Employee("Howard", "Sales");
console.log(howard.getElevatorPitch());
console.log(howard.name); // 错误，因为 name 是 Person  中的 name 被标识了 protected
```

2. 构造函数也可以被标记为 protected，这样的话这个类只能被继承，不能被包含他的类外面实例化。

对于 private 和 protected 申明的成员，如果要比较两个类型是否一样时就会出现不同。
例如：

```js
class Animal {
    private name: string;
    constructor(theName: string) { this.name = theName; }
}

class Rhino extends Animal {
    constructor() { super("Rhino"); }
}

class Employee {
    private name: string;
    constructor(theName: string) { this.name = theName; }
}

let animal = new Animal("Goat");
let rhino = new Rhino();
let employee = new Employee("Bob");

animal = rhino;
animal = employee; // 错误: Animal 与 Employee 不兼容.
```
因为 Employee 和 Animal 的 name 不是同一个 name

### readonly 修饰符

只读属性必须在声明时或构造函数里被初始化。

```js
class Octopus {
    readonly name: string;
    readonly numberOfLegs: number = 8;
    constructor (theName: string) {
        this.name = theName;
    }
}
let dad = new Octopus("Man with the 8 strong legs");
dad.name = "Man with the 3-piece suit"; // 错误! name 是只读的.
```

#### 参数属性

```js
/**
原来 name 的声明方式
*/
class Animal {
    private name：string;
    constructor(theName) { 
        this.name = thieName;
    }
    move(distanceInMeters: number) {
        console.log(`${this.name} moved ${distanceInMeters}m.`);
    }
}

/**
使用 参数属性声明变量
*/
class Animal {
    constructor(private name: string) { }
    move(distanceInMeters: number) {
        console.log(`${this.name} moved ${distanceInMeters}m.`);
    }
}
```

在构造函数里使用 ` private name: string ` 参数来创建和初始化 ` name ` 成员，把声明和赋值合并至一处

### 存取器

使用 `get` 和 `set` 设置成为一个存取器

```js
/*
    没有存取器
*/
class Employee {
    fullName: string;
}

let employee = new Employee();
employee.fullName = "Bob Smith";
if (employee.fullName) {
    console.log(employee.fullName);
}

/*
    通过 set 和 get 设置 存取器
*/
let passcode = "secret passcode";

class Employee {
    private _fullName: string;

    get fullName(): string {
        return this._fullName;
    }

    set fullName(newName: string) {
        if (passcode && passcode == "secret passcode") {
            this._fullName = newName;
        }
        else {
            console.log("Error: Unauthorized update of employee!");
        }
    }
}

let employee = new Employee();
employee.fullName = "Bob Smith";
if (employee.fullName) {
    alert(employee.fullName);
}

```
1. 存取器要求你将编译器设置为输出 ECMAScript 5 或更高。 不支持降级到 ECMAScript 3。
2. 只带有 get 不带有 set 的存取器自动被推断为 readonly。 这在从代码生成 .d.ts文件时是有帮助的，因为利用这个属性的用户会看到不允许够改变它的值。

### 静态属性

通过 static 关键字来设置，上面说的时只有在实例化之后才会初始化的值，静态属性是在类本身里面，它也可以通过 `this.` 来进行方法问。

例如：
```js
class Grid {
    static origin = {x: 0, y: 0};
    calculateDistanceFromOrigin(point: {x: number; y: number;}) {
        let xDist = (point.x - Grid.origin.x);
        let yDist = (point.y - Grid.origin.y);
        return Math.sqrt(xDist * xDist + yDist * yDist) / this.scale;
    }
    constructor (public scale: number) { }
}

let grid1 = new Grid(1.0);  // 1x scale
let grid2 = new Grid(5.0);  // 5x scale

console.log(grid1.calculateDistanceFromOrigin({x: 10, y: 10}));
console.log(grid2.calculateDistanceFromOrigin({x: 10, y: 10}));
```

### 抽象类

使用 abstract 声明。
```js
/* 
抽象类内部定义的抽象方法
*/
abstract class Animal {
    abstract makeSound(): void;
    move(): void {
        console.log('roaming the earch...');
    }
}
```

```js
abstract class Department {

    constructor(public name: string) {
    }

    printName(): void {
        console.log('Department name: ' + this.name);
    }

    abstract printMeeting(): void; // 必须在派生类中实现
}

class AccountingDepartment extends Department {

    constructor() {
        super('Accounting and Auditing'); // 在派生类的构造函数中必须调用 super()
    }

    printMeeting(): void {
        console.log('The Accounting Department meets each Monday at 10am.');
    }

    generateReports(): void {
        console.log('Generating accounting reports...');
    }
}

let department: Department; // 允许创建一个对抽象类型的引用
department = new Department(); // 错误: 不能创建一个抽象类的实例
department = new AccountingDepartment(); // 允许对一个抽象子类进行实例化和赋值
department.printName();
department.printMeeting();
department.generateReports(); // 错误: 方法在声明的抽象类中不存在
```
注意点：

1. 允许创建一个抽象对象类型
2. 抽象类不允许实例化
3. 允许对抽象类的子类进行实例化和赋值
4. 抽象类中的抽象方法不包含具体实现并且必须在派生类中实现。定义方法签名但不包含方法体。
5. 抽象方法必须包含 abstract关键字并且可以包含访问修饰符。


### 高级技巧

1. 构造函数

当你在 ts 中声明了一个类时，就同时声明了很多东西，

例如：
- 类的实例的 <b>类型</b>
- 构造函数，这个函数在这个类被 new 的时候调用


2. 把类当做接口使用
```js
class Point {
    x: number;
    y: number;
}

interface Point3d extends Point {
    z: number;
}

let point3d: Point3d = {x: 1, y: 2, z: 3};
```
