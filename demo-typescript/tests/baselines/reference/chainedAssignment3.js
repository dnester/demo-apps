//// [chainedAssignment3.ts]
class A {
    id: number;
}

class B extends A {
    value: string;
}

var a: A;
var b: B;
a = b = null;
a = b = new B();
b = a = new B();

a.id = b.value = null;

// error cases
b = a = new A();
a = b = new A();




//// [chainedAssignment3.js]
var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var A = /** @class */ (function () {
    function A() {
    }
    return A;
}());
var B = /** @class */ (function (_super) {
    __extends(B, _super);
    function B() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    return B;
}(A));
var a;
var b;
a = b = null;
a = b = new B();
b = a = new B();
a.id = b.value = null;
// error cases
b = a = new A();
a = b = new A();