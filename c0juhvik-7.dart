import 'dart:io';
void main(){
  List<int> fixhossz=List<int>.filled(10, 0);
  for (var i = 0; i < 10; i+=2) {
    fixhossz[i] = 1;
  }
  print(fixhossz);

  //

  List<int> szamok=[];
  for (var i = 0; i < 10; i++) {
    szamok.add((i+1)%2);
  }
  print(szamok);

  //

  List<int> fibolist = [0,1];
  while(fibolist.last + fibolist[fibolist.length -2] < 30){
    fibolist.add(fibolist.last + fibolist[fibolist.length -2]);
  }
  print(fibolist);
  
  //

  print('a fibonacci lista hossza: ${fibolist.length}');

  print('a lista elso eleme: ${fibolist.first}');

  print('a lista utolso eleme: ${fibolist.last}');

  print('a lista harmadik eleme: ${fibolist[3]}');

  print('a lista nyolcadik eleme: ${fibolist.indexOf(8)}');

  print('a lista forditottja: ${fibolist.reversed.toList()}');

  print('a lista nem ures-e: ${fibolist.isNotEmpty}');

  fibolist.removeRange(0, fibolist.length);
  print('a lista: $fibolist, ures-e: ${fibolist.isNotEmpty}');
  fibolist.add(34);

  fibolist.addAll([1, 2, 3, 5, 7]);
  print(fibolist);

  fibolist.insertAll(fibolist.indexOf(34), [0, 1]);
  print(fibolist);

  fibolist.removeAt(fibolist.length-1);
  fibolist.addAll([8, 13, 21]);
  print(fibolist);

  fibolist.remove(fibolist.first);

  //

  List<int> fiboSquare = fibolist.map((item) => item*item).toList();
  print(fiboSquare);

  List<int> allFibo = fibolist.where((e) => e.isOdd).toList();
  allFibo.addAll(fibolist.where((e) => e.isOdd).toList());
  allFibo.sort((a, b) => a-b);
  print(allFibo);

  
  
}