void main() {
  //1.
  Set<String> hetnapjai = {"hetfo", "kedd", "szerda", "csut", "pentek", "szombat", "vasarnap"};

  print("A het tartalma ${hetnapjai}");
  print("First Value is ${hetnapjai.first}");
  print("Last Value is ${hetnapjai.last}");
  print("Is fruits empty? ${hetnapjai.isEmpty}");
  print("Is fruits not empty? ${hetnapjai.isNotEmpty}");
  print("The length of fruits is ${hetnapjai.length}");
  print("Tartalmazza-e a szerdat ${hetnapjai.contains("szerda")}");
  print("Tartalmazza-e a szerdat ${hetnapjai.contains("Wednesday")}");

//2.
  Set<String> napok = {"hetfo", "kedd", "szerda", "csut", "pentek", "szombat", "vasarnap"};
  Set<String> lista = { "workday", "weekend", "holiday", "public holiday", "bank holiday", "national holiday", "religious holiday", "federal holiday", "school holiday", "company holiday", "floating holiday", "seasonal holiday", "observed holiday", "half-day", "flexible day", "personal day", "sick day", "leave of absence", "vacation day", "remote workday"
  };
  napok.addAll(lista);
  print("After adding: $napok");


//3.
  Set<String> week = {"hetfo", "kedd", "szerda", "csut", "pentek", "szombat", "vasarnap"};
  for (var e in week) {
    print(e);
  }

//4.
  Set<String> weekdays = {"hetfo", "kedd", "szerda", "csut", "pentek", "szombat", "vasarnap"};
  Set<String> schoolDays = {"hetfo", "kedd", "szerda", "csut", "pentek"};

  print("Week: $weekdays");
  print("School days: $schoolDays");

//5.
  print("Week hossz: ${weekdays.length}");
  print("SchoolDays hossz: ${schoolDays.length}");

  print("Week - SchoolDays különbség: ${weekdays.difference(schoolDays)}");
  print("SchoolDays - Week különbség: ${schoolDays.difference(weekdays)}");
  List<String> weekList = weekdays.toList();

  List<int> indexek = [2, 3, 7, 11, 13];
  for (var i in indexek) {
    try {
      print("$i.: ${weekList[i]}");
    } catch (e) {
      print("Hiba: nincs $i. indexű elem a listában (${e.runtimeType})");
    }
  }
}
