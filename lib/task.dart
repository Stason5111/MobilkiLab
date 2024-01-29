class Task {
  String name;
  bool isDone;

  Task(this.name, {this.isDone = false});

  Task.fromJson(String json) : name = json.split("###")[0], isDone = json.split("###")[1] == "true";

  String toJson() {
    return "$name###$isDone";
  }
}