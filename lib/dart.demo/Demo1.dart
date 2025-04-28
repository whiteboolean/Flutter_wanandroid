
class Demo1 {
  int? _age;
  String? _name;

  // //默认构造
  // Demo1(){
  //
  // }

  //指定参数的构造
  // Demo1(String name,int age){
  //   _age = age;
  //   _name = name;
  // }

  Demo1(this._name ,this._age);

  //命名构造方法
  Demo1.withName(this._age,this._name);

  //final和const的区别
  //final是运行时确定的
  //const是编译期间确定的

}

void main(){

  Demo1 demo = Demo1("张三", 12);
  print(demo._name);

  Demo1 demo1 = Demo1.withName(12, "你好");
  demo1._name = "李四";
  print(demo1._name);

  final time = DateTime.now();
  print("time:$time");

  final pi = 3.14150354;
  print("pi:$pi");
}