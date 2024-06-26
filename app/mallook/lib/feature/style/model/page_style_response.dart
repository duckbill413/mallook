import 'package:mallook/feature/style/model/style.dart';

class PageStyleResponse {
  PageStyleResponse({
    this.size,
    this.content,
    this.number,
    this.sort,
    this.numberOfElements,
    this.pageable,
    this.first,
    this.last,
    this.empty,
  });

  PageStyleResponse.fromJson(dynamic json) {
    size = json['size'];
    if (json['content'] != null) {
      content = [];
      json['content'].forEach((v) {
        content?.add(Style.fromJson(v));
      });
    }
    number = json['number'];
    sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    numberOfElements = json['numberOfElements'];
    pageable =
        json['pageable'] != null ? Pageable.fromJson(json['pageable']) : null;
    first = json['first'];
    last = json['last'];
    empty = json['empty'];
  }
  int? size;
  List<Style>? content;
  int? number;
  Sort? sort;
  int? numberOfElements;
  Pageable? pageable;
  bool? first;
  bool? last;
  bool? empty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['size'] = size;
    if (content != null) {
      map['content'] = content?.map((v) => v.toJson()).toList();
    }
    map['number'] = number;
    if (sort != null) {
      map['sort'] = sort?.toJson();
    }
    map['numberOfElements'] = numberOfElements;
    if (pageable != null) {
      map['pageable'] = pageable?.toJson();
    }
    map['first'] = first;
    map['last'] = last;
    map['empty'] = empty;
    return map;
  }
}

class Pageable {
  Pageable({
    this.offset,
    this.sort,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.unpaged,
  });

  Pageable.fromJson(dynamic json) {
    offset = json['offset'];
    sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }
  int? offset;
  Sort? sort;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['offset'] = offset;
    if (sort != null) {
      map['sort'] = sort?.toJson();
    }
    map['pageNumber'] = pageNumber;
    map['pageSize'] = pageSize;
    map['paged'] = paged;
    map['unpaged'] = unpaged;
    return map;
  }
}

class Sort {
  Sort({
    this.empty,
    this.sorted,
    this.unsorted,
  });

  Sort.fromJson(dynamic json) {
    empty = json['empty'];
    sorted = json['sorted'];
    unsorted = json['unsorted'];
  }
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['empty'] = empty;
    map['sorted'] = sorted;
    map['unsorted'] = unsorted;
    return map;
  }
}
