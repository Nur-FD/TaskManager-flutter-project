class TaskListModel {
  String? status;
  List<TaskData>? data;

  TaskListModel({this.status, this.data});

  TaskListModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = json["data"] == null
        ? null
        : (json["data"] as List).map((e) => TaskData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    if (data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }

  TaskListModel copyWith({
    String? status,
    List<TaskData>? data,
  }) =>
      TaskListModel(
        status: status ?? this.status,
        data: data ?? this.data,
      );
}

class TaskData {
  String? id;
  String? title;
  String? description;
  String? status;
  String? createdDate;

  TaskData({this.id, this.title, this.description, this.status, this.createdDate});

  TaskData.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    title = json["title"];
    description = json["description"];
    status = json["status"];
    createdDate = json["createdDate"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["title"] = title;
    _data["description"] = description;
    _data["status"] = status;
    _data["createdDate"] = createdDate;
    return _data;
  }

  TaskData copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? createdDate,
  }) =>
      TaskData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        status: status ?? this.status,
        createdDate: createdDate ?? this.createdDate,
      );
}
