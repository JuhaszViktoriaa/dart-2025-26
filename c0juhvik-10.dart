void main() {
//1.
  Map<String, List<String>> weekMap = {"Monday": ["workday", "remote workday", "national holiday"], "Tuesday": ["workday"], "Wednesday": ["remote workday"], "Thursday": ["workday"], "Friday": ["workday", "home office"], "Saturday": ["weekend", "family time"], "Sunday": ["weekend"]
  };

//2.
  print("kulcsok listaban:");
  print(weekMap.keys.toList());

  print("ertekek listaban (lista hossza is):");
  weekMap.values.forEach((v) {
    print("$v (hossz: ${v.length})");
  });

//3.
  weekMap["Wednesday"] = ["workday", "remote workday", "national holiday"];
  weekMap["Saturday"] = [];

//4.
  weekMap.removeWhere((key, value) => value.isEmpty);

//5.
  print("\nVégső weekMap tartalma:");
  weekMap.forEach((key, value) {
    print("$key : $value");
  });
}
