class SummaryCountModel {
  String? status;
  List<SummaryData>? data;

  SummaryCountModel({this.status, this.data});

  SummaryCountModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = json["data"] == null
        ? null
        : (json["data"] as List).map((e) => SummaryData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    if (data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }

  SummaryCountModel copyWith({
    String? status,
    List<SummaryData>? data,
  }) =>
      SummaryCountModel(
        status: status ?? this.status,
        data: data ?? this.data,
      );
}

class SummaryData {
  String? id;
  int? sum;

  SummaryData({this.id, this.sum});

  SummaryData.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    sum = json["sum"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["sum"] = sum;
    return _data;
  }

  SummaryData copyWith({
    String? id,
    int? sum,
  }) =>
      SummaryData(
        id: id ?? this.id,
        sum: sum ?? this.sum,
      );
}
